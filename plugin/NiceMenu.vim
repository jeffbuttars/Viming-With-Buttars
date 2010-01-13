
if exists('g:loaded_nice_menu')
  finish
elseif v:version < 702
  echoerr 'NiceMenu does not support this version of vim (' . v:version . ').'
  finish
endif
let g:loaded_nice_menu = 1

" The delay from when typing stops to when
" a completions is should
if ! exists( 'g:NiceMenuDelay' )
	let g:NiceMenuDelay = '.8' 
endif

" The minimum number of characters in word
" needed before a completions will be presented.
if ! exists( 'g:NiceMenuMin' )
	let g:NiceMenuMin = 3 
endif


" only pop completion if one of these chars is to the
" left of the cursor.
" We should make these regexs? To slow? We should try.
" a-zA-Z0-9 . -> - _ $
" We should also have different classes of mappings and be able to chain them
" per file type. So a ftype can have classes A,B,C chained in that order. And
" perform a completion type performed by first matching class type and then
" fail back on a default(<C-N). We should have a global catch all chain to handle
" things like file path completions.
"let s:contextMap = [
	"\ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
	"\ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
	"\ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
	"\ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	"\ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
	"\ '-', '_', '.', '$','\<C-H>', '\<Space>' ]

let s:complPos = [0,0,0,0]

" Maybe we should have a cancel map. Characters that when typed will
" cancel any timers/completions and not set a new timer?
"
" Need some fixes so if a completion starts the user can type away
" without a completion getting in the way. I think popup_it has
" some of this fixing logic.

" specify the minimum 'word' length the must be present
" before we complete
"let s:minContextLen = 3

function! NiceMenu_is_file_path(cur_text)
    "if !g:NeoComplCache_TryFilenameCompletion || ((has('win32') || has('win64')) && &filetype == 'tex')
        "return -1
    "endif

    " Not Filename pattern.
    if a:cur_text =~ '[*/\\][/\\]\f*$\|[^[:print:]]\f*$\|/c\%[ygdrive/]$'
        return -1
    endif

    let l:PATH_SEPARATOR = (has('win32') || has('win64')) ? '/\\' : '/'
    " Filename pattern.
    let l:pattern = printf('[/~]\?\%%(\\.\|\f\)\+[%s]\%%(\\.\|\f\)*$', l:PATH_SEPARATOR)

    let l:cur_keyword_pos = match(a:cur_text, l:pattern)
    "if len(matchstr(a:cur_text, l:pattern)) < g:NeoComplCache_KeywordCompletionStartLength
        "return -1
    "endif

    return l:cur_keyword_pos
endfunction


function NiceMenu_enable()
	call s:mapForMappingDriven()
endfunction

function s:mapForMappingDriven()
  call s:unmapForMappingDriven()
	let s:keysMappingDriven = s:contextMap
  for key in s:keysMappingDriven
    execute printf('inoremap <silent> %s %s<C-r>=<SID>NiceMenuCheckContext()<CR>',
          \        key, key)
  endfor
endfunction

function s:unmapForMappingDriven()
  if !exists('s:keysMappingDriven')
    return
  endif
  for key in s:keysMappingDriven
    execute 'iunmap ' . key
  endfor
  let s:keysMappingDriven = []
endfunction

function s:getCurrentChar()
	return strpart( getline('.'), col('.')-2, 1)
endfunction

"
function s:getCurrentWord()
  return matchstr(s:getCurrentText(), '\k*$')
endfunction

"
function s:getCurrentText()
  return strpart(getline('.'), 0, col('.') - 1)
endfunction

function! s:CheckContext()
	if pumvisible() || &paste || ('i' != mode() )
		return 0 
	endif


	" only complete if context is correct.
	"let inContext = 0 
	"let curChar = s:getCurrentChar() 

	"for char in s:contextMap
		"if char == curChar
			"let inContext = 1 
			"break
		"endif
	"endfor	

	"if 1 != inContext
		"return 0 
	"endif

	return 1
endfunction

function! s:charIsMapped()
	
	let cur_char = getCurrentChar()
	for char in s:contextMap
		if cur_char == char
			return 1 
		endif
	endfor

	return 0
endfunction

function! NiceMenuAsyncCpl()
	"call s:feedPopup()
	
	" Make sure the pos is the same as when this
	" was started.
	let l:npos = getpos(".")

	if l:npos[1] != s:complPos[1] || l:npos[2] != s:complPos[2] || l:npos[3] != s:complPos[3]
		return ""
	endif

	if 1 != s:CheckContext()
		return ""
	endif

	" Make sure we're next to an acceptable
	" char. Pretty ghetto right now, we look
	" through the entire map. We should use
	" regex
	"if 1 != charIsMapped()
		"return ""
	"endif

	let l:compl = "\<C-X>\<C-N>"

	let line = s:getCurrentWord()

	if exists('&omnifunc') && &omnifunc != ''

		if NiceMenu_is_file_path(line)
			let l:compl = "\<C-X>\<C-F>"
		"elseif match( line, '\k->$' ) > 0 || match( line, '\k\.$' ) > 0
		elseif match( line, '\k$' ) > 0
			" Test the complete function before setting it.
			let compl_res = call( &omnifunc, [1,''] )
			if compl_res > 0
				let l:compl = "\<C-X>\<C-O>"
			endif
		endif

		return
	endif

	call feedkeys( l:compl, 't')
endfunction

python << PEOF
# Set up globals and define some def
import vim,threading,subprocess
ptimer = None

def NiceMenuShowMenu():

	sname = vim.eval( 'v:servername' )
	if not sname or sname == "":
		return

	try:
		dnull = open( '/dev/null' , 'w' )
		subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-expr", "NiceMenuAsyncCpl()"],
	  		stdout=dnull, stderr=dnull )
	except:
		pass
PEOF
"
"NiceMenuCheckContext: {{{1
fun! s:NiceMenuCheckContext()
	
	"if 1 != s:CheckContext()
		"return ""
	"endif
	
	" Only if current word/text is of a min length
	let l:cline = s:getCurrentText()
	let l:cword = s:getCurrentWord()
	if strlen(l:cword) < g:NiceMenuMin
		return "" 
	endif

	if pumvisible() || &paste || ('i' != mode() )
		return "" 
	endif

	let s:complPos = getpos(".")

python << PEOF
global ptimer
if ptimer:
	ptimer.cancel()

delay = vim.eval("g:NiceMenuDelay")
if not delay:
	delay = '.8'
ptimer = threading.Timer( float(delay), NiceMenuShowMenu )
ptimer.start()
PEOF
	return ""
endfun

call NiceMenu_enable()

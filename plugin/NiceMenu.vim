
if exists('g:loaded_nice_menu')
  finish
elseif v:version < 702
  echoerr 'NiceMenu does not support this version of vim (' . v:version . ').'
  finish
endif
let g:loaded_nice_menu = 1

"if exists('g:loaded_autoload_nice_menu') || v:version < 702
  "finish
"endif
"let g:loaded_autoload_nice_menu = 1

" only pop completion if one of these chars is to the
" left of the cursor.
" We should make these regexs? To slow? We should try.
" a-zA-Z0-9 . -> - _ $
" We should also have different classes of mappings and be able to chain them
" per file type. So a ftype can have classes A,B,C chained in that order. And
" perform a completion type performed by first matching class type and then
" fail back on a default(<C-N). We should have a global catch all chain to handle
" things like file path completions.
let s:contextMap = [
	\ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
	\ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
	\ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
	\ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	\ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
	\ '-', '_', '.', '$', ]

" specify the minimum 'word' length the must be present
" before we complete
let s:minContextLen = 3

function! NiceMenu#is_file_path(cur_text)
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


function NiceMenu#enable()
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
	let inContext = 0 
	let curChar =  strpart( getline('.'), col('.')-2, 1)

	for char in s:contextMap
		if char == curChar
			let inContext = 1 
			break
		endif
	endfor	

	if 1 != inContext
		return 0 
	endif

	return 1
endfunction

function! NiceMenuAsyncCpl()
	"call s:feedPopup()

	if 1 != s:CheckContext()
		return ""
	endif

	let line = s:getCurrentWord()
	if exists('&omnifunc') && &omnifunc != ''

		if NiceMenu#is_file_path(line)
			call feedkeys("\<C-X>\<C-F>", 't')
		elseif match( line, '\k->$' ) > 0 || match( line, '\k\.$' ) > 0
			call feedkeys("\<C-X>\<C-O>", 't')
		endif

		return
	endif
	
	call feedkeys("\<C-N>", 't')
	
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
	if pumvisible() || &paste || ('i' != mode() )
		return 0 
	endif

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

call NiceMenu#enable()

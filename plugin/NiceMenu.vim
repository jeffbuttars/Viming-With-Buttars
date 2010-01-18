
if exists('g:loaded_nice_menu')
  finish
elseif v:version < 700
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
let s:contextMap = [
	\ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
	\ 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
	\ 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
	\ 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
	\ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
	\ '-', '_', '.', '$', '<', '>' ]
	"\ '-', '_', '.', '$', '\<c-h>', '\<Space>', '<' ]

let s:complPos = [0,0,0,0]

" Maybe we should have a cancel map. Characters that when typed will
" cancel any timers/completions and not set a new timer?
"
" Need some fixes so if a completion starts the user can type away
" without a completion getting in the way. I think popup_it has
" some of this fixing logic.

"function s:mapForMappingDriven()
	"call s:unmapForMappingDriven()
	"let s:keysMappingDriven = s:contextMap
	"for key in s:keysMappingDriven
	"execute printf('inoremap <silent> %s %s<c-r>=<SID>NiceMenuCompl()<CR>', key, key)
	"endfor

	"for key in s:keysMappingDriven
		"if maparg(key, 'i') == ''
			"exec "silent! inoremap ".key." ".key.
						"\ "\<c-r>=<SID>NiceMenuCompl()\<cr>"
		"endif
	"endfor
"endfunction


" specify the minimum 'word' length the must be present
" before we complete
"let s:minContextLen = 3

" THIS DOEN'T WORK
function! NiceMenu_is_file_path(cur_text)

    let l:is_win = has('win32') || has('win64')

    " Not Filename pattern.
    if a:cur_text =~ '[/\\][/\\]\f*$\|[^[:print:]]\f*$\|/c\%[ygdrive/]$\|\\|$\|^\a:$'
		echo "NiceMenu_is_file_path() nope 0"
        return -1
    endif
    " Not Filename pattern.
    "if a:cur_text =~ '[*/\\][/\\]\f*$\|[^[:print:]]\f*$\|/c\%[ygdrive/]$'
		"echo "NiceMenu_is_file_path() nope 0"
        "return -1
    "endif

    "let l:PATH_SEPARATOR = (has('win32') || has('win64')) ? '/\\' : '/'
    " Filename pattern.
    "let l:pattern = printf('[/~]\?\%%(\\.\|\f\)\+[%s]\%%(\\.\|\f\)*$', l:PATH_SEPARATOR)
	let l:pattern = '[~]\?\%(\\[^[:alnum:].-]\|\f\|\*\)\+'

    let l:cur_keyword_pos = match(a:cur_text, l:pattern)
    let l:cur_keyword_str = a:cur_text[l:cur_keyword_pos :]
    if len(l:cur_keyword_str) < g:NiceMenuMin
		echo "NiceMenu_is_file_path() nope 1 ".len(l:cur_keyword_str)
        return -1
    endif
	
    " Not Filename pattern.
    if l:is_win && l:cur_keyword_str =~ '|\|^\a:[/\\]\@!\|\\[[:alnum:].-]'
		echo "NiceMenu_is_file_path() nope win 0"
        return -1
    elseif l:is_win && &filetype == 'tex' && l:cur_keyword_str =~ '\\'
		echo "NiceMenu_is_file_path() nope win 1"
        return -1
    elseif l:cur_keyword_str =~ '\*\*\|^{}'
		echo "NiceMenu_is_file_path() nope 3"
        return -1
    endif

    "let l:cur_keyword_pos = match(a:cur_text, l:pattern)
    "if len(matchstr(a:cur_text, l:pattern)) < g:NiceMenuMin
		"echo "NiceMenu_is_file_path() nope 1 ".len(matchstr(a:cur_text, l:pattern))
        "return -1
    "endif
    "" Skip directory.
    "if neocomplcache#is_auto_complete()
        "let l:dir = matchstr(l:cur_keyword_str, '^/\|^\a\+:')
        "if l:dir == ''
            "let l:dir = getcwd()
        "endif
        
        "if has_key(s:skip_dir, getcwd())
            "return -1
        "endif
    "endif

	"echo "NiceMenu_is_file_path() yes ".len(l:cur_keyword_str)
	"return len(l:cur_keyword_str)
	echo "NiceMenu_is_file_path() yes ".l:cur_keyword_pos
    return l:cur_keyword_pos
endfunction



"function s:unmapForMappingDriven()
  "if !exists('s:keysMappingDriven')
    "return
  "endif
  "for key in s:keysMappingDriven
    "execute 'iunmap ' . key
  "endfor
  "let s:keysMappingDriven = []
"endfunction

function s:getCurrentChar()
	return strpart( getline('.'), col('.')-2, 1)
endfunction

function s:getNextChar()
	return strpart( getline('.'), col('.')-1, 1)
endfunction

function s:getOmniWord( spoint )
	return strpart( getline('.'), a:spoint, col('.')-1)
endfunction

"
function s:getCurrentWord()
  return matchstr(s:getCurrentText(), '\k*$')
endfunction

"
function s:getCurrentText()
  return strpart(getline('.'), 0, col('.') - 1)
endfunction

function! NiceMenuCheckContext()
	if pumvisible() || &paste || ('i' != mode())
		"echo "NiceMenuCheckContext bad mode"
		return 0 
	endif

	" Make sure the pos is the same as when this
	" was started.
	let l:npos = getpos(".")
	if l:npos[1] != s:complPos[1] || l:npos[2] != s:complPos[2] || l:npos[3] != s:complPos[3]
		"echo "NiceMenuCheckContext bad pos " l:npos ":" s:complPos
		return 0 
	endif

	" Sure the next character is whitespace.
	" This is to help prevent doing a completion
	" in the middle of a word.
	" TODO: Needs to be a config param.
	if (strlen(s:getNextChar()) > 0) && s:getNextChar() !~ '\s'
		"echo "NiceMenuCheckContext bad next char: '" s:getNextChar() "'"
		return 0
	endif

	let curChar = s:getCurrentChar() 
	"echo "checking: " curChar
	let inContext = 0
	if index( s:contextMap, curChar)
		let inContext = 1 
	endif
	"for char in s:contextMap
		"if char == curChar
			"let inContext = 1 
			"break
		"endif
	"endfor	

	"echo "NiceMenuCheckContext inContext " inContext
	return inContext 
endfunction

function! NiceMenuAsyncCpl()
	"echo "NiceMenuAsyncCpl()"
	"

	if 1 != NiceMenuCheckContext()
		"echo "NiceMenuAsyncCpl() bad context"
		return ""
	endif

	let l:compl = "\<C-X>\<C-N>"

	let cword = s:getCurrentWord()

	if exists('&omnifunc') && &omnifunc != ''
		"echo "NiceMenu_is_file_path() ".NiceMenu_is_file_path(cword)
		"return ""

		"if NiceMenu_is_file_path(cword)
			"let l:compl = "\<C-X>\<C-F>"
			"elseif match( cword, '\k->$' ) > 0 || match( cword, '\k\.$' ) > 0
			"if match( cword, '\k$' ) > 0
		"elseif match( cword, '\k$' ) > 0
		if match( cword, '\k$' ) > 0 || match( cword, '\k->$' ) > 0 || match( cword, '\k\.$' ) > 0
			" Test the complete function before setting it.
			let compl_res = call( &omnifunc, [1,''] )
			if -1 != compl_res
				let compl_list = call( &omnifunc, [0,s:getOmniWord(compl_res)] )
				if ! empty(compl_list)
					let l:compl = "\<C-X>\<C-O>"
			endif

		endif

	endif

	 "If a <c-n> doesn't work, try the dictionary.
		"let compl_res = call( &omnifunc, [1,''] )
		"if -1 != compl_res
			"let compl_list = call( &omnifunc, [0,s:getOmniWord(compl_res)] )
			"if ! empty(compl_list)
				"let l:compl = "\<C-X>\<C-O>"
		"endif

	" Select first option without inserting it's text 
	" TODO: This should be a configurable option.
	set completeopt -= menu
	set completeopt += menuone
	let l:compl .= "\<C-P>"

	call feedkeys( l:compl, 't')
endfunction

python << PEOF
# Set up globals and define some def
import vim,threading,subprocess
ptimer = None

def NiceMenuShowMenu():

	#print 'NiceMenuShowMenu' 

	#if 'i' != vim.eval('mode()'):
	#print 'NiceMenuShowMenu bad context' 
	#	return

	sname = vim.eval( 'v:servername' )
	if not sname or sname == "":
		print 'NiceMenuShowMenu bad sname' 
		return

	try:
		dnull = open( '/dev/null' , 'w' )
		subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-expr", "NiceMenuAsyncCpl()"],
	  		stdout=dnull, stderr=dnull )
	except:
		print 'NiceMenuShowMenu except' 
		pass
PEOF
"
"NiceMenuCompl: {{{1
"fun! s:NiceMenuCompl()
fun! NiceMenuCompl( need_i )
	
	"echo "s:NiceMenuCompl"

	if pumvisible() || &paste || (('i' != mode()) && a:need_i )
		return "" 
	endif
	

	" Only if current word/text is of a min length
	let l:cline = s:getCurrentText()
	let l:cword = s:getCurrentWord()
	if strlen(l:cword) < g:NiceMenuMin
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

function! s:NiceMenuCancel()
python << PEOF
global ptimer
if ptimer:
	ptimer.cancel()

PEOF
endfunction

function NiceMenu_enable()
	"call s:mapForMappingDriven()
	autocmd InsertEnter  * call NiceMenuCompl(0)
	autocmd InsertLeave  * call s:NiceMenuCancel()
	autocmd CursorMovedI * call NiceMenuCompl(1)
endfunction

call NiceMenu_enable()

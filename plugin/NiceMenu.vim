
if exists('g:loaded_nice_menu')
  finish
elseif v:version < 700
  echoerr 'NiceMenu does not support this version of vim (' . v:version . ').'
  finish
endif
let g:loaded_nice_menu = 1

" The delay from when typing stops to when
" a completions is should. Defaults to the vim
" timeout variable.
if ! exists( 'g:NiceMenuDelay' )
	"let g:NiceMenuDelay = "0.8"
	let g:NiceMenuDelay = &timeout 
endif

" The minimum number of characters in word
" needed before a completions will be presented.
if ! exists( 'g:NiceMenuMin' )
	let g:NiceMenuMin = 3 
endif

if ! exists( 'g:NiceMenuDefaultCompl' )
	let g:NiceMenuDefaultCompl = "\<C-X>\<C-N>" 
endif


" only pop completion if one of these chars is to the
" left of the cursor.
" We should also have different classes of mappings and be able to chain them
" per file type. So a ftype can have classes A,B,C chained in that order. And
" perform a completion type performed by first matching class type and then
" fail back on a default(<C-N). We should have a global catch all chain to handle
" things like file path completions.
let s:contextRegx = '[a-zA-Z0-9_<>:\-\.\$]' 

au BufRead * let b:complPos = [0,0,0,0]

" specify the minimum 'word' length the must be present
" before we complete
"let s:minContextLen = 3
"
" Private Helper:
" getSynName:
" get the syntax type under the cursor
"{{{1
function! s:getSynName()
	return synIDattr(synID(line("."), col("."), 0), "name" )
endfunction	
"1}}}

" Private Helper:
" inString
"{{{1
function! s:inString()

	if s:getSynName()  =~? 'String'
		return 1
	endif

	return 0
endfunction
"1}}}

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
    if len(l:cur_keyword_str) < s:getWordMin() 
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
    "if len(matchstr(a:cur_text, l:pattern)) < s:getWordMin() 
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

function! s:getWordMin()
	if exists( 'b:NiceMenuMin' )
		return b:NiceMenuMin
	endif

	return g:NiceMenuMin
endfunction

function! s:getDefaultCompl()
	if exists( 'b:NiceMenuDefaultCompl' )
		return b:NiceMenuDefaultCompl
	endif

	return g:NiceMenuDefaultCompl
endfunction

function! NiceMenuGetDelay()
	if exists( 'b:NiceMenuDelay' )
		return b:NiceMenuDelay
	endif

	return g:NiceMenuDelay
endfunction

function s:getCurrentChar()
	return strpart( getline('.'), col('.')-2, 1)
endfunction

function s:getNextChar()
	return strpart( getline('.'), col('.')-1, 1)
endfunction

function s:getOmniWord( spoint )
	"return strpart( getline('.'), a:spoint, col('.')-1)
	return strpart( getline('.'), a:spoint, col('.'))
endfunction

function s:getCurrentWord()
	"return matchstr(s:getCurrentText(), '\k*$')

	let l:wlist = split( strpart(getline('.'), 0, col('.')), '\s' )
	if empty( l:wlist )
		return ""
	endif

	return l:wlist[ -1 ]
endfunction

function s:getCurrentText()
  return strpart(getline('.'), 0, col('.') - 1)
endfunction

" Private Helper:
" getSynName:
" get the syntax type under the cursor
"{{{1
"function! s:getSynName()
	"return synIDattr(synID(line("."), col("."), 0), "name" )
"endfunction	
"1}}}

" Private Helper:
" inString
" Param: thechar the quote character that's been double tapped.
" See if the cursor is inside a string according the current syntax definition
"{{{1
function! s:inString()

	" This will often contain whether we are in a single or double quote
	" string. How that is represented seems syntax specific, not standard.
	" We still leverage that knowledge if we can.
	return synIDattr(synID(line("."), col("."), 0), "name" ) =~? 'string'
endfunction
"1}}}


	"word		the text that will be inserted, mandatory
	"abbr		abbreviation of "word"; when not empty it is used in
			"the menu instead of "word"
	"menu		extra text for the popup menu, displayed after "word"
			"or "abbr"
	"info		more information about the item, can be displayed in a
			"preview window
	"kind		single letter indicating the type of completion
	"icase		when non-zero case is to be ignored when comparing
			"items to be equal; when omitted zero is used, thus
			"items that only differ in case are added
	"dup		when non-zero this match will be added even when an
			"item with the same word is already present.
"TODO: make the number of spell returns configurable.
function! s:checkSpell( word )

	let l:spug = spellsuggest( a:word, 50 )
	let l:clist = [] 

	if ! empty( l:spug )
		for item in l:spug
			let l:clist += [{'word':item, 'menu':' | sp', 'dup':0}]
		endfor
	endif

	return l:clist
endfunction

function! NiceMenuCheckContext()
	if pumvisible() || &paste || ('i' != mode())
		"echo "NiceMenuCheckContext bad mode"
		return 0 
	endif

	" Make sure the pos is the same as when this
	" was started.
	let l:npos = getpos(".")
	if l:npos[1] != b:complPos[1] || l:npos[2] != b:complPos[2] || l:npos[3] != b:complPos[3]
		"echo "NiceMenuCheckContext bad pos " l:npos ":" b:complPos
		return 0 
	endif

	" Sure the next character is whitespace.
	" This is to help prevent doing a completion
	" in the middle of a word.
	" TODO: Needs to be a config param.
	let l:nextChar = s:getNextChar()
	
	if (strlen(l:nextChar) > 0) && l:nextChar !~ '\s' && l:nextChar !~ '\W'
		"echo "NiceMenuCheckContext bad next char: '" s:getNextChar() "'"
		return 0
	endif

	let curChar = s:getCurrentChar() 
	"echo "checking: " curChar
	if curChar !~ s:contextRegx
		return 0
	endif

	"TODO: make optional
	"If we're inside a string, don't try to complete
	if s:inString()
		return 0
	endif

	"echo "NiceMenuCheckContext inContext 0"
	return 1 
endfunction

function! NiceMenuComplCleanup()

	if 'i' == mode() && pumvisible()
		return "\<C-P>"
	endif

	return ""
endfunction

function! NiceMenuAsyncCpl()
	"echo "NiceMenuAsyncCpl()"
	
	
	if 0 == NiceMenuCheckContext()
		"echo "NiceMenuAsyncCpl() bad context"
		return ""
	endif
	
	let l:compl = s:getDefaultCompl() 

	let cword = s:getCurrentWord()

	if exists('&omnifunc') && &omnifunc != '' && (! s:inString())
		"echo "NiceMenu_is_file_path() ".NiceMenu_is_file_path(l:cword)
		"return ""
		"if NiceMenu_is_file_path(l:cword)
			"let l:compl = "\<C-X>\<C-F>"
			"elseif match( l:cword, '\k->$' ) > 0 || match( l:cword, '\k\.$' ) > 0
			"if match( l:cword, '\k$' ) > 0
		"elseif match( l:cword, '\k$' ) > 0
		"if match( l:cword, '\k$' ) > 0 || match( l:cword, '\k->$' ) > 0 || match( l:cword, '\k\.$' ) > 0
		if match( l:cword, '\k$' ) > 0 || match( l:cword, '->$' ) > 0 || match( l:cword, '\.$' ) > 0
		"if 1 
			" Test the complete function before setting it.
			let l:compl_res = call( &omnifunc, [1,''] )
			if -1 != l:compl_res

				let l:compl_list = call( &omnifunc, [0,s:getOmniWord(l:compl_res)] )
				if ! empty(l:compl_list)
					let l:compl = ""
					call complete( l:compl_res + 1, l:compl_list )

					let b:NiceMenu_has_shown = 1
					return "\<C-P>"

					"let l:compl = "\<C-X>\<C-O>"
				endif
			endif
		endif
	endif

	"TODO: Make this optional
	"Fail back to a spelling check.
	"if &spell
		"let l:spug = s:checkSpell( l:cword )
		"if ! empty( l:spug )
			"let l:compl = ""
		
			"if ! empty( l:spug )
				"call complete( col('.') - strlen(l:cword), l:spug )
			"endif
		"endif
	"endif	

	 "If a <c-n> doesn't work, try the dictionary.
		"let compl_res = call( &omnifunc, [1,''] )
		"if -1 != compl_res
			"let compl_list = call( &omnifunc, [0,s:getOmniWord(compl_res)] )
			"if ! empty(compl_list)
				"let l:compl = "\<C-X>\<C-O>"
		"endif
	
	" Select first(original typed text) option without inserting it's text 
	" TODO: This should be a configurable option.
	let l:compl .= "\<C-P>"

	let b:NiceMenu_has_shown = 1
	return l:compl
endfunction

python << PEOF
# Set up globals and define some def
import vim,threading,subprocess
ptimer = None

def NiceMenuShowMenu():

	#print 'NiceMenuShowMenu' 

	if 'i' != vim.eval('mode()'):
		#print 'NiceMenuShowMenu bad context' 
		return

	sname = vim.eval( 'v:servername' )
	if not sname or sname == "":
		print 'NiceMenuShowMenu bad sname' 
		return

	try:
		#dnull = open( '/dev/null' , 'w' )
		#subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-expr", "NiceMenuAsyncCpl()"],
		#subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-send", '<C-R>=NiceMenuAsyncCpl()<CR>'],
	  		#stdout=dnull, stderr=dnull )
		subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-send", '<C-R>=NiceMenuAsyncCpl()<CR>'] )
	except:
		print 'NiceMenuShowMenu except' 
		pass
PEOF

function! s:NiceMenuCancel()
	"echo "s:NiceMenuCancel"
python << PEOF
global ptimer
if ptimer:
	ptimer.cancel()
PEOF
endfunction


"NiceMenuCompl: {{{1
"fun! s:NiceMenuCompl()
fun! s:NiceMenuCompl( need_i )
	
	"echo "s:NiceMenuCompl " s:getCurrentChar()

	if pumvisible() || &paste || (('i' != mode()) && a:need_i )
		return "" 
	endif


	if exists( 'b:NiceMenu_has_shown' ) && 1 == b:NiceMenu_has_shown
		let b:NiceMenu_has_shown = 0
		return ""
	endif

	" If we're in the same spot as the last trigger, don't show the menu
	" again.
	let l:npos = getpos(".")
	if l:npos[1] == b:complPos[1] && l:npos[2] == b:complPos[2] && l:npos[3] == b:complPos[3]
		"echo "NiceMenuCheckContext bad pos " l:npos ":" b:complPos
		return "" 
	endif
	

	" Only if current word/text is of a min length
	let l:cline = s:getCurrentText()
	let l:cword = s:getCurrentWord()
	if strlen(l:cword) < s:getWordMin() 
		"echo "s:NiceMenuCompl word to short"
		return "" 
	endif

	" If it's just a number, don't
	" TODO: make optional
	if l:cword =~ '^\d\+$'
		return "" 
	endif

	"TODO: make optional
	"If we're inside a string, don't try to complete
	if s:inString()
		return 0
	endif

	let b:complPos = l:npos
	call s:NiceMenuCancel()

python << PEOF
global ptimer

delay = vim.eval("NiceMenuGetDelay()")
if not delay:
	delay = '.8'
ptimer = threading.Timer( float(delay), NiceMenuShowMenu )
ptimer.start()
PEOF
	"echo "s:NiceMenuCompl word to long done"
	return ""
endfun

function NiceMenu_enable()
	"call s:mapForMappingDriven()
	autocmd CursorMovedI * call s:NiceMenuCompl(1)
	autocmd InsertEnter  * call s:NiceMenuCompl(0)
	autocmd InsertLeave  * call s:NiceMenuCancel()
endfunction

" This mapping is a work around for a race condition in
" NiceMenu. If you hit <esc> while a completion is building
" its menu list when the list is done being built the completion
" menu will try to show itself and drop the user back into Insert mode.
" But, if there is another <ESC> loaded into the typeahead buffer it will 
" cancel out menu put the user back into Normal mode like 
" they want to be. This all happens very quickly and to the user it looks
" typing ESC to get into normal mode works just like it should.
imap <silent> <ESC> <ESC><ESC>

call NiceMenu_enable()


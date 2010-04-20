


"if exists('g:loaded_nice_menu') || v:servername == ""
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
	let g:NiceMenuDefaultCompl = "\<C-N>" 
endif

if ! exists( 'g:NiceMenuEnableOmni' )
	let g:NiceMenuEnableOmni = 1
endif

" only pop completion if one of these chars is to the
" left of the cursor.
" We should also have different classes of mappings and be able to chain them
" per file type. So a ftype can have classes A,B,C chained in that order. And
" perform a completion type performed by first matching class type and then
" fail back on a default(<C-N). We should have a global catch all chain to handle
" things like file path completions.
if ! exists( 'g:NiceMenuDefaultContextRegex' )
	let g:NiceMenuDefaultContextRegex = '[a-zA-Z0-9_<>:\-\.\$\/]' 
endif
au BufNewFile,BufReadPre * if !exists('b:NiceMenuContextRegex') | let b:NiceMenuContextRegex = g:NiceMenuDefaultContextRegex | endif
au BufNewFile,BufReadPre * if !exists('b:NiceMenuEnableOmni') | let b:NiceMenuEnableOmni = g:NiceMenuEnableOmni | endif

au BufNewFile,BufReadPre * let b:complPos = [0,0,0,0]

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
"
" Private Helper:
" s:filePathIsValid
"{{{1
function! s:filePathIsValid( fpath )
	return filereadable( a:fpath ) || isdirectory( a:fpath )
endfunction

" Private Helper:
" s:findFilePath
"{{{1
" THIS DOEN'T WORK
"function! s:findFilePath(cur_text)
function! FindFilePath()


	let l:cline = getline( '.' )

	" Look for a leading '/', './' or '~' characters. 
	let l:fchar = stridx( l:cline, '~' )
	if -1 == l:fchar
		let l:cpos = getpos( '.' )[2] - 1
		let l:fpath = strpart( l:cline, l:fchar, l:cpos )
		let l:fpath = substitute( l:fpath, '\~', expand("$HOME"), "" )

		" Now we have the full path string, which may be partial. So find
		" a valid substring if necessary.
		if s:filePathIsValid( l:fpath )
			"echo l:fpath
			return 1
		endif
	endif
	
	let l:fchar = stridx( l:cline, './' )
	if -1 == l:fchar
		let l:cpos = getpos( '.' )[2] - 1
		let l:fpath = strpart( l:cline, l:fchar, l:cpos )
		if s:filePathIsValid( l:fpath )
			"echo l:fpath
			return 1
		endif
	endif

	let l:fchar = stridx( l:cline, '/' )
	if -1 == l:fchar
		let l:cpos = getpos( '.' )[2] - 1
		let l:fpath = strpart( l:cline, l:fchar, l:cpos )
		if s:filePathIsValid( l:fpath )
			"echo l:fpath
			return 1
		endif
	endif
	
	return 0
endfunction

"let b:completionList = []
"let b:completionPos = -1 
function! NiceMenuCompletefunc( startpos, base )
	"echo "NiceMenuCompletefunc"
	"sleep 1

	if empty(b:completionList) || -1 == b:completionPos
		return -1
	endif

	if 1 == a:startpos 
		return b:completionPos
	endif

	if 0 == a:startpos 
		"call complete( a:startpos, b:completionList )
		return b:completionList
	endif

	return -1
endfunction

function! s:canComplete()

	if (! exists('&omnifunc')) || (&omnifunc == '') || s:inString()
		"echo "canComplete no omni"
		"sleep 1
		return "" 
	endif


	if exists('&omnifunc') && &omnifunc != '' && (! s:inString())
		"echo "canComplete checking omni"
		"sleep 1
		"echo "NiceMenu_is_file_path() ".NiceMenu_is_file_path(l:cword)
		"return ""
		"if NiceMenu_is_file_path(l:cword)
		if FindFilePath()
			return "\<C-X>\<C-F>"
		else
			"let l:cword   = s:getCurrentWord()
			"if l:cword =~ '\k$' || l:cword =~ '\k->$' || l:cword =~ '\k\.$'
			" Test the complete function before setting it.
			let b:completionPos = -1
			let l:compl_res = call( &omnifunc, [1,''] )


			if -1 != l:compl_res

				let l:cpos = getpos( '.' )
				let l:compl_list = call( &omnifunc, [0,s:getOmniWord(l:compl_res)] )

				if ! empty(l:compl_list)

					set completefunc=NiceMenuCompletefunc
					let b:completionList = l:compl_list
					let b:completionPos = l:compl_res

					"echo "canComplete found " len( b:completionList ) " omni items \<C-X>\<C-U>"
					"sleep 1
					
					return "\<C-X>\<C-U>"
				endif

				" The second call to omnifunc can change our pos even though
				" it doesn't have any work to do, so set it back.
				call setpos( '.', l:cpos )
			endif
		endif
	endif


	"echo "canComplete found nothing"
	"sleep 1
	"let b:completionList = [] 
	return "" 
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
	if curChar !~ b:NiceMenuContextRegex
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
	
	let l:compl = "" 
	let l:cancompl = ""
	if b:NiceMenuEnableOmni
		let l:cancompl = s:canComplete()
	endif

	if len( l:cancompl )
		let l:compl = l:cancompl
		"echo "got omni string " l:compl
		"sleep 1
	else 
		let l:compl = s:getDefaultCompl() 
	endif
	
	" Select first(original typed text) option without inserting it's text 
	" TODO: This should be a configurable option.
	let l:compl .= "\<C-P>"
	let b:NiceMenu_has_shown = 1

	"echo "Completion string " l:compl
	"sleep 1
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
		subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-send", '<C-R>=NiceMenuAsyncCpl()<CR>'] )
	except:
		print 'NiceMenuShowMenu except' 
		pass
PEOF

function! NiceMenuCancel()
	"echo "NiceMenuCancel"
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
	
	"XXX We need to load this plugin after v:servername has been set!!
	if v:servername == ''
		"echoerr 'No servername found, cannot load NiceMenu'
		return
	endif

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
	call NiceMenuCancel()

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
	autocmd InsertLeave  * call NiceMenuCancel()
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


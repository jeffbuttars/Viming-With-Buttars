"=============================================================================
"    Copyright: Copyright (C) 2009 Jeff Buttars 
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               doubleTap.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
" Name Of File: doubleTap.vim
"  Description: DoubleTap Vim Plugin
"               This plugin provides a more manual, but easy, way to insert
"               matching pair characters, ie: [],(),'', and not so matchy
"               characters like + and . , common concatenation characters.
"               Also provides a quick and easy way to terminate a line no
"               matter where on the line the cursor is.
"               For instance a double semicolon, ;;, will trim all of the
"               space at the end of the line and insert a semicolon at the end
"               of the current line. DoubleTap provides some simple abstraction
"               functions to the do the more intricate work and then provides default 
"               mappings to wire those functions to characters,pairs and
"               events. You can easily use the core functions provided by doubleTap to 
"               create your own mappings and behaviours.
"
"                   Another great plugin that provides a more automatic 'as you
"               type' matching pair insertion/completion is 
"               DelimitMate,http://www.vim.org/scripts/script.php?script_id=2754
"               Check it out if haven't already. It provided inspiration for
"               me to finally write this plugin.
"
"     Examples: 
"
"     			For true matching pairs like {}:
"     			typing a double left curly brace, {{, will insert a matching
"     			pair of curly braces, {}, with the cursor in the middle.
"     			typing a double right curly brace, }}, will place the cursor
"     			after the next instance of a right curly brace in the buffer.
"     			This behavior is used with {},[],() pairs by default.
"     				For string containers, quote marks, the behavior is similar
"     			to matching pairs. When a single quote is typed in twice 
"     			quickly, '', if the cursor is inside a string, as determined by 
"     			the syntax highlighting, then the curso will be set to the
"     			right of the next occurrence of '. Otherwise two quotes are
"     			inserted into the buffer with the cursor between them. This
"     			is the behavior of ' and " by default
"     				There is also a pseudo matching pair functionality used
"     			for characters that aren't paired or used as a container. This
"     			is used for concatenation characters at the time of this
"     			release.It's used for the . and + characters. It is very
"     			simple. If .. is typed and there is a. to the right of the
"     			cursor the cursor position is set to the right of the next . on the
"     			current line. Otherwise two periods are inserted with the cursor 
"     			in between them. By default this is the behaviour of the . and
"     			+ characters, depending on filetype.
"     				The second part of this plugin is finish line. By double
"     			tapping a character the current line is 'finished' for
"     			you. The basic behaviour is to trim all white space from the
"     			end of the current line and insert a character, like a ;, at
"     			the end of the clean line. Some additional functionality, like
"     			saving the file, can be easily added in the mapping.
 "
"   Maintainer: Jeff Buttars (jeffbuttars at gmail dot com)
" Last Changed: Thursday, 9 Dec 2009
"      Version: See g:double_tap_version for version number.
"        Usage: This file should reside in the plugin directory and be
"               automatically sourced.
"     			    All functionality of this plugin is triggered by a key mapping.
"     			Double Tap comes with it's own set of default mappings
"     			enabled. You can easily disable any of the default mappings
"     			from you .vimrc by setting the appropriate setting variable to
"     			0. For example to disable left bracket insertion put the
"     			following in you .vimrc:
"                   let b:DoubleTap_map_left_bracket = 0
"               Look in the 'Default settings' section bellow to see all of the
"               settings variables. Look at the 'Set up key mappings' section
"               to see how the mappings are set.
"
"=============================================================================

" Allow doubleTap to 
" Exit quickly if already running or when 'compatible' is set. 
" {{{1
if exists("g:loaded_doubleTap") || &cp
  finish
endif
"1}}}

" Version number
" {{{1
let g:loaded_doubleTap = '1.0'
"1}}}

" Check for Vim version 700 or greater 
" {{{1
if v:version < 700
  echo "Sorry, doubleTap ".g:double_tap_version."\nIs only known to run with Vim 7.0 and greater."
  finish
endif
"1}}}

" Default settings 
" {{{1

if !exists( "g:DoubleTapInsertTimer" )
	let g:DoubleTapInsertTimer = &timeout
endif

if !exists( "g:DoubleTapJumpPreferVimPair" )
	let g:DoubleTapJumpPreferVimPair = 1
endif

au BufNewFile,BufReadPre * let b:lcharChar = ''
au BufNewFile,BufReadPre * let b:lcharTime = reltimestr( reltime() )
au BufNewFile,BufReadPre * let b:lcharPos = [-1,-1,-1,-1] 
au BufNewFile,BufReadPre * let b:doubleTap_match_ids = [] 
au CursorHold,CursorHoldI * call s:clearMatch()

"" XXX TODO: this experimental shit to try and figure out how to make
" the visual feedback behave properly.
let s:doubleTabCharReg = "[;\\[\\]\"'\\(\\){}\\+\\.]" 
function! s:checkCurChar()
	let l:char = strpart( getline('.'), col('.')-2, 1)
	if l:char !~ s:doubleTabCharReg
		call s:clearMatch()
	endif	
endfunction
au CursorMovedI,CursorMoved * call s:checkCurChar()


" Spacey
" If you have a spacey stile, ( arg ) vs (arg)
" Try setting this to 1, default is 0/off
if !exists( "g:DoubleTapSpacey" )
  let g:DoubleTapSpacey = 1
endif
"au BufNewFile,BufReadPre * if !exists('b:DoubleTapSpacey') | let b:DoubleTapSpacey = g:DoubleTapSpacey | endif

function! s:useSpacey()
	if exists( 'b:DoubleTapSpacey' )
		return b:DoubleTapSpacey
	endif

	return g:DoubleTapSpacey
endfunction

let g:DoubleTap_SpaceyBlock = '\<LEFT>\<CR>\<ESC>O\<Tab>'
let g:DoubleTap_SpaceyInline = '\<LEFT>\<SPACE>\<SPACE>\<LEFT>'


let g:DoubleTapFinishLine_Map = [ 
	\	{ 'ftype':'*', 'trigger':";", 'finishChar':";", 'spacey':'' },
	\	{ 'ftype':'javascript,python,lua', 'trigger':",", 'finishChar':",", 'spacey':'' },
	\	{ 'ftype':'python', 'trigger':":", 'finishChar':":", 'spacey':'' },
	\	{ 'ftype':'python', 'trigger':";", 'finishChar':":", 'spacey':'' } ]

let g:DoubleTapFinishLineNormal_Map = [ 
	\	{ 'ftype':'*', 'trigger':";;", 'finishChar':';', 'spacey':'', },
	\	{ 'ftype':'php,javascript,python,lua,json', 'trigger':",,", 'finishChar':",", 'spacey':'', },
	\	{ 'ftype':'python', 'trigger':";;", 'finishChar':':', 'spacey':'', } ,
	\	{ 'ftype':'python', 'trigger':"::", 'finishChar':':', 'spacey':'', } ]

let g:DoubleTapInsertJumpSimple_Map = [ 
	\	{ 'ftype':'*', 'trigger':'+', "inChar":"+", 'spacey':'' },
	\	{ 'ftype':'php,perl', 'trigger':'.', "inChar":".", 'spacey':'' } ]

let g:DoubleTapJumpOut_Map = [
	\	{ 'ftype':'html,xhtml,html.django_template,xml,xhtml,htmlcheetah,javascript,php', 'trigger':'>', 'leftChar':'<', 'rightChar':'>' },
	\	{ 'ftype':'*', 'trigger':'}', 'leftChar':'{', 'rightChar':'}' },
	\	{ 'ftype':'*', 'trigger':']', 'leftChar':'[', 'rightChar':']' },
	\	{ 'ftype':'*', 'trigger':')', 'leftChar':'(', 'rightChar':')' } ]

let g:DoubleTapInsert_Map = [ 
	\	{ 'ftype':'*', 'trigger':"{", 'lChar':'{', 'rChar':'}', 'spacey':g:DoubleTap_SpaceyBlock },
	\	{ 'ftype':'*', 'trigger':"[", 'lChar':'[', 'rChar':']', 'spacey':"" },
	\	{ 'ftype':'*', 'trigger':"(", 'lChar':'(', 'rChar':')', 'spacey':g:DoubleTap_SpaceyInline },
	\	{ 'ftype':'make', 'trigger':"(", 'lChar':'(', 'rChar':')', 'spacey':"" },
	\	{ 'ftype':'vim,python,json', 'trigger':"{", 'lChar':"{", 'rChar':"}", 'spacey':g:DoubleTap_SpaceyInline },
	\	{ 'ftype':'json', 'trigger':"[", 'lChar':'[', 'rChar':']', 'spacey':g:DoubleTap_SpaceyInline },
	\	{ 'ftype':'html,xhtml,html.django_template,xml,xhtml,htmlcheetah,javascript,php,cpp', 'trigger':"<", 'lChar':'<', 'rChar':'>', 'spacey':'\<LEFT>' },
	\]
	"\	{ 'ftype':'*', 'trigger':"[", 'lChar':'[', 'rChar':']', 'spacey':g:DoubleTap_SpaceyInline },

let g:DoubleTapInsertJumpString_Map = [
	\	{ 'ftype':"*", 'trigger':"'", 'inChar':"\"'\"", 'spacey':"" },
	\	{ 'ftype':"*", 'trigger':'"', 'inChar':"'\"'", 'spacey':"" } ]


" Enable visual feedback
if !exists( "g:DoubleTap_enable_visual_feedback" )
  let g:DoubleTap_enable_visual_feedback = 1
endif

" Automatically save the file when you use finish line
" When in Insert mode, this will leave you in normal mode.
if !exists( "g:DoubleTap_finish_line_auto_save" )
  let g:DoubleTap_finish_line_auto_save = 1
endif


" Private Helper:
" getSynName:
" get the syntax type under the cursor
"{{{1
function! s:getSynName()
	return synIDattr(synID(line("."), col("."), 0), "name" )
endfunction	
"1}}}

" Private Helper:
" getSynStack:
" get the syntax stack under the cursor
"{{{1
function! s:getSynStack()
	return synstack( line("."), col(".") )
endfunction	
"1}}}

" Private Helper:
" inString
" Param: thechar the quote character that's been double tapped.
" See if the cursor is inside a string according the current syntax definition
"{{{1
function! s:inString( thechar )

	" This will often contain whether we are in a single or double quote
	" string. How that is represented seems syntax specific, not standard.
	" We still leverage that knowledge if we can.
	let l:synstr = s:getSynName()

	if l:synstr  !~? 'String'
	  " If we're not 'in' the string, we may be sitting
	  " on the quote, if so return true/1
	  
	  if strpart( getline("."), col('.')-1, 1) == a:thechar
		echo "We're in"
		return 1
	  endif

	  return 0
	endif

	let l:inSingle = 0
	let l:theSingle = 0

	"" See if the string we're in is the same kind we're tapping.
	" So, if we're in a '      ' but double tap a ", we should end up
	" with '    ""   ' and not jump to the next ".
	"
	" Is there more at the end of the string? a 'S' or 'Single'?
	" If so, see if we can detect the quote type and then match it
	" to the chare being tapped.
	if l:synstr  !~? 'String$'
	  if l:synstr  =~? 'StringS'
		let l:inSingle = 1
	  endif

	  if a:thechar == "'"
		let l:theSingle = 1
	  endif
	endif

	return l:inSingle == l:theSingle
endfunction
"1}}}

function! s:setMatch( ... )

	if ! g:DoubleTap_enable_visual_feedback
		return
	endif

	if a:0 == 1
		let l:positions = a:1
	else
		let l:npos = getpos('.')
		let l:positions = [ [ l:npos[1], l:npos[2] ] ] 
	endif

	for cord in l:positions
		if len( cord ) < 2
			continue
		endif

		call add( b:doubleTap_match_ids, matchadd( 'Special', '\%'.cord[0].'l\%'.cord[1].'c', 100  ) )
	endfor

endfunction

function! s:advCursorAndMatch( adv, ... )

	let l:cpos = getpos(".")
	let l:cpos[ 2 ] += a:adv
	call setpos( '.', l:cpos )

	"call call( 's:setMatch', a:000 )
	call call( 's:setMatch', [ [ l:cpos[1], l:cpos[2]-1 ] ] )
endfunction

function! s:clearMatch()

	if ! g:DoubleTap_enable_visual_feedback
		return
	endif

	if ! exists( 'b:doubleTap_match_ids' ) || empty(b:doubleTap_match_ids)
		return
	endif

	for id in b:doubleTap_match_ids
		call matchdelete( id )
	endfor

	let b:doubleTap_match_ids = []
endfunction

function! s:checkDoubleInsert( thechar )

	let l:ntime = reltimestr( reltime() )
	let l:npos = getpos('.')
	call s:clearMatch()

	if (a:thechar != b:lcharChar) || (l:ntime - b:lcharTime > g:DoubleTapInsertTimer) || ( l:npos[1] != b:lcharPos[1] ) || ( (l:npos[2]-1) != b:lcharPos[2] )
		let b:lcharTime = l:ntime
		let b:lcharChar = a:thechar
		let b:lcharPos = l:npos 
		return 0 
	endif

	let l:cline = getline( '.' )
	let l:cpos = getpos( '.' )[2]
	if l:cline[l:cpos - 2] == a:thechar 
		let s:lcharTime = l:ntime
		let s:lcharChar = '' 
		if exists( 'NiceMenuCancel' )
			call NiceMenuCancel()
		endif

		return 1
	endif

	let s:lcharTime = l:ntime
	let s:lcharChar = a:thechar
	return 0
endfunction


function! s:sliceChar()
	" Splice out the current char 

	let l:cline = getline(".")
	let l:cpos = getpos(".")

	let l:left_line = strpart( l:cline, 0, l:cpos[2]-2 )
	let l:right_line = strpart( l:cline, l:cpos[2]-1 )
	call setline( l:cpos[1], l:left_line . l:right_line )

	let l:cpos[2] -= 1
	call setpos( '.', l:cpos )
endfunction

" Public Interface:
" DoubleTapInsert:
" is this a double insert of a doubleTap char? 

function! DoubleTapInsert( thechar, mchar, ... )

	if ! s:checkDoubleInsert( a:thechar )
		call s:setMatch()
		return a:thechar
	endif

	let l:cpos = getpos( '.' )
	call s:setMatch( [ [ l:cpos[1], l:cpos[2] ], [ l:cpos[1], l:cpos[2]+1 ] ] )

	if a:0 > 0 && strlen( a:1 )
		return a:mchar . a:1 
	endif

	return a:mchar . "\<LEFT>"
endfunction	
"1


" Access Public:
" Name DoubleTapFinishLine: Remove trailing whitespace, put the given character at the end of the line  
" Param: thechar the character to place at the end of the cleaned line.
" 
function! DoubleTapFinishLine( thechar )
	echo "DoubleTapFinishLine" a:thechar

	if &paste
		return a:thechar
	endif

	if ! s:checkDoubleInsert( a:thechar )
		call s:setMatch()
		return a:thechar
	endif

	call s:sliceChar()

	" If thechar already exists already, don't do anything.
	let l:regex = a:thechar . '\s*$'
	if getline(".") =~ l:regex 
		return "" 
	endif

	let l:cline = substitute( getline("."), '\s*$', '', 'g' )
	call setline( ".", l:cline . a:thechar )

	let l:npos = getpos( '.' )
	let l:npos[ 2 ] += 1
	call setpos( '.', l:npos )

	call s:setMatch( [ [ l:npos[1], strlen( getline('.') ) ] ] )

	if g:DoubleTap_finish_line_auto_save
		return "\<ESC>:w\<CR>"
	endif

	return "" 
endfunction
"1

" Public Interface:
" DoubleTapFinishLineNormal: Remove trailing whitespace, put the given character at the end of the line  
" Param: thechar the character to place at the end of the cleaned line.
function! DoubleTapFinishLineNormal( thechar )

	if &paste
		return 0
	endif

	" If thechar already exists already, don't do anything.
	let l:regex = a:thechar . '\s*$'
	if getline(".") =~ l:regex 
		return 0 
	endif

	let l:cline = substitute( getline("."), '\s*$', '', 'g' )
	call setline( ".", l:cline . a:thechar )

	let l:npos = getpos( '.' )
	call s:setMatch( [  [ l:npos[1], strlen(getline('.')) ] ] )

	return 1
endfunction
"1

" Public Interface:
" DoubleTapJumpOut: Find the next instance of thechar in the current
" buffer and jump to it.
" Param: a:right_char the character to jump too.
" 
function! DoubleTapJumpOut( left_char, right_char )

	if &paste
		return a:right_char
	endif

	if ! s:checkDoubleInsert( a:right_char )
		call s:setMatch()
		return a:right_char
	endif

	" First see if it's on the cursor. 
	" If it is go right one and return.
	" Otherwise find the next instance in the buffer and 
	" go there.

	call s:sliceChar()

	let l:cline = getline(".")
	let l:cpos = getpos(".")

	"if the cursor is to left of thechar, jump out.
	let l:rchar = strpart( l:cline, col('.')-1, 1)

	if l:rchar == a:right_char 
		call s:advCursorAndMatch( 2, [ [ l:cpos[1], l:cpos[2]-1 ] ] )
		return ""
	endif

	if g:DoubleTapJumpPreferVimPair
		" First try to use the searchpair() to jump.
		let l:sres = searchpair( a:left_char, '', a:right_char, 'W' )
		if l:sres > 0
			" We jumped.
			call s:advCursorAndMatch( 1, [ [ l:cpos[1], l:cpos[2]-1 ] ] )
			return ""
		endif
	endif

	" We're not in a pair, but jump anyway.
	"find next position of this character in the buffer.
	"let l:npos = searchpos( a:right_char, 'nW' )
	let l:npos = searchpos( a:right_char, 'W' )
	if l:npos[0] > 0 && l:npos[1] > 0 && l:npos[0] >= l:cpos[1]

		let l:cpos[1] = l:npos[0]
		let l:cpos[2] = l:npos[1]+1
		call setpos( '.', l:cpos )

		call s:setMatch( [ [ l:cpos[1], l:cpos[2]-1 ] ] )
		return ""
	endif

	return a:right_char.a:right_char
endfunction
"1

" Public Interface:
" DoubleTapInsertJumpString: This is a lot like DoubleTapJumpOut() but is explicity
" for the string enclosing ''' and '"'
" Param: thechar the quote character used to define the new string or jukmp
" too.

function! DoubleTapInsertJumpString( thechar )

	if &paste
		return a:thechar
	endif

	if ! s:checkDoubleInsert( a:thechar )
		"return a:thechar.a:thechar
		call s:setMatch()
		return a:thechar
	endif

	call s:sliceChar()
	let l:cpos = getpos(".")

	" If we're in a string, jump out
	" Otherwise, lay down a pair
	if s:inString( a:thechar )
		" jump out
		" Make sure we're not sitting on the quote. 
		" If we are, move the cursor to the left by one.
		if strpart( getline("."), col('.')-1, 1) == a:thechar
			let l:cpos[2] -= 1 
			call setpos( '.', l:cpos )
		endif

		let l:npos = searchpos( a:thechar, 'nW' )
 		if l:npos[0] >= l:cpos[1]
			call s:clearMatch()
			let l:cpos[1] = l:npos[0]
			let l:cpos[2] = l:npos[1]+1
			call setpos( '.', l:cpos )
			call s:setMatch( [ [ l:cpos[1], l:cpos[2]-1 ] ] )
			return ''
		endif
	endif

	call s:setMatch( [ [ l:cpos[1], l:cpos[2] ], [ l:cpos[1], l:cpos[2]+1 ] ] )
	return a:thechar.a:thechar."\<left>"
endfunction
"1

" Public Interface:
" DoubleTapInsertJumpSimple: This is a lot like DoubleTapJumpOut() but it is used
" for characters that aren't usually considered a matching
" pair. This can be a convenience for concatenation operators
" like . and +
" If the char is present to the right of the cursor
" jump to it. Otherwise insert a pair and put the cursor
" in the middle of them.
" For now only works with single line matches 
" Param: thechar the character to insert or jump too.

function! DoubleTapInsertJumpSimple( thechar )

	if &paste
		return a:thechar
	endif

	if ! s:checkDoubleInsert( a:thechar )
		call s:setMatch()
		return a:thechar
	endif

	call s:sliceChar()

	" See if it's there.
	let l:cpos = getpos(".")
	let l:cline = getline(".")
	let l:ccol = l:cpos[2]-1

	let l:nchar = stridx( l:cline, a:thechar, l:ccol )
	echo l:nchar
	if l:nchar < l:ccol

		"if the cursor is on or to left of thechar, jump out.
		let l:tchar = strpart( getline('.'), col('.')-2, 1)
		let l:rchar = strpart( getline('.'), col('.')-1, 1)
		if l:tchar == a:thechar || l:rchar == a:thechar
			" Jump
			let l:cpos[2] = l:nchar+2
			call setpos( '.', l:cpos )
			call s:setMatch( [ [ l:cpos[1], l:cpos[2]-1 ] ] )
			return ""
		else
			call s:setMatch( [ [ l:cpos[1], l:cpos[2] ], [ l:cpos[1], l:cpos[2]+1 ] ] )
			return a:thechar.a:thechar."\<left>"
		endif
	endif

	let l:cpos[2] = l:nchar+2
	call setpos( '.', l:cpos )

	return ""
endfunction
"1
 
for item in g:DoubleTapInsert_Map
	execute printf("au FileType %s imap <silent><expr> %s DoubleTapInsert( \"%s\", \"%s\", \"%s\" )",
	\	item[ 'ftype' ], item[ 'trigger' ], item[ 'lChar' ], item[ 'rChar' ], item[ 'spacey' ] )
endfor

for item in g:DoubleTapJumpOut_Map
	execute printf( "au FileType %s imap %s <C-R>=DoubleTapJumpOut('%s', '%s')<CR>",
	\	item[ 'ftype' ], item[ 'trigger' ], item[ 'leftChar' ], item[ 'rightChar' ] )
endfor

for item in g:DoubleTapInsertJumpString_Map
	execute printf( "au FileType %s imap %s <C-R>=DoubleTapInsertJumpString(%s)<CR>",
	\	item[ 'ftype' ], item[ 'trigger' ], item[ 'inChar' ] )
endfor

for item in g:DoubleTapInsertJumpSimple_Map
	execute printf( "au FileType %s imap %s <C-R>=DoubleTapInsertJumpSimple('%s')<CR>", 
	\	item[ 'ftype' ], item[ 'trigger' ], item[ 'inChar' ] )
endfor

for item in g:DoubleTapFinishLineNormal_Map
	if g:DoubleTap_finish_line_auto_save 
		execute printf("autocmd FileType %s nmap %s <ESC>:call DoubleTapFinishLineNormal( '%s' )<CR>:w<CR>",
		\	item[ 'ftype' ], item[ 'trigger' ], item[ 'finishChar' ])
	else                                            
		execute printf("autocmd FileType %s nmap %s <ESC>:call DoubleTapFinishLineNormal( '%s' )<CR>",
		\	item[ 'ftype' ], item[ 'trigger' ], item[ 'finishChar' ])
	endif	
endfor

for item in g:DoubleTapFinishLine_Map
	execute printf("autocmd FileType %s imap %s <C-R>=DoubleTapFinishLine( '%s' )<CR>",
	\	item[ 'ftype' ], item[ 'trigger' ], item[ 'finishChar' ])
endfor

"1

" vim:ft=vim foldmethod=marker sw=4

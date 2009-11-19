"=============================================================================
"    Copyright: Copyright (C) 2009 Jeff Buttars 
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               doubleTab.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
" Name Of File: doubleTap.vim
"  Description: DoubleTap Vim Plugin
"               This plugin provides a more manual, but easy, way to insert
"               matching pair characters, ie: [],(),'', and not so matchy
"               characters like + and ., common concatenation characters.
"               Also provides a quick and easy way to terminate a line no
"               matter where on the line the cursor is.
"               For instance a double semicolon, ;;, will trim all of the
"               space at the end of the line and insert a semicolon at the end
"               of the current line. DoubleTap provides some simple abstract 
"               functions to the more intricate work and then provides default 
"               mappings to wire those functions to characters,pairs and
"               events.
"   Maintainer: Jeff Buttars (jeffbuttars at gmail dot com)
" Last Changed: Thursday, 19 Nov 2009
"      Version: See g:double_tap_version for version number.
"        Usage: This file should reside in the plugin directory and be
"               automatically sourced.
"
"=============================================================================


" Exit quickly if already running or when 'compatible' is set. 
" {{{1
if exists("g:double_tap_version") || &cp
  finish
endif
"1}}}

" Version number
" {{{1
let g:double_tap_version = '1.0'
"1}}}

" Check for Vim version 700 or greater 
" {{{1
if v:version < 700
  echo "Sorry, doubleTap ".g:double_tap_version."\nONLY runs with Vim 7.0 and greater."
  finish
endif
"1}}}

" Default settings 
" {{{1
"
"[[
" Enable default left bracket mapping
if !exists( "b:DoubleTab_map_left_bracket" )
  let b:DoubleTab_map_left_bracket = 1
endif
" Enable default right bracket mapping
"]]
if !exists( "b:DoubleTab_map_right_bracket" )
  let b:DoubleTab_map_right_bracket = 1
endif

" Enable default left curly brace mapping
" {{
if !exists( "b:DoubleTab_map_left_brace" )
  let b:DoubleTab_map_left_brace = 1
endif
" Enable default rightt curly brace mapping
" }}
if !exists( "b:DoubleTab_map_right_brace" )
  let b:DoubleTab_map_right_brace = 1
endif

" Enable default left paren mapping
" ((
if !exists( "b:DoubleTab_map_left_paren" )
  let b:DoubleTab_map_left_paren = 1
endif
" Enable default right paren mapping
" ))
if !exists( "b:DoubleTab_map_right_paren" )
  let b:DoubleTab_map_right_paren = 1
endif

" Enable default single quote insert/jump mapping
" ''
if !exists( "b:DoubleTab_map_single_quote_insert_jump" )
  let b:DoubleTab_map_single_quote_insert_jump = 1
endif

" Enable default double quote insert/jump mapping
if !exists( "b:DoubleTab_map_double_quote_insert_jump" )
  let b:DoubleTab_map_double_quote_insert_jump = 1
endif
" Enable default double quote jump out mapping
if !exists( "b:DoubleTab_map_double_quote_jump_out" )
  let b:DoubleTab_map_double_quote_jump_out = 1
endif

" Enable default double plus insert/jump mapping
" ++
if !exists( "b:DoubleTab_map_plus_insert_jump" )
  let b:DoubleTab_map_plus_insert_jump = 1
endif

" Enable default double period insert/jump mapping
" ..
if !exists( "b:DoubleTab_map_period_insert_jump" )
  let b:DoubleTab_map_period_insert_jump = 1
endif

" Enable default double semicolon finish line mapping 
" ;;
if !exists( "b:DoubleTab_map_semicolon_finish_line" )
  let b:DoubleTab_map_semicolon_finish_line = 1
endif

" Enable default double colon finish line mapping 
" ::
if !exists( "b:DoubleTab_map_colon_finish_line" )
  let b:DoubleTab_map_colon_finish_line = 1
endif

" Enable default double comma finish line mapping 
" ,,
if !exists( "b:DoubleTab_map_comma_finish_line" )
  let b:DoubleTab_map_comma_finish_line = 1
endif
"1}}}


" s:inString()
" private
 "See if the cursor is inside a string according the current syntax definition
 "{{{1
function! s:inString()
	return synIDattr(synID(line("."), col("."), 0), "name" ) =~ 'String'
endfunction
"1}}}

" g:DoubleTapFinishLine( thechar )
" public
" Remove trailing whitespace, put the given character at the end of the line  
" {{{1
function! g:DoubleTapFinishLine( thechar )

	if &paste
	  return a:thechar
	endif

	" If thechar already exists already, don't do anything.
	let l:regex = a:thechar . '$'
	if getline(".") =~ l:regex 
		return
	endif

	let l:cline = substitute( getline("."), '\s*$', '', 'g' )
	echo l:cline . a:thechar 
	call setline( ".", l:cline . a:thechar )
endfunction
"1}}}

" DoubleTapJumpOut( thechar )
" public
" If the next instance of a char is to the 
" right of us, go to the right of it.
" But only if it appears to close a matching
" left? Maybe we'll do that last part later, we'll see. 
" {{{1
function! DoubleTapJumpOut( thechar )

	if &paste
	  return a:thechar
	endif

	" See if it's there.
	let l:cline = getline(".")
	let l:cpos = getpos(".")
	let l:ccol = l:cpos[2]-1

	let l:nchar = stridx( l:cline, a:thechar, l:ccol )
	if l:nchar < l:ccol
		return a:thechar.a:thechar
	endif

	let l:cpos[2] = l:nchar+2
	call setpos( '.', l:ccur )

	return ""
endfunction
"1}}}

"{{{1
" DoubleTapInsertJumpString( thechar )
" public
" This is a lot like DoubleTapJumpOut() but is explicity
" for the string enclosing ''' and '"'
" For now only works with single line strings.
function! DoubleTapInsertJumpString( thechar )

	if &paste
	  return a:thechar
	endif

	if (a:thechar != '"' && a:thechar != "'")
	  echo "DoubleTapInsertJumpString() only works with ' and \""
	  return a:thechar . a:thechar
	endif


	let l:cline = getline(".")
	let l:cpos = getpos(".")
	let l:ccol = l:cpos[2]-1
	let l:nchar = stridx( l:cline, a:thechar, l:ccol )
	
	" If we're in a string, jump out
	if s:inString()
	  " jump out
	  let l:cpos[2] = l:nchar+2
	  call setpos( '.', l:cpos )
	  return ""
	endif

	return a:thechar.a:thechar."\<left>"
endfunction
"1}}}

"{{{1
" DoubleTapInsertJumpSimple( thechar )
" public
" This is a lot like DoubleTapJumpOut() but it is used
" for characters that aren't usually considered a matching
" pair. This can be a convenience for concatination operators
" like . and +
" If the char is present to the right of the cursor
" jump to it. Otherwise insert a pair and put the cursor
" in the middle of them.
" For now only works with single line matches 
function! DoubleTapInsertJumpSimple( thechar )

	if &paste
	  return a:thechar
	endif

	" See if it's there.
	let l:cline = getline(".")
	let l:cpos = getpos(".")
	let l:ccol = l:cpos[2]-1

	let l:nchar = stridx( l:cline, a:thechar, l:ccol )
	if l:nchar < l:ccol
		  "if the cursor is on or to left of thechar, jump out.
		  let l:tchar = strpart( getline('.'), col('.')-2, 1)
		  let l:rchar = strpart( getline('.'), col('.')-1, 1)
		  if l:tchar == a:thechar || l:rchar == a:thechar
			  let l:ccur = getpos(".")
			  let l:ccur[2] = l:nchar+2
			  call setpos( '.', l:ccur )
			  return ""
		  else
			  return a:thechar.a:thechar."\<left>"
		  endif

		return a:thechar.a:thechar
	endif

	let l:cpos[2] = l:nchar+2
	call setpos( '.', l:ccur )

	return ""
endfunction
"1}}}
 
"{{{1
" Find out however many instances of a char
" appear from the curent cursor position to the
" end of the line.
"function! NumCharsLeft( thechar )

	"let l:cline = getline(".")
	"let l:cpos = getpos(".")
	"let l:ccol = l:cpos[2]
	"let l:inst = 0

	"let l:nchar = stridx( l:cline, a:thechar, l:ccol )
	"while l:nchar > l:ccol 
		"let l:inst = l:inst+1
		"let l:nchar = stridx( l:cline, a:thechar, l:nchar+1 )
	"endwhile

	"return l:inst
"endfunction
"1}}}

"Set up key mappings 
"{{{1
" Enable default left bracket mapping
if 1 == b:DoubleTab_map_left_bracket
  imap [[ []<Left>
endif
" Enable default right bracket mapping
if 1 == b:DoubleTab_map_right_bracket
  imap ]] <C-R>=DoubleTapJumpOut("]")<CR>
endif

" Enable default left curly brace mapping
if 1 == b:DoubleTab_map_left_brace
  imap {{ {}<Left>
endif
" Enable default rightt curly brace mapping
if 1 == b:DoubleTab_map_right_brace
  imap }} <C-R>=DoubleTapJumpOut("}")<CR>
endif

" Enable default left paren mapping
if 1 == b:DoubleTab_map_left_paren
  imap (( ()<Left>
endif
" Enable default right paren mapping
if 1 == b:DoubleTab_map_right_paren
  imap )) <C-R>=DoubleTapJumpOut(")")<CR>
endif

" Enable default single quote insert mapping
if 1 == b:DoubleTab_map_single_quote_insert_jump
  imap '' <C-R>=DoubleTapInsertJumpString("'")<CR>
endif

" Enable default double quote insert mapping
if 1 == b:DoubleTab_map_double_quote_insert_jump
  imap "" <C-R>=DoubleTapInsertJumpString('"')<CR>
endif

" Enable default double quote insert mapping
if 1 == b:DoubleTab_map_plus_insert_jump
  au FileType javascript,python imap ++ <C-R>=DoubleTapInsertJumpSimple('+')<CR>
endif

" Enable default double quote insert mapping
if 1 == b:DoubleTab_map_period_insert_jump
  au FileType php,vim imap .. <C-R>=DoubleTapInsertJumpSimple('.')<CR>
endif

" Enable default double tap semicolon finish line
if 1 == b:DoubleTab_map_semicolon_finish_line
  " we use a different mapping in Python.
  if &ft == 'python'
	" NOTICE: This will insert a ':', not a semicolon.
	au FileType python imap ;; <ESC>:call DoubleTapFinishLine(':')<CR>:w<CR>o<ESC>
	au FileType python nmap ;; <ESC>:call DoubleTapFinishLine(':')<CR>:w<CR>o<ESC>
  else
	imap ;; <ESC>:call DoubleTapFinishLine(';')<CR>:w<CR><ESC>
	nmap ;; <ESC>:call DoubleTapFinishLine(';')<CR>:w<CR><ESC>
  endif

endif

" Enable default double tap colon finish line
" Only for Python by default
if 1 == b:DoubleTab_map_colon_finish_line
  au FileType python nmap :: <ESC>:call DoubleTapFinishLine(':')<CR>:w<CR>o<ESC>
  au FileType python imap :: <ESC>:call DoubleTapFinishLine(':')<CR>:w<CR>o<ESC>
endif

" Enable default double tap comma finish line
" Only for javascript and php by default
if 1 == b:DoubleTab_map_colon_finish_line
au FileType php,javascript nmap ,, <ESC>:call DoubleTapFinishLine(',')<CR>:w<CR>o<ESC>
au FileType php,javascript imap ,, <ESC>:call DoubleTapFinishLine(',')<CR>:w<CR>o<ESC>
endif

"1}}}

" vim:ft=vim foldmethod=marker sw=2

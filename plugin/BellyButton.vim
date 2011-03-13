"=============================================================================
"    Copyright: Copyright (C) 2010 Jeff Buttars 
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               doubleTap.vim is provided *as is* and comes with no
"               warranty of any kind, either expressed or implied. In no
"               event will the copyright holder be liable for any damages
"               resulting from the use of this software.
" Name Of File: BellyButton.vim
"  Description: BellyButton Vim Plugin
"
"     Examples: Go Examples!
 "
"   Maintainer: Jeff Buttars (jeffbuttars at gmail dot com)
" Last Changed: Sunday, 28 March 2010
"      Version: See g:belly_button_version for version number.
"        Usage: This file should reside in the plugin directory and be
"               automatically sourced.
"
"=============================================================================


if exists('loaded_bellybutton') || &cp || version < 700
	finish
endif

fun! s:sanitizeFT()
	return split(&ft, '\.')[0]
endf

fun! s:showErrors( estr, parseFunc )

	let l:has_errors = 0
	cclose " Close quickfix window
	cexpr [] " Create empty quickfix list

	if strlen(a:estr) > 0
		for error in split( a:estr,"\n" )
			try
				let l:eparts = call( a:parseFunc, [error] )
			catch /E117:/
				return 0
			endtry

			if !empty(l:eparts) && len(l:eparts) > 2
				let l:has_errors = 1
				caddexpr l:eparts['filename'] . ":" . l:eparts['lnum'] . ":" . l:eparts['errmsg']
			endif
		endfor
	endif

	if l:has_errors
		copen
	else
		echo "Belly Button is clean." 
	endif

	return l:has_errors
endfunction

fun! s:BellyButtonExtra()
	try
		call bellybutton#{s:sanitizeFT()}#extra()
	catch /E117:/
	endtry
endf

fun! s:BellyButtonLint()
	let l:ft = s:sanitizeFT()
	try
		let l:raw = bellybutton#{l:ft}#lintRaw()
		return s:showErrors( l:raw, "bellybutton#".l:ft."#parseLintErrorLine" )
	catch /E117:/
		return 0
	endtry
endf

fun! s:BellyButtonLintRaw()
	try
		echo bellybutton#{s:sanitizeFT()}#lintRaw()
	catch /E117:/
		return
	endtry
endf

fun! s:BellyButtonExec()

	try
		let l:e_out = bellybutton#{s:sanitizeFT()}#exec()
	catch /E117:/
		return
	endtry

	cclose " Close quickfix window

	"echo l:e_out
	let l:ecode = get(l:e_out, 'ecode', 0)
	let l:good_ecode = get(l:e_out, 'good_ecode', 0)
	let l:parse_error = get(l:e_out, 'parse_error', 0)

	if l:parse_error && (l:ecode != l:good_ecode)
		try
			call s:showErrors( get(l:e_out, 'sysout', ""), "bellybutton#".s:sanitizeFT()."#execParseError")
		catch /E117:/
		endtry
	endif

	echo get(l:e_out, 'sysout', "")
endf

command! BellyButtonExtra call s:BellyButtonExtra()
command! BellyButtonLint call s:BellyButtonLint()
command! BellyButtonLintRaw call s:BellyButtonLintRaw()
command! BellyButtonExec call s:BellyButtonExec()

au FileType * nmap <F3> <ESC>:w<CR>:BellyButtonExtra<CR>
au FileType * imap <F3> <ESC>:w<CR>:BellyButtonExtra<CR>
au FileType * nmap <F4> <ESC>:w<CR>:BellyButtonLint<CR>
au FileType * imap <F4> <ESC>:w<CR>:BellyButtonLint<CR>
au FileType * nmap <F5> <ESC>:w<CR>:BellyButtonExec<CR>
au FileType * imap <F5> <ESC>:w<CR>:BellyButtonExec<CR>

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


if exists('g:BellyButtonVersion') || &cp || version < 700
	finish
endif
let g:BellyButtonVersion = 1.0

let s:bbLocalOptFname = '.BellyButton_local_options.vim'

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
				if get(l:eparts, 'char')
					caddexpr l:eparts['filename'].":".l:eparts['lnum']
								\.":".l:eparts['char'].":".l:eparts['errmsg']
				else
					caddexpr l:eparts['filename'].":".l:eparts['lnum'].":".l:eparts['errmsg']
				endif
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
	call s:bbInit(s:sanitizeFT())

	try
		call BellyButton#{s:sanitizeFT()}#extra()
	catch /E117:/
	endtry

	call s:bbClean(s:sanitizeFT())
endf

" Called before a filetypes Exec or Raw is called
" to give them a chance to setup options and any other
" initialization before the work starts.
" This will also source the .BellyButton_local_options.vim
" file it's present to allow per directory option overrides.
fun! s:bbInit( bbft )

	"echo "s:bbInit(".a:bbft."): ".s:bbLocalOptFname.":".filereadable(s:bbLocalOptFname)
	if filereadable(s:bbLocalOptFname) > 0
		"echo "s:bbInit(".a:bbft.") sourcing:".s:bbLocalOptFname
		exec "source ".s:bbLocalOptFname
	endif

	try
		call BellyButton#{a:bbft}#init()
	catch /E117:/
	endtry
endf

fun! s:bbClean( bbft )
	try
		call BellyButton#{a:bbft}#clean()
	catch /E117:/
	endtry
endf

fun! s:BellyButtonLint()
	let l:ft = s:sanitizeFT()

	call s:bbInit(l:ft)

	try
		let l:raw = BellyButton#{l:ft}#lintRaw()
		let l:res = s:showErrors( l:raw, "BellyButton#".l:ft."#parseLintErrorLine" )
	catch /E117:/
		let l:res = 0
	endtry

	return l:res 
	call s:bbClean(l:ft)
endf

fun! s:BellyButtonLintRaw()
	try
		echo BellyButton#{s:sanitizeFT()}#lintRaw()
	catch /E117:/
		return
	endtry
endf

fun! s:BellyButtonExec()

	try
		call s:bbInit(s:sanitizeFT())
	catch /E117:/
	endtry

	try
		let l:e_out = BellyButton#{s:sanitizeFT()}#exec()
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
			call s:showErrors( get(l:e_out, 'sysout', ""), "BellyButton#".s:sanitizeFT()."#execParseError")
		catch /E117:/
		endtry
	endif

	echo get(l:e_out, 'sysout', "")

	call s:bbClean(s:sanitizeFT())
endf

function! BellyButtonModuleBase()
	let s:plugin_path = expand("~/")
	if has("win32")
		let s:plugin_path = s:plugin_path . "vimfiles"
	else
		let s:plugin_path = s:plugin_path . ".vim"
	endif
	return s:plugin_path . "/autoload/BellyButton/"
endfunction

fun! s:BellyButtonInfo()
	try
		let l:infod =  BellyButton#{s:sanitizeFT()}#info()
	catch /E117:/
		let l:infod = {}
	endtry
	"return {'lint':"Lint: Uses jslint to analyze code",
		"\'author':"Jeff Buttars",
		"\'authro_email':"jeffbuttars@gmail.com",
		"\'externals':["JSlint 2011-03-07 by Douglas Crockford:http://www.jslint.com/",
		"\"SpiderMonkey: http://www.mozilla.org/js/spidermonkey/",
		"\"V8:http://code.google.com/p/v8/"]
	"}
	let l:istr = "BellyButton ".printf('%.1f',g:BellyButtonVersion).", ft=".s:sanitizeFT()."\n\n"

	if empty(l:infod)
		let l:ist .= "No further information for this filetype plugin\n"
		echo l:istr
		return
	endif

	for [key,value] in [['desc','Description'],['lint','Lint'],['exec','Exec'], ['extra','Extra'],
				\['author','Author'],['author_email','Author Email']]
		if '' != get(l:infod, key, '')
			let l:istr .= printf('%-11s',value).": ".l:infod[key]."\n"
		endif
	endfor

	if [] != get(l:infod, 'externals', [])
		let l:istr .= "Externals:\n"
		for ext in l:infod['externals']
			let l:istr .= printf("%11s%s",' ',ext)."\n"
		endfor
	endif


	echo l:istr
endf

" This will retrieve the filetype of a BellyButton script that follows the
" naming scheme of <filetype>.vim. This enables very easy templating/boiler
" plate for plugin writers. 
"function! BellyButtonScriptFT()

	"let l:myft = expand('%')
	"let l:idx = strridx(l:myft, '.')
	"if -1 == l:idx
		"return "" 
	"endif

	"return strpart(l:myft, 0, l:idx)
"endfunction!


command! BellyButtonExtra call s:BellyButtonExtra()
command! BellyButtonLint call s:BellyButtonLint()
command! BellyButtonLintRaw call s:BellyButtonLintRaw()
command! BellyButtonExec call s:BellyButtonExec()
command! BellyButtonInfo call s:BellyButtonInfo()


au FileType * nmap <F3> <ESC>:w<CR>:BellyButtonExtra<CR>
au FileType * imap <F3> <ESC>:w<CR>:BellyButtonExtra<CR>
au FileType * nmap <F4> <ESC>:w<CR>:BellyButtonLint<CR>
au FileType * imap <F4> <ESC>:w<CR>:BellyButtonLint<CR>
au FileType * nmap <F5> <ESC>:w<CR>:BellyButtonExec<CR>
au FileType * imap <F5> <ESC>:w<CR>:BellyButtonExec<CR>

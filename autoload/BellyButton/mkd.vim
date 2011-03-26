
function! BellyButton#markdown#load()
endfunction

function! BellyButton#markdown#init()
	if !exists('s:bbmarkdown_initialized')
		" XXX TODO make these user configurable so they can easily
		" be set in the .vimrc
		" Also make the rendering of HTML,PDF and whatever else
		" configurable.
		let s:bbmarkdown_initialized = 1
		let s:BellyButton_markdown_markdown_exec_list = ['markdown2', 'markdown']
		let s:BellyButton_markdown_browser_list = ['xdg-open', 'google-chrome', 'firefox',
					\'konqueror', 'opera', 'safari']
		let s:BellyButton_markdown_pdf_list = ['okular',  'evince', 'acroread', 'xpdf', ]
	endif

	if exists('g:BellyButton_markdown_markdown_exec_list')
		let s:BellyButton_markdown_markdown_exec_list = g:BellyButton_markdown_markdown_exec_list
	endif
	if exists('b:BellyButton_markdown_markdown_exec_list')
		let s:BellyButton_markdown_markdown_exec_list = b:BellyButton_markdown_markdown_exec_list
	endif

	if exists('g:BellyButton_markdown_browser_list')
		let s:BellyButton_markdown_browser_list = g:BellyButton_markdown_browser_list
	endif
	if exists('b:BellyButton_markdown_browser_list')
		let s:BellyButton_markdown_browser_list = b:BellyButton_markdown_browser_list
	endif

	if exists('g:BellyButton_pdf_browser_list')
		let s:BellyButton_pdf_browser_list = g:BellyButton_pdf_browser_list
	endif
	if exists('b:BellyButton_pdf_browser_list')
		let s:BellyButton_pdf_browser_list = b:BellyButton_pdf_browser_list
	endif

endfunction

function! s:getPaths()
	let l:fpath = expand( '%' )
	let l:dname = system( "echo -n $(dirname '".l:fpath."')" )
	let l:dst = system( "echo -n $(basename '".l:fpath."' .mkd)" )
	
	return { 'src':l:fpath, 'dst': "".l:dname."/".l:dst }
endfunction

function! s:showHTML( target )
	let l:bopen = "" 
	for ext in s:BellyButton_markdown_browser_list
		if executable(ext)
			let l:bopen = ext
			break
		endif
	endfor

	let l:cmd = l:bopen." '".a:target.".html'"
	call system( l:cmd )
endfunction

function! s:showPDF( target )
	let l:bopen = "" 
	for ext in s:BellyButton_markdown_pdf_list
		if executable(ext)
			let l:bopen = ext
			break
		endif
	endfor

	let l:cmd = l:bopen." '".a:target.".pdf'"
	call system( l:cmd )
endfunction

function! s:renderHTML( src, target )
	" Find a markdown executable
	let b:mdown = "" 
	for ext in s:BellyButton_markdown_markdown_exec_list
		if executable(ext)
			let b:mdown = ext
			break
		endif
	endfor

	if ! len(b:mdown)
		echoerr "No markdown executable found."
		return {}
	endif

	echo b:mdown." '".a:src."' > '".a:target.".html'"
	let sysout = system( b:mdown." '".a:src."' > '".a:target.".html'" )
	return {'sysout':sysout, 'ecode':v:shell_error, 'good_ecode':0, 'parse_error':0}
endfunction

function! s:renderPDF( src, target )
	let b:mdown = "" 
	for ext in s:BellyButton_markdown_exec_list
		if executable(ext)
			let b:mdown = ext
			break
		endif
	endfor

	if ! len(b:mdown)
		echoerr "No markdown executable found."
		return {}
	endif

	if ! executable( 'htmldoc' )
		echoerr "No htmldoc executable found."
		return {}
	endif

"markdown2 $1 | htmldoc - --webpage -f $ofile; okular $ofile
	let sysout = system( b:mdown." '".a:src."' | htmldoc - --webpage -f '".a:target.".pdf'" )
	return {'sysout':sysout, 'ecode':v:shell_error, 'good_ecode':0, 'parse_error':0}
endfunction


" We don't really run a lint over markdown
" so we just render and show the out put
function! BellyButton#markdown#lintRaw()
	let l:paths = s:getPaths()
	call s:renderHTML( l:paths['src'], l:paths['dst'] )
	call s:showHTML(l:paths['dst'])
endfunction

function! BellyButton#markdown#extra()
	let l:paths = s:getPaths()
	call s:renderPDF( l:paths['src'], l:paths['dst'] )
	call s:showPDF(l:paths['dst'])
endfunction

function! BellyButton#markdown#parseLintError( eline )
	return {}
endfunction

function! BellyButton#markdown#exec()

	let sysout = ""
	
	let l:paths = s:getPaths()
	call s:renderHTML( l:paths['src'], l:paths['dst'] )
	call s:renderPDF ( l:paths['src'], l:paths['dst'] )

	return {'sysout':sysout, 'ecode':v:shell_error, 'good_ecode':0, 'parse_error':0}
endfunction

function! BellyButton#markdown#info()
	return {}
endfunction


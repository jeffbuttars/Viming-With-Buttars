
" XXX TODO make these user configurable so they can easily
" be set in the .vimrc
" Also make the rendering of HTML,PDF and whatever else
" configurable.
let s:mexecutables = ['markdown2', 'markdown']
let s:bexecutables = ['xdg-open', 'google-chrome', 'firefox', 'konqueror', 'opera', 'safari']
let s:pexecutables = ['okular',  'evince', 'acroread', 'xpdf', ]

function! s:getPaths()
	let l:fpath = expand( '%' )
	let l:dname = system( "echo -n $(dirname '".l:fpath."')" )
	let l:dst = system( "echo -n $(basename '".l:fpath."' .mkd)" )
	
	return { 'src':l:fpath, 'dst': "".l:dname."/".l:dst }
endfunction

function! s:showHTML( target )
	let l:bopen = "" 
	for ext in s:bexecutables
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
	for ext in s:pexecutables
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
	for ext in s:mexecutables
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
	for ext in s:mexecutables
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
function! BellyButton#mkd#lintRaw()
	let l:paths = s:getPaths()
	call s:renderHTML( l:paths['src'], l:paths['dst'] )
	call s:showHTML(l:paths['dst'])
endfunction

function! BellyButton#mkd#extra()
	let l:paths = s:getPaths()
	call s:renderPDF( l:paths['src'], l:paths['dst'] )
	call s:showPDF(l:paths['dst'])
endfunction

function! BellyButton#mkd#parseLintError( eline )
	return {}
endfunction

function! BellyButton#mkd#exec()

	let sysout = ""
	
	let l:paths = s:getPaths()
	call s:renderHTML( l:paths['src'], l:paths['dst'] )
	call s:renderPDF ( l:paths['src'], l:paths['dst'] )

	return {'sysout':sysout, 'ecode':v:shell_error, 'good_ecode':0, 'parse_error':0}
endfunction

function! BellyButton#mkd#Info()
	return "A helpful message"
endfunction


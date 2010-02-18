
"Set 'textwidth' to 78 characters.
setlocal textwidth=78
setlocal spell spelllang=en_us
" I prefer the CursorLine off when editing text
hi clear CursorLine

"http://plasticboy.com/markdown-vim-mode/
"Markdown format options
setlocal ai formatoptions=tcroqn2 comments=n:>

let b:NiceMenuMin 			= 3
let b:NiceMenuDelay 		= '.5' 
let b:NiceMenuEnableOmni	= 0
let b:NiceMenuDefaultCompl	= "\<C-X>\<C-K>"

"Generate the markup and maybe open a browser
let b:mdown = 'markdown2'
function! b:generateMkd( viewit )

	let l:fpath = expand( '%' )
	let l:fhtml = system( 'name=$(basename '.l:fpath.' .mkd); echo "$name.html"' )

	let l:cmd = b:mdown.' '.l:fpath.' > '.l:fhtml
	call system( l:cmd )

	if 1 == a:viewit
		let l:cmd = 'htmlview '.l:fhtml
		call system( l:cmd  )
	endif

endfunction

nmap <buffer> <F1> <ESC>:w<CR>:call b:generateMkd(0)<CR>
imap <buffer> <F1> <ESC>:w<CR>:call b:generateMkd(0)<CR>
nmap <buffer> <F5> <ESC>:w<CR>:call b:generateMkd(1)<CR>
imap <buffer> <F5> <ESC>:w<CR>:call b:generateMkd(1)<CR>



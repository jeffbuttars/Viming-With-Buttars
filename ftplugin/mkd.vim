
"Set 'textwidth'
if ! exists("g:maxLineLength")
	let g:maxLineLength=80
endif

let &textwidth=g:maxLineLength

setlocal spell spelllang=en_us

" I prefer the CursorLine and cursorcolumn off when editing text
hi clear CursorLine
set nocursorcolumn

"http://plasticboy.com/markdown-vim-mode/
"Markdown format options
setlocal ai formatoptions=tcroqn2 comments=n:>



let found_mkd = system("which markdown_py2")
if found_mkd != ""
    imap <F5> <ESC>:!markdown_py2 % > %.html<CR>
    nmap <F5> <ESC>:!markdown_py2 % > %.html<CR>
endif

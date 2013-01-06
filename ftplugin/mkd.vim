
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

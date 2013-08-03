
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

let s:mkd_exe = "markdown"

call system("which markdown_py2")
if v:shell_error == 0
    let s:mkd_exe = "markdown_py2"
endif

call system("which markdown_py")
if v:shell_error == 0
    let s:mkd_exe = "markdown_py"
endif

call system("which markdown2")
if v:shell_error == 0
    let s:mkd_exe = "markdown2"
endif

if s:mkd_exe != ""
    " imap <F5> <ESC>:!markdown_py2 -x toc -x fenced_code -x tables -x def_list -x attr_list -x codehilite -x headerid % > %.html<CR>
    " nmap <F5> <ESC>:!markdown_py2 -x toc -x fenced_code -x tables -x def_list -x attr_list -x codehilite -x headerid % > %.html<CR>

	exec "nmap <F5> <ESC>:!". s:mkd_exe ." -x toc -x fenced_code -x tables -x def_list -x attr_list -x codehilite -x headerid % > %.html<CR>"
	exec "imap <F5> <ESC>:!". s:mkd_exe ." -x toc -x fenced_code -x tables -x def_list -x attr_list -x codehilite -x headerid % > %.html<CR>"
endif



"markdown filetype file
if exists( "did\_load\_filetypes" )
	finish
endif

augroup markdown
	au!
	au BufRead,BufNewFile *.mkd,*.markdown setfiletype mkd
augroup END


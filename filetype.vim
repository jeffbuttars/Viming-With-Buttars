

"markdown filetype file
if exists( "did\_load\_filetypes" )
	finish
endif

augroup markdown
	au!
	au BufRead,BufNewFile *.mkd setfiletype mkd
augroup END


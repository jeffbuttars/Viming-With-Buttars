

"markdown filetype file
if exists( "did\_load\_filetypes" )
	finish
endif

augroup markdown
	au!
	au BufRead,BufNewFile *.md,*.mkd,*.markdown setfiletype mkd
augroup END

augroup json
	autocmd BufRead,BufNewFile *.json setfiletype json
augroup END

" augroup markmin
" 	autocmd BufRead,BufNewFile *.markmin setfiletype markmin
" augroup END

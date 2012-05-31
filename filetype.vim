augroup markdown
	au!
	au BufRead,BufNewFile *.md,*.mkd,*.markdown setfiletype mkd
augroup END

augroup json
	autocmd BufRead,BufNewFile *.json setfiletype json
augroup END

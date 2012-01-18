" HTML / Django Template 
"
augroup djml 
	"autocmd BufRead,BufNewFile *.djml setfiletype html.htmldjango
	autocmd BufNewFile,BufRead *.{djml} set filetype=html.htmldjango
augroup END

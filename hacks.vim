
" If I'm in a CPBSD dev dir, default the make command
" to be cpmake
if $CPBSDSRCDIR != "" && getcwd() =~ "^".$CPBSDSRCDIR
	set makeprg=cpmake

	let tstr = $CPBSDSRCDIR."/tags" 
	if filereadable( tstr )
		"" make sure our big ass bsd tags file
		"" is used in subdirs as well.
		set tags+=tstr 
	endif

	nmap <F9> <ESC>:make all<CR>
	imap <F9> <ESC>:make all<CR>
	nmap <F8> <ESC>:make build<CR>
	imap <F8> <ESC>:make build<CR>
	nmap <F7> <ESC>:make image<CR>
	imap <F7> <ESC>:make image<CR>
	nmap <F6> <ESC>:make kernel<CR>
	imap <F6> <ESC>:make kernel<CR>
endif


" Little something from http://www.ibm.com/developerworks/linux/library/l-vim-script-5/index.html 
" Agressive auto saving
function! Autosave()

	" close the preview window if it's visible
	" and the pop up menu is not visible
	if pumvisible() == 0
		pclose
	endif

	if ! &modified
		return
	endif

	if expand('%') != ""
		write
	endif

endfunction
autocmd FocusLost,BufLeave,WinLeave,CursorHold,CursorHoldI * :call Autosave()

function! SaveView( save )

	if &buftype == "quickfix" || expand('%') == ''
		return
	endif

	if 1 == a:save
		silent mkview
	else
		silent loadview
	endif

endfunction
au BufWinLeave * :call SaveView(1)
au BufWinEnter * :call SaveView(0)


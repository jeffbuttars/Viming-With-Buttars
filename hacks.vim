
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


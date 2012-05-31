" Little something from http://www.ibm.com/developerworks/linux/library/l-vim-script-5/index.html 
" Agressive auto saving
function! Autosave()

	" close the preview window if it's visible
	" and the pop up menu is not visible, but not if 
    " we're in a preview window.
	if pumvisible() == 0 && &buftype == ''
		pclose
	endif

	if ! &modified || ! &modifiable || &readonly
		return
	endif

	if expand('%') != ""
		write
	endif

endfunction
autocmd FocusLost,BufLeave,WinLeave,CursorHold,CursorHoldI * :call Autosave()


function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi StatColor guibg=orange ctermbg=lightred
  elseif a:mode == 'r'
    hi StatColor guibg=#e454ba ctermbg=magenta
  elseif a:mode == 'v'
    hi StatColor guibg=#e454ba ctermbg=magenta
  else
    hi StatColor guibg=red ctermbg=red
  endif
endfunction 

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black

function! MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif

		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T'

		" the label is made by MyTabLabel()
		" let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
		if has_key(g:tab_cwd_map, i+1)
			let s .= ' %#String#'.g:tab_cwd_map[i+1]
		endif

	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" right-align the label to close the current tab page
	if tabpagenr('$') > 1
	let s .= '%=%#TabLine#%999Xclose'
	endif

	return s
endfunction


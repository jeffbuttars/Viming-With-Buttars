" ## Hacks
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

" A more verbose pastetoggle
function! TogglePaste()
	if	&paste == 0
		set paste
		echo "Paste is ON!"
	else
		set nopaste
		echo "Paste is OFF!"
	endif
endfunction

" Allow toggling of paste/nopaste via F2
"set pastetoggle=<F2>
nmap <F2> <ESC>:call TogglePaste()<CR>
imap <F2> <ESC>:call TogglePaste()<CR>i

" No much going on here for Omni Completion. In the past there were all sorts of
" nasty hacks for this section.  
" When c-y is used to select a completion, enter normal mode after it's inserted.
" imap <c-y> <c-y><esc>
set completeopt=menuone,preview,longest
function! CmplChooseNorm()
	if pumvisible()
        return "\<ESC>"
	endif

    return "\<C-Y>"
endfunction
imap <c-y> <c-r>=CmplChooseNorm()<cr>

"highlight OverColLimit term=inverse,bold cterm=bold ctermbg=red ctermfg=black gui=bold guibg=red guifg=black 
function! SetColorColumn(ccol)

	if ! exists("b:longLineMatchID")
		let b:longLineMatchID = 0
	endif
	set cursorcolumn

	if !exists('&colorcolumn')
		return
	endif

	call clearmatches()

	"echo "SetColorColumn " b:longLineMatchID "" a:ccol "\%>".a:ccol."v.\+"

	if a:ccol == 0 || &buftype != "" || expand('%') == '' || &buftype == "log"
		setlocal colorcolumn=0
		let &textwidth = (0)
        " echo "bailing out"
		return
	endif

	let l:mlist = getmatches()
	if len(l:mlist) < 1 || b:longLineMatchID == 0 || &colorcolumn != (a:ccol+1)
		" echo "SetColorColumn applying" b:longLineMatchID "" a:ccol "\%>".a:ccol."v.\+"
		let &colorcolumn = (a:ccol)
		let &textwidth = (a:ccol-1)
		let b:longLineMatchID=matchadd( "ErrorMsg", '\%>'.a:ccol.'v.\+', -1 )
        LuciusLight
	endif

endfunction
if ! exists("g:maxLineLength")
	let g:maxLineLength=80
endif

au FileType python.sh :call SetColorColumn(g:maxLineLength)

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

let g:tab_cwd_map = {}
fun! TabDirSave(save)

	let l:tnum = tabpagenr()
	if a:save == 1
		let g:tab_cwd_map[l:tnum] = getcwd()
		" echo "saving " l:tnum g:tab_cwd_map[l:tnum]
	else	
		if has_key(g:tab_cwd_map, l:tnum)
			" echo "changing to " l:tnum g:tab_cwd_map[l:tnum]
			exec "cd ".g:tab_cwd_map[l:tnum]
			" exec "set guitablabel=".getcwd()
		endif
	endif

	exec "set tabline=%!MyTabLine()"
endf

au TabEnter * call TabDirSave(0)
au TabLeave * call TabDirSave(1)

" Open a shell command in a new window, the command supports shell completion
command! -complete=shellcmd -nargs=* R rightbelow vnew | r ! <args>

" Open a Quickfix window for the last search.
nnoremap <silent> ,/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

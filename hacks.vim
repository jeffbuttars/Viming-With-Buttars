
" If I'm in a CPBSD dev dir, default the make command
" to be cpmake. 
" I don't use this anymore. Relic from a previous job.
" The gist is, if I'm under a certain directory than I assume
" I'm working on a specific problem. In that case I setup
" some hotkeys to make the overlly verbose build commands easier.
   " if $CPBSDSRCDIR != "" && getcwd() =~ "^".$CPBSDSRCDIR
   " 	set makeprg=cpmake
   " 
   " 	let tstr = $CPBSDSRCDIR."/tags" 
   " 	if filereadable( tstr )
   " 		"" make sure our big ass bsd tags file
   " 		"" is used in subdirs as well.
   " 		set tags+=tstr 
   " 	endif
   " 
   " 	nmap <silent> <F10> <ESC>:w<CR><ESC>:make -j10 kernel<CR><ESC>make -10 build<CR><ESC>:make imageclean<CR><ESC>make image<CR>
   " 	imap <silent> <F10> <ESC>:w<CR><ESC>:make -j10 kernel<CR><ESC>make -10 build<CR><ESC>:make imageclean<CR><ESC>make image<CR>
   " 	nmap <silent> <F9>  <ESC>:w<CR><ESC>:make all<CR>
   " 	imap <silent> <F9>  <ESC>:w<CR><ESC>:make all<CR>
   " 	nmap <silent> <F8>  <ESC>:w<CR><ESC>:make -j10 build<CR>
   " 	imap <silent> <F8>  <ESC>:w<CR><ESC>:make -j10 build<CR>
   " 	nmap <silent> <F7>  <ESC>:w<CR><ESC>:make imageclean<CR><ESC>:make image<CR>
   " 	imap <silent> <F7>  <ESC>:w<CR><ESC>:make imageclean<CR><ESC>:make image<CR>
   " 	nmap <silent> <F6>  <ESC>:w<CR><ESC>:make kernel<CR>
   " 	imap <silent> <F6>  <ESC>:w<CR><ESC>:make kernel<CR>
   " else
   " 	nmap <silent> <F6>  <ESC>:w<CR><ESC>:make<CR><CR><CR>
   " 	imap <silent> <F6>  <ESC>:w<CR><ESC>:make<CR><CR><CR>
   " endif


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

function! SaveView( save )

	"if &buftype == "quickfix" || &buftype == "nofile" || expand('%') == ''
		"return
	"endif
	if &buftype != "" || expand('%') == ''
		return
	endif

	" if 1 == a:save
	" 	silent mkview
	" else
	" 	silent loadview
	" endif

endfunction
" au BufWinLeave * :call SaveView(1)
" au BufWinEnter * :call SaveView(0)

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

	if a:ccol == 0 || &buftype != "" || expand('%') == '' || &buftype == "log" || &ft == "log" || &ft == 'html' || &ft == 'css'
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

	endif

endfunction
if ! exists("g:maxLineLength")
	let g:maxLineLength=80
endif

" au BufWinEnter,FileType * :call SetColorColumn(g:maxLineLength)
au FileType * :call SetColorColumn(g:maxLineLength)

""""""""""""""""""""""""""""""""""""""
"
" Indent Python in the Google way.
"
" Only load up the Google stuff ofr python files
autocmd FileType python runtime google-python.vim 
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Great status line code from: 
" [a_smarter_statusline_code_in_comments](http://www.reddit.com/r/vim/comments/gexi6/a_smarter_statusline_code_in_comments/)
" 
hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline.="%#StatColor#"
    endif
    let statusline.="\(%n\)\ %f\ "
    if a:mode == 'Enter'
        let statusline.="%*"
    endif
    let statusline.="%#Modified#%m"
    if a:mode == 'Leave'
        let statusline.="%*%r"
    elseif a:mode == 'Enter'
        let statusline.="%r%*"
    endif

	let statusline .= "\ (%l/%L,\ %c)\ %P%=%w\ %y\ %r\ [%{&encoding}:%{&fileformat}]\ tw:%{&textwidth}\ "
	" if exists('g:maxLineLength')
	" 	let statusline .= "maxcol:".g:maxLineLength."\ "
	" else
	" 	let statusline .= "\ "
	" endif


	" set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %{&textwidth}\ %P
    return statusline
endfunction

au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
set statusline=%!MyStatusLine('Enter')

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

" Django rific
if $CPCLOUD_BASE != ""
	let $DJAGNO_SETTINGS_MODULE=$CPCLOUD_BASE."/web/nimbo/settings"
endif

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


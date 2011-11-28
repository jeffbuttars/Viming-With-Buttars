
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

	nmap <silent> <F10> <ESC>:w<CR><ESC>:make -j10 kernel<CR><ESC>make -10 build<CR><ESC>:make imageclean<CR><ESC>make image<CR>
	imap <silent> <F10> <ESC>:w<CR><ESC>:make -j10 kernel<CR><ESC>make -10 build<CR><ESC>:make imageclean<CR><ESC>make image<CR>
	nmap <silent> <F9>  <ESC>:w<CR><ESC>:make all<CR>
	imap <silent> <F9>  <ESC>:w<CR><ESC>:make all<CR>
	nmap <silent> <F8>  <ESC>:w<CR><ESC>:make -j10 build<CR>
	imap <silent> <F8>  <ESC>:w<CR><ESC>:make -j10 build<CR>
	nmap <silent> <F7>  <ESC>:w<CR><ESC>:make imageclean<CR><ESC>:make image<CR>
	imap <silent> <F7>  <ESC>:w<CR><ESC>:make imageclean<CR><ESC>:make image<CR>
	nmap <silent> <F6>  <ESC>:w<CR><ESC>:make kernel<CR>
	imap <silent> <F6>  <ESC>:w<CR><ESC>:make kernel<CR>
else
	nmap <silent> <F6>  <ESC>:w<CR><ESC>:make<CR><CR><CR>
	imap <silent> <F6>  <ESC>:w<CR><ESC>:make<CR><CR><CR>
endif


" Little something from http://www.ibm.com/developerworks/linux/library/l-vim-script-5/index.html 
" Agressive auto saving
function! Autosave()

	" close the preview window if it's visible
	" and the pop up menu is not visible
	if pumvisible() == 0
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
function! SetColorColumn( ccol )
	if &filetype == "log"
		return
	endif

	if ! exists("b:longLineMatchID")
		let b:longLineMatchID = 0
	endif
	set cursorcolumn

	if !exists('&colorcolumn')
		return
	endif

	call clearmatches()

	"echo "SetColorColumn " b:longLineMatchID "" a:ccol "\%>".a:ccol."v.\+"

	if &buftype != "" || expand('%') == ''
		setlocal colorcolumn=0
		let &textwidth = (0)
		return
	endif

	let l:mlist = getmatches()
	if len(l:mlist) < 1 || b:longLineMatchID == 0 || &colorcolumn != (a:ccol+1)
		"echo "SetColorColumn applying" b:longLineMatchID "" a:ccol "\%>".a:ccol."v.\+"
		let &colorcolumn = (a:ccol+1)
		let &textwidth = (a:ccol)
		let b:longLineMatchID=matchadd( "ErrorMsg", '\%>'.a:ccol.'v.\+', -1 )
	endif
endfunction

if ! exists("g:maxLineLength")
	let g:maxLineLength=80
endif

au BufWinEnter * :call SetColorColumn(g:maxLineLength)
"au FileType python,c,javascript :call SetColorColumn(g:maxLineLength)

""""""""""""""""""""""""""""""""""""""
" Indent Python in the Google way.
""""""""""""""""""""""""""""""""""""""
autocmd FileType python setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 100 " maximum number of lines to look backwards.
function! GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

autocmd FileType python let pyindent_nested_paren="&sw*2"
autocmd FileType python let pyindent_open_paren="&sw*2"
""""""""""""""""""""""""""""""""""""""
" END -- Indent Python in the Google way.
""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Great status line code from:
" http://www.reddit.com/r/vim/comments/gexi6/a_smarter_statusline_code_in_comments/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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



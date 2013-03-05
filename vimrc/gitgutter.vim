
" Set up the autocommand to do the clear
" because the colo script will be ran after this
" script. 
if has('g:gitgutter_enabled')
    if g:gitgutter_enabled == 1
        au BufWinEnter * highlight clear SignColumn
    endif
else
    au BufWinEnter * highlight clear SignColumn
endif

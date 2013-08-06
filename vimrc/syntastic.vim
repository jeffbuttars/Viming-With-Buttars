
let g:syntastic_check_on_wq=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_loc_list_height=10
let g:syntastic_quiet_warnings=0
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_python_checkers=['flake8']
" let g:syntastic_python_checkers_args=['flake8']
"
let g:syntastic_mode_map = { 'mode': 'active',
                               \ 'active_filetypes': ['c', 'python', 'ruby', 'php'],
                               \ 'passive_filetypes': [''] }

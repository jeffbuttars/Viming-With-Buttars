"
" #### Ctrl-P
" let g:ctrlp_map = '<c-l>'
imap <C-l> <ESC>:CtrlPBuffer<CR>
map  <C-l> <ESC>:CtrlPBuffer<CR>

let g:ctrlp_use_caching = 1
let g:ctrlp_max_height = 30
let g:ctrlp_clear_cache_on_exit = 1

" Ignore repos and virtualenvs
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|venv)$',
  \ 'file': '\v\.(pyc|pyo|so|dll)|tags$',
  \ }
" \ 'link': 'some_bad_symbolic_links',

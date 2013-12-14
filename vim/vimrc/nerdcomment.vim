" #### NERDCommenter 
"
let b:leader = exists('g:mapleader') ? g:mapleader : '\'
" I like to use CTRL-C to toggle comments 
exec 'noremap <C-C> :call NERDComment("n", "AlignLeft")<cr>'
exec 'noremap <C-N> :call NERDComment("n", "Uncomment")<cr>'

" I like space around comments
let g:NERDSpaceDelims = 1

" Custom comment delimiters for NERDCommenter 
if exists("loaded_nerd_comments")
    let g:NERDCustomDelimiters = {
        \ 'python': { 'left': '#' },
        \ 'ecl': { 'left': '//', 'leftAlt': '/*', 'rightAlt': '*/' },
    \ }
endif

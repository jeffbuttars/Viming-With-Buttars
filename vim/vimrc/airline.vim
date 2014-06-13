
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#bufferline#enabled = 1

if $TERM_META =~ 'white'
    let g:airline_theme='light'
else
    let g:airline_theme='dark'
endif

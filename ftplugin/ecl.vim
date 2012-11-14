
" mock.ecl(7,14): error C3002: syntax error near "UNSIGNED4" : expected :=, ';'
" bd_base_index.ecl(9,9): error C2167: Unknown identifier " "bettorfeed_recordtype_5_Rec"
set errorformat=%f(%l\\,%c):\ %trror\ C%n%m,%f(%l\\,%c):\ %tarning\ C%n%m
set makeprg=eclcc\ -syntax\ '%'


" Disable the text width
setlocal textwidth=0

nmap <F8> <ESC>:!eclcc -syntax '%'<CR>
imap <F8> <ESC><ESC>:!eclcc -syntax '%'<CR>



if exists(":AsyncShell")
    nmap <F7> <ESC>:AsyncShell time ecl run --cluster=hthor --server=. '%'<CR>
    imap <F7> <ESC><ESC>:AsyncShell time ecl run --cluster=hthor --server=. '%'<CR>
else
    nmap <F7> <ESC>:!time ecl run --cluster=hthor --server=. '%'<CR>
    imap <F7> <ESC><ESC>:!time ecl run --cluster=hthor --server=. '%'<CR>
endif

" Config for tComment
if exists('loaded_tcomment')
    call tcomment#DefineType('ecl',              '// %s'            )
    call tcomment#DefineType('ecl_inline',       g:tcommentInlineC  )
    call tcomment#DefineType('ecl_block',        g:tcommentBlockC   )
endif

" Syntastic syntax checker
" function SyntaxCheckers_ecl_GetLocList()
" endfunction

" if exists("loaded_ecl_syntax_checker")
"     finish
" endif
" let loaded_ecl_syntax_checker = 1
" 
" if !exists('g:syntastic_ecl_checker') || !executable(g:syntastic_ecl_checker)
"     if executable("eclcc")
"         let g:syntastic_ecl_checker = 'eclcc'
"     endif
"     finish
" endif
" 
" if !exists('g:syntastic_ecl_checker_args')
"     let g:syntastic_ecl_checker_args = ''
" endif

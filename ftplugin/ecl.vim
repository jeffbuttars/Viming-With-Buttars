
" mock.ecl(7,14): error C3002: syntax error near "UNSIGNED4" : expected :=, ';'
" bd_base_index.ecl(9,9): error C2167: Unknown identifier " "bettorfeed_recordtype_5_Rec"
set errorformat=%f(%l\\,%c):\ %trror\ C%n%m,%f(%l\\,%c):\ %tarning\ C%n%m
set makeprg=eclcc\ -syntax\ '%'

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
if exists('tcomment#DefineType')
    call tcomment#DefineType('ecl',              '// %s'            )
    call tcomment#DefineType('ecl_inline',       g:tcommentInlineC  )
    call tcomment#DefineType('ecl_block',        g:tcommentBlockC   )
endif

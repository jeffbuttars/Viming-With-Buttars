
" mock.ecl(7,14): error C3002: syntax error near "UNSIGNED4" : expected :=, ';'
set makeprg=eclcc\ -syntax\ '%'
set errorformat=%f(%l,%c):\ error\ %t%n:\ %m

nmap <F8> <ESC>:!eclcc -syntax '%'<CR>
imap <F8> <ESC><ESC>:!eclcc -syntax '%'<CR>



if exists(":AsyncShell")
    nmap <F7> <ESC>:AsyncShell time ecl run --cluster=hthor --server=. '%'<CR>
    imap <F7> <ESC><ESC>:AsyncShell time ecl run --cluster=hthor --server=. '%'<CR>
else
    nmap <F7> <ESC>:!time ecl run --cluster=hthor --server=. '%'<CR>
    imap <F7> <ESC><ESC>:!time ecl run --cluster=hthor --server=. '%'<CR>
endif

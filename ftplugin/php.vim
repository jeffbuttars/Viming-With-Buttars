
" Found this at:
" http://phpslacker.com/2009/02/05/vim-tips-for-php-programmers/ 
" highlights interpolated variables in sql strings and does sql-syntax highlighting. yay
let php_sql_query=1
" does exactly that. highlights html inside of php strings
let php_htmlInStrings=1
" discourages use oh short tags. c'mon its deprecated remember
let php_noShortTags=1
" automagically folds functions & methods. this is getting IDE-like isn't it?
"autocmd FileType php let php_folding=1
"
" CursorLine really slows down php files
" There is something wrong with the PHP syntax
" plugin, as a work around we disable cursorline
" for PHP files. :(
set nocursorline 

" Drupal rules
" If you edit a lot of php-drupal you should
" use these next few lines. If not, leave them commented
" out and I doubt you'll miss them.
   " augroup drupal_module
   " 	autocmd BufRead *.module,*.inc set filetype=php
   " augroup END

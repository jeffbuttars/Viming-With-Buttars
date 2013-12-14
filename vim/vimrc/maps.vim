" Easy cycle through tabs using Ctrl-PgUp/PgDown 
" similar to FireFox
" This won't work in all terminal programs. some use
" this same key sequence to cycley through tabs, so you
" may need to disable this key shortcut in your terminal
" program for this mapping to work as advertised.
nmap <C-PageDown> :tabnext<CR>
nmap <C-PageUp> :tabprevious<CR>
imap <C-PageDown> :tabnext<CR>
imap <C-PageUp> :tabprevious<CR>
"nmap <C-PageDown> :bn<CR>
"nmap <C-PageUp> :bp<CR>
"imap <C-PageDown> <esc>:bn<CR>
"imap <C-PageUp> <esc>:bp<CR>

"[concisionandconcinnity.blogspot.com](http://concisionandconcinnity.blogspot.com/2009/07/vim-part-ii-matching-pairs.html)
" The above URL also has good stuff for autoclosing matching pairs, like (). 
"One of the nicer minor features of TextMate is its treatment of highlighted text. 
"If you have something highlighted and type a, it replaces the text, like other editors. 
"If you type (, however, it wraps the selected text in parentheses. 
"This is enormously useful. Luckily, it's very easy to recreate in Vim:
vnoremap ((  <ESC>`>a)<ESC>`<i(<ESC>
vnoremap ))  <ESC>`<i(<ESC>`><right>a)<ESC>
vnoremap {{  <ESC>`>a}<ESC>`<i{<ESC>
vnoremap }}  <ESC>`<i{<ESC>`><right>a}<ESC>
" If allow " here, it messes up register selection
" So we use "" instead, and it works.
" Move this into doubleTap?
"vnoremap "  <ESC>`>a"<ESC>`<i"<ESC>
vnoremap ""  <ESC>`>a"<ESC>`<i"<ESC>
vnoremap ''  <ESC>`>a'<ESC>`<i'<ESC>
vnoremap ``  <ESC>`>a`<ESC>`<i`<ESC>
vnoremap [[  <ESC>`>a]<ESC>`<i[<ESC>
vnoremap ]]  <ESC>`<i[<ESC>`><right>a]<ESC>

" This allows us to save a file as root with the :w!! command,
" if we have sudo privileges, " when we're not currently useing vim as root
cmap w!! %!sudo tee > /dev/null %


"interactive spell check
" works only in non-gui mode for now
map #sp :w<CR>:!ispell %<CR>:e %<CR> 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
"You press * or # to search for the current visual selection !! Really useful
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" End From an idea by Michael Naumann
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

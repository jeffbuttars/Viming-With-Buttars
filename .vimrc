" Vim
"
" An example for a vimrc file.
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc

filetype plugin on

set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
set ai			" always set autoindenting on
" set tw=78		" always limit the width of text to 78
set backup		" keep a backup file
set viminfo='20,\"500	" read/write a .viminfo file, don't store more
			" than 50 lines of registers

" Don't use Ex mode, use Q for formatting
"map Q gq
"map [ :bp<CR>
"map ] :bn<CR>


" wrap long lines
set wrap
                               
" report result of commands over one or more lines
set report=1 
set hidden

" Enclose a line in '//' comments using c, uncomment with C
" Still need to smarten this up so will only comment uncommented lines
" and uncomment commented lines.
"map c		I//A
"map C 		^xx$
" 
" comments default: sr:/*,mb:*,el:*/,://,b:#,:%,:XCOMM,n:>,fb:-
set comments=b:#,:%,:\",fb:-,n:>,n:),n:\"
"
"A more elaborate comment set up. Use Ctr-C to comment and Ctr-x to uncomment
" This will detect file types and use oneline comments accordingle. Cool
" because you visually select regions and comment/uncomment the whole region.
" works with marked regions to.
source ~/.vim/comments.vim

" Format a paragraph (72 characters) without breaking words
" map f		!}fmt 
"
"
"       ,L  = "Last updated" - insert time stamp and delete old time stamp
map     ,L mz1G/Last update: */e+1<CR>D:r!date<CR>kJ


"interactive spell check
" works only in non-gui mode for now
map #sp :w<CR>:!ispell %<CR>:e %<CR> 

"     dictionary: english words first
set   dictionary=/usr/dict/words,/usr/dict/extra.words
"

" Define "del" char to be the same as backspace (saves a LOT of trouble!)
map <C-V>127 <C-H>

"
" autowrite: "on" saves a lot of trouble
"set autowrite
set autowriteall
set	autoread
set ruler
" Change buffer without saving
"set hid


"



"
"-------------------------------------------------------------------------------
"Have vim fake your tabs, or not
" expand tabs
"set expandtab
"set softtabstop=4
"set softtabstop=0
set tabstop=4
set shiftwidth=4
set smarttab

" Fisher: More addons for myself and Buttars
set cindent
set cino=>4


set mousehide

set showmode
"     backup:  backups are for wimps  ;-)
set nobackup
" Show matching braces
set showmatch 
set showcmd
set modeline
"set splitbelow
"set splitright
set formatoptions+=l
set selection=inclusive
set shortmess=atI
set wildmenu
"set wildmode=longest:full,full
set wildmode=list:longest
"set previewheight=5

" set key timeout, good for remaps
set timeoutlen=300

" Set up the status line
"fun! <SID>SetStatusLine()
    "let l:s1="%-3.3n\\ %f\\ %h%m%r%w"
    "let
    "l:s2="[%{strlen(&filetype)?&filetype:'?'},%{&encoding},%{&fileformat}]"
    "let l:s3="%=\\ 0x%-8B\\ \\ %-14.(%l,%c%V%)\\ %<%P"
    "execute "set statusline=" . l:s1 . l:s2 . l:s3
"endfun
"set laststatus=2
"call <SID>SetStatusLine()


source /usr/share/vim/vim72/macros/shellmenu.vim
"let loaded_shellmenu = 1
"source /usr/share/vim/vim72/macros/matchit.vim
let loaded_matchit = 1

set history=1000
set hidden
nnoremap ' `
nnoremap ` '

" smart indent
set si

"colorscheme elflord
" use the baycomb scheme for a dark background
"colo baycomb 
"colo evening 
colo xoria256 
"colo ir_black 
"colo mySlate 
"colo vividchalk 
"colo TAqua 
hi Normal guibg=black

"Custom Omni menu colors
"hi Pmenu guibg=brown guifg=gold
"hi Pmenu ctermbg=blue ctermfg=white
"hi PmenuSel guibg=#555555 guifg=#ffffff
"hi PmenuSel guibg=#0000ff guifg=#ffffff
"hi PmenuSel ctermbg=red ctermfg=white


set nocp
filetype plugin on
filetype indent on
set incsearch " start searching when I start typing
"set ignorecase " Ignore case on searches.

" Highlight all search matches.
set hls

" set linenumbers on
set number 

 "Turn on syntax highlighting
syntax on

" drupal rules
if has("autocmd")
    augroup module
        autocmd BufRead *.module set filetype=php
    augroup END
endif

" Set taglist plugin options
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Winwidth = 40
let Tlist_Inc_Winwidth = 1

" Set bracket matching and comment formats
set matchpairs+=<:>
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:**,ex:*/
set comments+=fb:*
set comments+=b:\"
set comments+=n::

"iab DATE <C-R>=strftime("%B %d, %Y (%A, %H:%M)")<CR>
 
" Fix filetype detection
"au BufNewFile,BufRead .torsmorc* set filetype=rc
"au BufNewFile,BufRead *.inc set filetype=php
"au BufNewFile,BufRead *.sys set filetype=php
"au BufNewFile,BufRead grub.conf set filetype=grub
"au BufNewFile,BufRead *.dentry set filetype=dentry
"au BufNewFile,BufRead *.blog set filetype=blog



" block like structures.
" Funky auto bracing/parens
"au FileType c,h,javascript,html,xhtml,bash,python,php imap  (( ()<esc>i
" Use php syntax check when doing :make
" au FileType php set makeprg=php\ -l\ %
autocmd BufRead *.php,*.inc set makeprg=php\ -l\ %

" Use errorformat for parsing PHP error output
au FileType php set errorformat=%m\ in\ %f\ on\ line\ %l

au FileType htmlcheetah,cheetah set syntax=cheetah 

" Use errorformat for parsing sql error output
"au FileType sql set errorformat=on\ line\ %l:%m

source ~/.vim/plugin/mypy.vim



" Compile and run keymappings
"au FileType c,cpp map <F5> :!./%:r<CR>
"au FileType java map <F5> :make %<CR>
"au FileType sh,php,perl,python,ruby map <F5> :!./%<CR>
"au FileType java map <F6> :java %:r
au FileType php map <F5> :!php -l %<CR>
au FileType python,py map <F6> :w<CR>:!python %<CR>
"au FileType perl map <F6> :!perl %<CR>
"au FileType ruby map <F6> :!ruby %<CR>
au FileType html,xhtml map <F5> :!firefox %<CR>
"au FileType ruby setlocal sts=2 sw=2                " Enable width of 2 for ruby tabbing

" MS Word document reading
au BufReadPre *.doc set ro
au BufReadPre *.doc set hlsearch!
au BufReadPost *.doc %!antiword "%"

" Toggle dark/light default colour theme for shitty terms
"map <F2> :let &background = ( &background == "dark" ? "light" : "dark" )<CR>

" Toggle taglist script
inoremap <F3> <ESC>:Tlist<CR>
map <F3> <ESC>:Tlist<CR>

" Start with Tlist open.
autocmd FileType c,h,bash,python,php,js TlistUpdate

" VTreeExplorer
"map <F12> :VSTreeExplore <CR>
"let g:treeExplVertical=1
"let g:treeExplWinSize=35
"let g:treeExplDirSort=1

" Need to learn how to file type bases macros
" for python and stuff
" Pyton code helpers
"inoremap <CR><CR> <END><CR>
"inoremap :: <END>:<CR>
"inoremap {% {%%}<LEFT><LEFT>
 "Run in the Python interpreter
"function! Python_Eval_VSplit() range
 "let src = tempname()
 "let dst = tempname()
 "execute ": " . a:firstline . "," . a:lastline . "w " . src
 "execute ":!python " . src . " > " . dst
 "execute ":pedit! " . dst
"endfunction
"au FileType python vmap <F5> :call Python_Eval_VSplit()<cr>
"au FileType python map <F5> <ESC>:!python %<cr>





"Python version
"inoremap {{  {{}}<LEFT><LEFT>
" No sound on error "
set noerrorbells
    
" Set were to keep the swap files
"set dir=~/tmp

" When vimrc is edited, automatically reload it!
autocmd! bufwritepost .vimrc source ~/.vimrc

" Enable auto html/xml tag closing with C^-(provided by closetag.vim) for certain file type.
"let g:closetag_html_style=1
"au Filetype html,xml,xsl,xhtml,htm,php,inc,js source ~/.vim/closetag.vim 
"au Filetype html,xml,xsl,xhtml,htm so ~/.vim/plugin/XMLFolding.vim
"Some auto tag filling stuff
"au FileType html,xhtml, source ~/.vim/ftplugin/xml.vim
"au FileType html,xhtml, source ~/.vim/ftplugin/html.vim

" Map the '\' to automically create a fold region within
" the containing braced [ or curly braced { block.
"nmap <silent> <leader><leader> [{V%zf

" display fold info on the side
"set foldcolumn=1
set foldenable

" Automaticly save and load views
autocmd BufWinLeave * if expand("%") != "" | mkview | endif
autocmd BufWinEnter * if expand("%") != "" | silent loadview | endif

"set scrollbind

let g:LargeFile= 30	" in megabytes

" Enable use of the mouse in a terminal
set mouse=a

" Enable english spell checking
":setlocal spell spelllang=en

" Enable some omnicompletion types
autocmd FileType python runtime! autoload/pythoncomplete.vim
"autocmd FileType python set omnifunc=pythoncomplete#Complete
" Enable pysmell
"python import pysmell
"autocmd FileType python setlocal omnifunc=pysmell#Complete

autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType cpp set omnifunc=cppcomplete#Complete
autocmd FileType c set omnifunc=ccomplete#Complete

" Map omnicomplete to Control-r
imap <c-a> <C-X><C-O>
"imap <C-Tab> <C-x><C-o>

set completeopt=menu,preview
"set completeopt=menuone
"let OmniCpp_SelectFirstItem = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_ShowPrototypeInAbbr = 1

" movment keys while in insert mode?
imap <c-j> <Down>
imap <c-h> <Left>
imap <c-k> <Up>
imap <c-l> <Right>



" Auto close the preview window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"autocmd CursorMovedI * if pumvisible() == O|pclose|endif
"autocmd InsertLeave * if pumvisible() ==  O|pclose|endif
"autocmd CursorMovedI * if pumvisible() == pclose|endif
"autocmd InsertLeave * if pumvisible() ==  pclose|endif
     
" set background black when using gui.
hi Normal guibg=black
set diffopt=vertical

" Keep this many lines above/below the cursor while scrolling.
"set scrolloff=5
set so=3

"set grepprg=ack\ -n

" From an idea by Michael Naumann
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
"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>


try
    set switchbuf=usetab
    set stal=2
catch
endtry

" Always open stuff up in a new tab
":au BufAdd,BufNewFile,BufRead * nested tab sball

""""""""""""""""""""""""""""""
" SVN section
"""""""""""""""""""""""""""""""
map <F8> :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg

"autocmd InsertEnter * call setline( ".", "ha" ) 
"autocmd InsertChange * call setline( ".", "ha" ) 

au FileType c,cpp map <F5> <ESC>:make<cr>

set title
"Vertical Explore open file
let g:netrw_altv = 1


" Insert <Tab> or complete indentifier
" if the cursor isafter a keyword character.
"function MyTabOrComplete()
    "let col = col('.')-1
    "if !col || getline('.')[col-1] !~ '\k'
        "return "\<tab>"
    "else
        ""return "\<C-N>"
        "return "\<C-X>\<C-O>"
    "endif
"endfunction

"inoremap <Tab> <C-R>=MyTabOrComplete()<CR>

imap <C-k> <Up>
imap <C-l> <Right>
imap <C-j> <Down>
imap <C-h> <Left>

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
	echo a:cmdline
	let expanded_cmdline = a:cmdline
	for part in split(a:cmdline, ' ')
		if part[0] =~ '\v[%#<]'
			let expanded_part = fnameescape(expand(part))
			let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
		endif
	endfor
	botright new
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
	call setline(1, 'You entered:    ' . a:cmdline)
	call setline(2, 'Expanded Form:  ' .expanded_cmdline)
	call setline(3,substitute(getline(2),'.','=','g'))
	execute '$read !'. expanded_cmdline
	setlocal nomodifiable
	1
endfunction
" Enable running a file through JSLint and putting output in a scratch buffer
"cabbr js read !js ~/bin/runjslint.js "`cat %`" \| ~/bin/format_lint_output.py
"cabbr js Shell js ~/bin/runjslint.js "`cat %`" \| ~/bin/format_lint_output.py
cabbr jslint Shell jslint %
" Type make to run JSLINT and jump to error
" au FileType js,javascript set makeprg=jslint\ %
au BufRead *.js set makeprg=jslint\ %

" Use errorformat for parsing JSLINT error output
"Problem at line 13 character 26: ['length'] is better written in dot notation.    var num_rows = spec[ 'length' ];
au FileType js,javascript set errorformat=Problem\ at\ line\ %l\ character\ %c:\ %m 


"Enable autotag.vim
source ~/.vim/autotag.vim

" Allow a quick way back to traditional make when
" makeprg is set to something non-makeish
cabbr mmake !make

" Run pychecker on current file
cabbr pyck Shell pychecker %

" Easy cycle through buffers using Alt+Left/Right
nmap <A-Right> :bnext<CR>
nmap <A-Left> :bprevious<CR>


"Highlight current row/col
"au WinLeave * set nocursorline nocursorcolumn
"au WinEnter * set cursorline cursorcolumn
"set cursorline cursorcolumn
"au WinLeave * set nocursorline
"au WinEnter * set cursorline
"set cursorline


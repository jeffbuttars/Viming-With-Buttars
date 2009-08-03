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

" wrap long lines
set wrap
                               
" report result of commands over one or more lines
set report=1 
set hidden

" comments default: sr:/*,mb:*,el:*/,://,b:#,:%,:XCOMM,n:>,fb:-
set comments=b:#,:%,:\",fb:-,n:>,n:),n:\"

"A more elaborate comment set up. Use Ctr-C to comment and Ctr-x to uncomment
" This will detect file types and use oneline comments accordingle. Cool
" because you visually select regions and comment/uncomment the whole region.
" works with marked regions to.
"source ~/.vim/comments.vim
" don't need to source this, just put it in your plugin directory.

" Format a paragraph (72 characters) without breaking words
" map f		!}fmt 
"
"
"       ,L  = "Last updated" - insert time stamp and delete old time stamp
map     ,L mz1G/Last update: */e+1<CR>D:r!date<CR>kJ


"interactive spell check
" works only in non-gui mode for now
map #sp :w<CR>:!ispell %<CR>:e %<CR> 

"

" Define "del" char to be the same as backspace (saves a LOT of trouble!)
map <C-V>127 <C-H>

"
" autowrite: "on" saves a lot of trouble
"set autowrite
set autowriteall
set	autoread
" We use a custom statusline instead of ruler
"set ruler
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

"Use real tabs, 4 spaces
"set tabstop=4
"set shiftwidth=4
"set smarttab

" Emacs like tabs? this guy says for.
"http://smalltalk.gnu.org/blog/bonzinip/emacs-ifying-vims-autoindent
set cinkeys=0{,0},0),0#,!<Tab>,;,:,o,O,e
set indentkeys=!<Tab>,o,O
map <Tab> i<Tab><Esc>^
filetype indent on
" C opts
" Kernel style
set cinoptions=:0,(0,u0,W1s
" GNU style
"set cinoptions={1s,>2s,e-1s,^-1s,n-1s,:1s,p5,i4,(0,u0,W1s shiftwidth=2

"Not sure if this is needed:
"Unfortunately, this is still not enough because some ill-behaved vim files reset indentkeys instead of adding to it. 
"For this I used the following shell snippet:
"for i in tcl gitconfig ruby html xml php rst css make dtd xinetd yacc; do
"  echo 'setlocal indentkeys+=!<Tab>' > .vim/after/indent/$i
"done


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
"set statusline=%r%m%y\ %t\ b:%n\ %P\ %l,%v
" Like setting ruler, but we add the buffer number and filetype
"set statusline=%<%y\ %f\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set laststatus=2


set history=1000
set hidden
nnoremap ' `
nnoremap ` '

" smart indent
set si

"Highlight current row/col
"au WinLeave * set nocursorline nocursorcolumn
"au WinEnter * set cursorline cursorcolumn
" Using the cursorcolumn is pretty slow.
"set cursorline cursorcolumn
"au WinLeave * set nocursorline
"au WinEnter * set cursorline
set cursorline
" I hate it when the cursorline is an underline
hi clear CursorLine 
"hi CursorLine       ctermfg=255 guifg=#a8a8a8 ctermbg=0   guibg=#000000
"hi CursorLine       ctermbg=LightGray   guibg=#2c2c2c

" We want 256 colors.
set t_Co=256

"colorscheme elflord
" Dark background schemes
"colo baycomb 
"colo evening 
"colo xoria256 
"colo ir_black 
"colo mySlate 
"colo vividchalk 
colo jellybeans 

" White/Light themes
"colo nedit2 
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
        autocmd BufRead *.module,*.inc set filetype=php
    augroup END
endif



" Set taglist plugin options
" Display function name in status bar:
let g:ctags_statusline=1
" Automatically start script
let generate_tags=1
" Displays taglist results in a vertical window:
let Tlist_Use_Horiz_Window=0
" Shorter commands to toggle Taglist display
"nnoremap TT :TlistToggle<CR>
nnoremap TT :TlistOpen<CR>
map <F4> :TlistToggle<CR>

let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Compact_Format = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Winwidth = 40
let Tlist_Inc_Winwidth = 1
" Close Tlist when jumping to tag
let Tlist_Close_On_Select = 1

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


"au FileType htmlcheetah setlocal syntax=cheetah 
"au BufNewFile,BufRead *.tmpl setlocal filetype=cheetah

" Use errorformat for parsing sql error output
"au FileType sql set errorformat=on\ line\ %l:%m

source ~/.vim/plugin/mypy.vim



" Compile and run keymappings
"au FileType c,cpp map <F5> :!./%:r<CR>
"au FileType java map <F5> :make %<CR>
"au FileType sh,php,perl,python,ruby map <F5> :!./%<CR>
"au FileType java map <F6> :java %:r
"au FileType php map <F5> :!php -l %<CR>
"au FileType python,py map <F6> :w<CR>:!python %<CR>
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



"Python version
"inoremap {{  {{}}<LEFT><LEFT>
" No sound on error "
set noerrorbells
    
" Set were to keep the swap files
"set dir=~/tmp

" When vimrc is edited, automatically reload it!
autocmd! bufwritepost .vimrc source ~/.vimrc

" Enable auto html/xml tag closing with C^-(provided by closetag.vim) for certain file type.
au Filetype html,xml,xsl,xhtml,htm,php,inc,js source ~/.vim/scripts/closetag.vim 

" Map the '\' to automically create a fold region within
" the containing braced [ or curly braced { block.
"nmap <silent> <leader><leader> [{V%zf

" display fold info on the side
"set foldcolumn=2
"set foldenable
" Don't display fold info on the side
"set foldcolumn=0

" Automaticly save and load views
autocmd BufWinLeave * if expand("%") != "" | mkview | endif
autocmd BufWinEnter * if expand("%") != "" | silent loadview | endif

"I usually don't want this
" Set this if you want to split views to scroll together
" by default.
"set scrollbind

" For the large file plugin
let g:LargeFile= 30	" in megabytes

" Enable use of the mouse in a terminal
set mouse=a

"     dictionary: english words first
" add any text based dictionaries to the list.
" Also, you can use C-X,C-K to autocomplete a word
" using the dictionary.
set dictionary=/usr/share/dict/words,/usr/dict/words,/usr/dict/extra.words

" Enable english spell checking on text files.
":setlocal spell spelllang=en
"autocmd FileType txt setlocal spell spelllang=en
autocmd BufEnter *.txt,*.text setlocal spell spelllang=en

" Enable some omnicompletion types
autocmd FileType python runtime! autoload/pythoncomplete.vim
"autocmd FileType python set omnifunc=pythoncomplete#Complete
" Enable pysmell
"python import pysmell
"autocmd FileType python setlocal omnifunc=pysmell#Complete

autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType cpp setlocal omnifunc=cppcomplete#Complete
autocmd FileType c setlocal omnifunc=ccomplete#Complete

" Map omnicomplete to Control-o
imap <c-o> <C-X><C-O>

set completeopt=menuone,preview
"set completeopt=menuone
let OmniCpp_SelectFirstItem = 2
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_ShowPrototypeInAbbr = 1
imap <c-y> <c-y><esc>


" movment keys while in insert mode?
" interferes with some stuff, be careful, this
" may be bad for you
"imap <c-j> <Down>
"imap <c-h> <Left>
"imap <c-k> <Up>
"imap <c-l> <Right>

" Auto close the preview window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"autocmd CursorMovedI * if pumvisible() == O|pclose|endif
"autocmd InsertLeave * if pumvisible() ==  O|pclose|endif
"autocmd CursorMovedI * if pumvisible() == pclose|endif
"autocmd InsertLeave * if pumvisible() ==  pclose|endif
     
" set background black when using gui.
"hi Normal guibg=black

" make a diff split vertical by default
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

"You press * or # to search for the current visual selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" Can't say I fully understand this setting.
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
" Open an svn diff of the current file in a split
"map <F8> :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg
" use the VCS plugin to view a vimdiff of the current file
map <F8> :VCSVimDiff<CR>

" Some kind of experiment?
"autocmd InsertEnter * call setline( ".", "ha" ) 
"autocmd InsertChange * call setline( ".", "ha" ) 

" map F5 to the make command
"au FileType c,cpp map <F5> <ESC>:make<cr>
map <F5> <ESC>:make<cr>

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
au FileType js,javascript setlocal makeprg=jslint\ %
" Use errorformat for parsing JSLINT error output, example outoupt:
"Problem at line 13 character 26: ['length'] is better written in dot notation.    var num_rows = spec[ 'length' ];
au FileType js,javascript setlocal errorformat=Problem\ at\ line\ %l\ character\ %c:\ %m 


" Run pychecker on current file
cabbr pyck Shell pychecker %
au FileType *.py setlocal makeprg=pychecker\ %
"au BufEnter *.py setlocal makeprg=pychecker\ %
"the last line: \%-G%.%# is meant to suppress some
"late error messages that I found could occur e.g.
"with wxPython and that prevent one from using :clast
"to go to the relevant file and line of the traceback.
au FileType python setlocal errorformat=
	\%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
	\%C\ \ \ \ %.%#,
	\%+Z%.%#Error\:\ %.%#,
	\%A\ \ File\ \"%f\"\\\,\ line\ %l,
	\%+C\ \ %.%#,
	\%-C%p^,
	\%Z%m,
	\%-G%.%#

" Use php syntax check when doing :make
au FileType php setlocal makeprg=php\ -l\ %
autocmd BufEnter *.php,*.inc,*.module setlocal makeprg=php\ -l\ %
" Use errorformat for parsing PHP error output
au FileType php setlocal errorformat=%m\ in\ %f\ on\ line\ %l

" Allow a quick way back to traditional make when
" makeprg is set to something non-makeish.
" bad hack.
cabbr mmake !make

"Enable autotag.vim
source ~/.vim/autotag.vim


" Easy cycle through buffers using Ctrl-PgUp/PgDown 
" similar to FireFox
nmap <C-PageDown> :bnext<CR>
nmap <C-PageUp> :bprevious<CR>

" Use Ctrl-l to cut to the buf browser from bufexplorer plugin
" Think l as in 'list the buffers'
nmap <C-l> <ESC>\be
imap <C-l> <ESC>\be
" Bufexplorer options
 "let g:bufExplorerSortBy='extension'  " Sort by file extension.
 "let g:bufExplorerSortBy='fullpath'   " Sort by full file path name.
 "let g:bufExplorerSortBy='mru'        " Sort by most recently used.
 "let g:bufExplorerSortBy='name'       " Sort by the buffer's name.
 "let g:bufExplorerSortBy='number'     " Sort by the buffer's number.


" My own little helpers
imap ;; <END>;<ESC>:w<CR>
map ;; <Insert><END>;<ESC>:w<CR>
imap (( ()<Left>
imap [[ []<Left>
imap "" ""<Left>
imap '' ''<Left>


" This fucks up ctags
" You can use isk 'is keyword' to change
" how searching works.
"set isk=@,48-57,192-255
"set isk-=_

" Disable binary search on tags.
"set notagbsearch

" Make the CWD directory follow the current buffer, may brake plugins
" Not a big fan of this.
"set autochdir

"http://concisionandconcinnity.blogspot.com/2009/07/vim-part-ii-matching-pairs.html
" The above URL also has good stuff for autoclosing matching pairs, like (). 
"One of the nicer minor features of TextMate is its treatment of highlighted text. 
"If you have something highlighted and type a, it replaces the text, like other editors. 
"If you type (, however, it wraps the selected text in parentheses. 
"This is enormously useful. Luckily, it's very easy to recreate in Vim:
vnoremap (  <ESC>`>a)<ESC>`<i(<ESC>
vnoremap )  <ESC>`>a)<ESC>`<i(<ESC>
vnoremap {  <ESC>`>a}<ESC>`<i{<ESC>
vnoremap }  <ESC>`>a}<ESC>`<i{<ESC>
" If allow " here, it messes up register selection
" So we use "" instead, and it works.
"vnoremap "  <ESC>`>a"<ESC>`<i"<ESC>
vnoremap ""  <ESC>`>a"<ESC>`<i"<ESC>
vnoremap '  <ESC>`>a'<ESC>`<i'<ESC>
vnoremap `  <ESC>`>a`<ESC>`<i`<ESC>
vnoremap [  <ESC>`>a]<ESC>`<i[<ESC>
vnoremap ]  <ESC>`>a]<ESC>`<i[<ESC>


"People and places that I've gotten stuff from
"http://dancingpenguinsoflight".com"/2009/02/code-navigation-completion-snippets-in-vim/
"http://www.thegeekstuff.com/2009/01/vi-and-vim-editor-5-awesome-examples-for-automatic-word-completion-using-ctrl-x-magic/



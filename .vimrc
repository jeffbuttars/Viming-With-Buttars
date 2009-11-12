" We start from the default example .vimrc
" and then tweak from there.
"
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=500		" keep 500 lines of command line history
"set ruler		" show the cursor position all the time
" Set up a custom status line. Like setting ruler, but we add the buffer number and filetype to the status
set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"set statusline=%f\ %<%y\ b%n\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)

set laststatus=2

set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniCompletion settings
" When c-y is used to select, enter normal mode.
imap <c-y> <c-y><esc>
" Show the info preview window.
set completeopt=menuone,preview,longest

"(default: ".,w,b,u,t,i")
"set complete=".,w,b,u,U,t,i,kspell,d,t"
"set complete=".,w,b,u,t,i,kspell"
" Map omnicomplete to Control-o
imap <c-o> <C-X><C-O> 
" When the completion window is open, shift will cycle
" forward through the menu.
" This does not work with snipmate, so I have a hack
" in after/plugin/snipmate
"function! CleverTab()
	"if !pumvisible() 
		"return "\<Tab>"
	"endif

	"return "\<C-N>"
"endfunction
"inoremap <Tab> <C-R>=CleverTab()<CR>

" Enter will do a simple accept of the selection
"Moved this into delimitMate to get them
"to work together
"function! CleverCR()
	"if !pumvisible() 
		"return "\<CR>"
	"endif

	"return "\<C-Y>"
"endfunction
"inoremap <CR> <C-R>=CleverCR()<CR>


" Auto close the preview window
autocmd CursorHold * if pumvisible() == 0|pclose|endif
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif


" My snipmate hack to work with popup_it.vim
let g:SnipeMateAllowOmniTab = 1

"End OmniCompletion settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" More normal Vim tweaks.
" make a diff split vertical by default
" ignore whitespace
" show 10 lines of context
set diffopt=filler,vertical,iwhite,context:10

"Use real tabs, 4 spaces
set tabstop=4
set shiftwidth=4
set smarttab

" Show matching braces
set showmatch 
" Quick blink when a match is made
set mat=5

" Keep our swap and backup files out of the way
set directory=~/.vim/swapback
set backupdir=~/.vim/swapback

" C opts
" Kernel style
"set cinoptions=:0,(0,u0,W1s

" Keep this many lines above/below the cursor while scrolling.
"set scrolloff=5
set so=3

set title

" Easy cycle through buffers using Ctrl-PgUp/PgDown 
" similar to FireFox
nmap <C-PageDown> :bnext<CR>
nmap <C-PageUp> :bprevious<CR>

" My own little helpers
" remove trailing whitespace, put a ; on the end of the line and write the
" buffer.
imap ;; <ESC>:s/\s*$//<CR><Insert><END>;<ESC>:w<CR>:nohl<CR>:<ESC>
nmap ;; <ESC>:s/\s*$//<CR><Insert><END>;<ESC>:w<CR>:nohl<CR>:<ESC>

" No ; and end of line in python, so just save the file, trim the end and put
" the cursor at the end of the line.
" But, we can do something similar for :
au FileType python imap ;; <ESC>:s/\s*$//<CR><END><ESC>:w<CR>:nohl<CR>o<ESC>
au FileType python nmap ;; <ESC>:s/\s*$//<CR><END><ESC>:w<CR>:nohl<CR>o<ESC>
au FileType python nmap :: <ESC>:s/\s*$//<CR><Insert><END>:<END><ESC>:w<CR>:nohl<CR>o
au FileType python imap :: <ESC>:s/\s*$//<CR><Insert><END>:<END><ESC>:w<CR>:nohl<CR>o

au FileType php,javascript,js nmap ,, <ESC>:s/\s*$//<CR><Insert><END>,<END><ESC>:w<CR>:nohl<ESC>
au FileType php,javascript,js imap ,, <ESC>:s/\s*$//<CR><Insert><END>,<END><ESC>:w<CR>:nohl<ESC>

" Drop the close match then move the cursor in between them
"let g:delimitMate_autoclose = 0
"let b:delimitMate_expand_space = 0
"let b:delimitMate_expand_cr = 0
imap (( ()<Left>
imap [[ []<Left>
imap {{ {}<Left>
"imap "" ""<Left>
"imap '' ''<Left>
"au FileType javascript ++ ++<Left>

" If the given char is to the 
" right of us, go to the right of it.
" But only if it appears to close a matching
" left? Maybe we'll do that last part later, we'll see.
function! GoToNextChar( thechar )
	" See if it's there.
	let l:cline = getline(".")
	let l:cpos = getpos(".")
	let l:ccol = l:cpos[2]-1

	let l:nchar = stridx( l:cline, a:thechar, l:ccol )
	if l:nchar < l:ccol
		if a:thechar == '"' || a:thechar == "'" || a:thechar == "+"
			return a:thechar.a:thechar."\<left>"
		endif
		return a:thechar.a:thechar
	endif

	let l:ccur = getpos(".")
	let l:ccur[2] = l:nchar+2
	call setpos( '.', l:ccur )

	return ""
endfunction
 
imap )) <C-R>=GoToNextChar(")")<CR>
imap ]] <C-R>=GoToNextChar("]")<CR>
imap "" <C-R>=GoToNextChar('"')<CR>
imap '' <C-R>=GoToNextChar("'")<CR>
imap }} <C-R>=GoToNextChar("}")<CR>
au FileType javascript imap ++ <C-R>=GoToNextChar('+')<CR>


" Use this mapping in conjuction with delimitMate 
" is great if the delimitMate_autoclose is off.
"imap (( ()
"imap [[ []
"imap {{ {}
"imap "" ""
"imap '' ''

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

" When vimrc is edited, automatically reload it!
autocmd! bufwritepost .vimrc source ~/.vimrc

set viminfo='20,\"500	" read/write a .viminfo file, don't store more
			" than 50 lines of registers

" wrap long lines
set wrap
" Some wordwrapp foo from
"http://kmandla.wordpress.com/2009/07/27/proper-word-wrapping-in-vim/
set formatoptions+=l
set lbr

set selection=inclusive
set shortmess=atI
set wildmenu
set wildmode=list:longest

" set key timeout, good for remaps
set timeoutlen=300

" I hate it when the cursorline is an underline
set cursorline
hi clear CursorLine 

" Explicitly say we want 256 colors.
" When this is set it can mess up using vim on a real console.
"  Definitely in Fedora 11.
set t_Co=256

" Dark background schemes
"colo elflord
"colo baycomb 
"colo evening 
"colo xoria256 
"colo wombat256
"colo pyte " A white theme
"colo ir_black 
"colo mySlate 
"colo vividchalk 
" A light theme.
"colo peaksea 
colo jellybeans 

" set linenumbers on
set number 

" drupal rules
if has("autocmd")
    augroup module
        autocmd BufRead *.module,*.inc set filetype=php
    augroup END
endif

" autowrite: "on" saves a lot of trouble
"set autowrite
" be aggressive/paranoid and save often automatically.
set autowriteall
set	autoread


"interactive spell check
" works only in non-gui mode for now
""map #sp :w<CR>:!ispell %<CR>:e %<CR> 
au FileType text,mkd setlocal spell spelllang=en_us




"http://plasticboy.com/markdown-vim-mode/
"Markdown format options
augroup mkd
	autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
augroup END

" I like to put system library tags in a different tag file that
" is only generated once in a while.
au FileType python set tags += "~/.tags/tags-python"
au FileType c set tags += "~/.tags/tags-c

" Remove menu bar from gvim
set guioptions-=m

" Remove toolbar from gvim
set guioptions-=T
" Set gvim font. I like the droid
set guifont=Inconsolata\ Medium\ 14

"     dictionary: english words first
" add any text based dictionaries to the list.
" Also, you can use C-X,C-K to autocomplete a word
" using the dictionary.
set dictionary=/usr/share/dict/words,/usr/dict/words,/usr/dict/extra.words

" End More normal Vim tweaks.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins and external addons

""" Bufexplorer
" Use Ctrl-l to cut to the buf browser from bufexplorer plugin
" Think l as in 'list the buffers'
"let g:bufExplorerFindActive = 0
"nmap <C-l> <ESC>\bv
"imap <C-l> <ESC>\bv
nmap <silent> <c-l> <esc>:BufExplorer<CR>
imap <silent> <c-l> <esc>:BufExplorer<CR>

""" comments.vim
"A more elaborate comment set up. Use Ctr-C to comment and Ctr-x to uncomment
" This will detect file types and use oneline comments accordingle. Cool
" because you visually select regions and comment/uncomment the whole region.
" works with marked regions to.
" Just put it in your plugin directory.

""" TagList
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
let Tlist_Auto_Highlight_Tag = 1

"Tlist_WinWidth~
"The default width of the vertically split taglist window is 30. This can be
"changed by modifying the 'Tlist_WinWidth' variable:
let Tlist_WinWidth = 60

" Close Tlist when jumping to tag
let Tlist_Close_On_Select = 1
"Tlist_Display_Prototype~
"By default, only the tag name will be displayed in the taglist window. If you
"like to see tag prototypes instead of names, set the 'Tlist_Display_Prototype'
"variable to 1. By default, this variable is set to zero and only tag names
"will be displayed.
let Tlist_Display_Prototype = 1
""" End TagList

""" Snipmate 
" Don't trigger snipmate when using completion
let g:SnipeMateAllowOmniTab = 1

""" NERDTree
" Use Ctrl-d to open/close the NERDTree.
nmap <C-d> <ESC>:NERDTreeToggle<CR>
imap <C-d> <ESC>:NERDTreeToggle<CR>
let NERDChristmasTree=1
let NERDTreeQuitOnOpen=1

""" JSLint.vim plugin

" Turn off error highlighting. I like having just the
" quickfix window.
let g:JSLintHighlightErrorLine = 0
let g:JSLintIgnoreImpliedGlobals = 1
au FileType javascript nmap <F5> <ESC>:JSLint<CR>
au FileType javascript imap <F5> <ESC>:JSLint<CR>

au FileType python nmap <F5> <ESC>:w<CR>:!python %<CR>
au FileType python imap <F5> <ESC>:w<CR>:!python %<CR>
au FileType python nmap <F1> <ESC>:w<CR>:PyFlakes<CR>
au FileType python imap <F1> <ESC>:w<CR>:PyFlakes<CR>

" php synax check via 'php -l'
au FileType php nmap <F5> <ESC>:w<CR>:PHPLint<CR>
au FileType php imap <F5> <ESC>:w<CR>:PHPLint<CR>

" use tidy
au FileType html nmap <F5> <ESC>:w<CR>:HTMLTidyLint<CR>
au FileType html imap <F5> <ESC>:w<CR>:HTMLTidyLint<CR>


au FileType sh,bash nmap <F5> <ESC>:w<CR>:!sh ./%<CR>
au FileType sh,bash imap <F5> <ESC>:w<CR>:!sh ./%<CR>

"Enable autotag.vim
source ~/.vim/plugin/autotag.vim

" load the tag closer
au Filetype html let b:closetag_html_style=1
au Filetype html,xml,xsl,htmlcheetah source ~/.vim/scripts/closetag.vim

" Set NiceMenu Delay
let g:NiceMenuDelay = '.7' 
let g:acp_mappingDriven = 1

 "End Plugins and external addons
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Misc People and places that I've gotten stuff from
"http://dancingpenguinsoflight".com"/2009/02/code-navigation-completion-snippets-in-vim/
"http://www.thegeekstuff.com/2009/01/vi-and-vim-editor-5-awesome-examples-for-automatic-word-completion-using-ctrl-x-magic/


" #Viming With Buttars
"
" ## Maintainer: Jeff Buttars  
" <jeffbuttars@gmail.com>  
" [Git Hub Repo](http://github.com/jeffbuttars/viming-with-buttars)
"
" To use this .vimrc copy it to :  
"
" * On Linux, OS X, Unix and OS/2:  ~/.vimrc  
" *	On Amiga:  s:.vimrc  
" * On MS-DOS and Win32:  $VIM\_vimrc  
" * On OpenVMS:  sys$login:.vimrc  
"
" ## Original Maintainer:	Bram Moolenaar <Bram@vim.org>  
" Bram wrote/writes Vim, send money to his charity for Uganda. 
" Find more info at [Vim.org](http://www.vim.org)  
"
" __If your reading this as a README on GitHub you should know that this 
" README is generted from the .vimrc file of this project using [Vimdown](https://github.com/jeffbuttars/Vimdown)__  
"
" After each code block I will try to put some links to the appropriate vimdoc
" pages for the Vim features used in the section. This is a large .vimrc file
" and I have yet to tame it. So it's not in a great order, a work in progress.
" 
" ## .vimrc sections:
" * [Bundles](#bundles)
" * [Maps](#maps)
"
" Load our bundles early
runtime vimrc/bundles.vim

"
" ### Vim Options
"
" When started as "evim", evim.vim will already have done these settings, so
" we'll bail out in that scenario
if v:progname =~? "evim"
  finish
endif
" * [evim][]
" * [finish][]
"
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible " Don't be compatible with basic Vi

set backspace=indent,eol,start " allow backspacing over everything in insert mode

set history=1000 " keep 1000 lines of command line history
"
" * [nocompatible][]
" * [backspace][]
" * [nobackup][]
" * [history][]
"
" Set our encoding to UTF-8
set encoding=utf-8

" ### Ruler and Statusline
" 
" I don't use the following ruler and statusline examples, I have a more advanced version
" of setting the status line in my
" [hacks.vim](https://github.com/jeffbuttars/Viming-With-Buttars/blob/master/hacks.vim)  
"  
" Examples of using set ruler and set statusline
"
  " set ruler    " show the cursor position all the time
  " Set up a custom status line. Like setting ruler, statusline overrides ruler, but we add the buffer number and filetype to the status:
  " set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %P
  " Set up a custom status line. Like setting ruler, statusline overrides ruler, but we add the buffer number and filetype to the status:
  " set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %P
  " or
  " set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %{&textwidth}\ %P
"
" * [ruler][]
" * [statusline][]
"
" Set up some buffer and window behaviors
filetype on
set switchbuf=useopen
set laststatus=2          " last window will always have a status line
set showcmd		         " display incomplete commands
set lazyredraw      " Don't redraw screen when executing macros
"
" * [switchbuf][]
" * [laststatus][]
" * [showcmd][]
"  
"
" If we're running Vim 7.3 or newer, enable persistent undo
" and tell vim were to store the undo files. 
if version >= 703
	set undofile
	set undodir=~/.vim/undos
endif
"
" * [undofile][]
" * [undodir][]
"  
"
" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif
"
" * [mouse][]
"

" Switch on highlighting of the last used search pattern.
if &t_Co > 2
	set hlsearch
endif

"  
" * [hlsearch][]
" * [guioptions][]
"
"
" __I don't use the following, but some like it so I included for FYI purposes:__  
"
" This line will make Vim set out tab characters, trailing whitespace and
" invisible spaces visually, and additionally use the # sign at the end of lines
" to mark lines that extend off-screen. For more info, see :h listchars  
   " set list  
   " set listchars=tab:\|.,trail:.,extends:#,nbsp:.
" 
" * [listchars][]
"
" 
" We take for granted that we are connected to a fast terminal most of the time
set ttyfast
set laststatus=2 " keep the status line showing
set incsearch    " Enable incremental searching
" * [ttyfast][]
" * [laststatus][]
" * [incsearch][]
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" <a name="autocommands" /> 
" 
" ## Autocommands
"
" * See  [autocommands][]
"
" We check if autocommands are enabled before we use them. 
if has("autocmd")

   "In some files, like HTML and XML files, tabs are fine and showing them is
   "really annoying, you can disable them easily using the autocmd declaration:
   " autocmd filetype html,xml set listchars-=tab:>.

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin on
  filetype indent on


  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text,txt setlocal textwidth=78

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
"
" *[autoindent][]

set fileformats=unix,dos,mac " try recognizing line endings in this order

" allow vim commands to copy to system clipboard (*)
" for X11:
"   + is the clipboard register (Ctrl-{c,v})
"   * is the selection register (middle click, Shift-Insert)
set clipboard=unnamed,autoselect

" use clipboard register when supported (X11 only)
if has("unnamedplus")
    set clipboard+=unnamedplus
endif


" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
  " if !exists(":DiffOrig")
  "    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  "    \ | wincmd p | diffthis
  " endif

" I like to have my files automatically reloaded if they change on disk
set autoread
"
" * [autoread][]
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" More normal Vim tweaks.
" vertical: make a diff split vertical by default
" iwhite: ignore whitespace
" context: show 15 lines of context
set diffopt=filler,vertical,context:15
let g:html_diff_one_file = 1

" Use real tabs, 4 spaces
" I prefer to use realtabs, but, I'm overruled by spaces.
" Use this if you want real tabs.
"<pre>
" set tabstop=4
" set shiftwidth=4
" set shiftround	" use multiple of shiftwidth when indenting with '<' and '>'
" set smarttab
"</pre>

" A gave in and use spaces instead of real tabs
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=80 " Too narrow for my tastes, but satisfies most standards.
set smarttab
set shiftround	" use multiple of shiftwidth when indenting with '<' and '>'
set expandtab

" Show matching braces
set showmatch 
" Quick blink when a match is made
set mat=5

" Keep our swap and backup files out of the way 
" and in a central palce.
" let swapbdir = shellescape($HOME."/.vim/swapback")
" if ! isdirectory(swapbdir)
"     execute "silent! !mkdir -p ".swapbdir
" endif
" set directory=~/.vim/swapback
" set backupdir=~/.vim/swapback
" OR, screw the swap file
" set noswapfile
" set nobackup " do not keep a backup file, use versions instead


" C opts
" Kernel style
"set cinoptions=:0,(0,u0,W1s
" I use  the default, you should
" check out the help for cinoptions and
" tune it to  match your prefered style.
" :h cinoptions
set cinoptions+=J

" Keep this many lines above/below the cursor while scrolling.
set scrolloff=3

" The title of the window to titlestring
" see :h title for better info.
set title

" set foldmethod=indent
" set foldmethod=syntax
" set foldmethod=marker
set foldmethod=manual
set nofoldenable
set foldcolumn=1


" When vimrc is edited, automatically reload it!
autocmd! bufwritepost .vimrc source ~/.vimrc

" Big nasty viminfo setup. If you you have a smaller/slower system use the
" commented viminfo below, it's tuned down.
" track up to 20,000 files.
" store global marks.
" no more than 500 lines per register are saved
" 1000 lines of history
" save the buffer list
set viminfo='20000,f1,<500,:1000,@1000,/1000,%

" HTML output options
" Use more modern css
let html_use_css = 1

" wrap long lines
set wrap
set sidescroll=3

" Some wordwrapp foo from
" [kmandla](http://kmandla.wordpress.com/2009/07/27/proper-word-wrapping-in-vim/)
set formatoptions+=l
set lbr

set selection=inclusive
set shortmess=atI
set wildmenu
set wildmode=list:longest
set wildignore=*.swp,*.bak,*.pyc,*.pyo,*.class,*.6,.git,.hg,.svn,*.o,*.a,*.so,*.obj,*.lib

" If a letters are lower case in a pattern, ignore case.
" Otherwise be case sensitive.
set ignorecase
set smartcase

" set key timeout, good for remaps
set timeoutlen=300


" autowrite: "on" saves a lot of trouble
" set autowrite
" be aggressive/paranoid and save often automatically.
set autowriteall
set	autoread
set mousemodel=popup " Make right mouse button work in gvim
set hidden " Don't acutally close buffers, just hide them.

" dictionary: english words first
" add any text based dictionaries to the list.
" Also, you can use C-X,C-K to autocomplete a word
" using the dictionary. Or, use C-X,C-S to check spelling
" on a word, fun stuff.
set dictionary+=/usr/share/dict/words,/usr/dict/words,/usr/dict/extra.words

" [Improved_Hex_editing](http://vim.wikia.com/wiki/Improved_Hex_editing)
" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()

" I don't want variables and options saved in my views
" so remove the 'options' option from the default viewoptions setting.
" set viewoptions-=options
set viewoptions=cursor
set sessionoptions=winpos,localoptions

runtime! vimrc/*.vim

" [evim]: http://vimdoc.sourceforge.net/htmldoc/starting.html#evim
" [nocompatible]: http://vimdoc.sourceforge.net/htmldoc/options.html#'nocompatible'
" [backspace]: http://vimdoc.sourceforge.net/htmldoc/options.html#'backspace'
" [nobackup]: http://vimdoc.sourceforge.net/htmldoc/options.html#'nobackup'
" [history]: http://vimdoc.sourceforge.net/htmldoc/options.html#'history'
" [ruler]: http://vimdoc.sourceforge.net/htmldoc/options.html#'ruler'
" [statusline]: http://vimdoc.sourceforge.net/htmldoc/options.html#'statusline'
" [guioptions]: http://vimdoc.sourceforge.net/htmldoc/options.html#'guioptions'
" [switchbuf]: http://vimdoc.sourceforge.net/htmldoc/options.html#'switchbuf'
" [laststatus]: http://vimdoc.sourceforge.net/htmldoc/options.html#'laststatus'
" [showcmd]: http://vimdoc.sourceforge.net/htmldoc/options.html#'showcmd'
" [undofile]: http://vimdoc.sourceforge.net/htmldoc/options.html#'undofile'
" [undodir]: http://vimdoc.sourceforge.net/htmldoc/options.html#'undodir'
" [mouse]: http://vimdoc.sourceforge.net/htmldoc/options.html#'mouse'
" [syntax]: http://vimdoc.sourceforge.net/htmldoc/options.html#'syntax'
" [hlsearch]: http://vimdoc.sourceforge.net/htmldoc/options.html#'hlsearch'
" [listchars]: http://vimdoc.sourceforge.net/htmldoc/options.html#'listchars'
" [ttyfast]: http://vimdoc.sourceforge.net/htmldoc/options.html#'ttyfast'
" [incsearch]: http://vimdoc.sourceforge.net/htmldoc/options.html#'incsearch'
" [autoindent]: http://vimdoc.sourceforge.net/htmldoc/options.html#'autoindent'
" [autoread]: http://vimdoc.sourceforge.net/htmldoc/options.html#'autoread'
" [completeopt]: http://vimdoc.sourceforge.net/htmldoc/options.html#'completeopt'
" [complete]: http://vimdoc.sourceforge.net/htmldoc/options.html#'complete'
" [number]: http://vimdoc.sourceforge.net/htmldoc/options.html#'number'
" [relativenumber]: http://vimdoc.sourceforge.net/htmldoc/options.html#'relativenumber'
" 
" [pumvisible]: http://vimdoc.sourceforge.net/htmldoc/eval.html#pumvisible()
"
" [map]: http://vimdoc.sourceforge.net/htmldoc/map.html#:map
" [inoremap]: http://vimdoc.sourceforge.net/htmldoc/map.html#:inoremap
" [imap]: http://vimdoc.sourceforge.net/htmldoc/map.html#:imap
" [nmap]: http://vimdoc.sourceforge.net/htmldoc/map.html#:nmap
"
" [autocommands]: http://vimdoc.sourceforge.net/htmldoc/autocmd.html#autocommand
"
" [runtime]: http://vimdoc.sourceforge.net/htmldoc/repeat.html#:runtime
" [finish]: http://vimdoc.sourceforge.net/htmldoc/repeat.html#:finish

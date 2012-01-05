"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer: Jeff Buttars 
" jeffbuttars@gmail.com
" http://code.google.com/p/vimingwithbuttar/ 
" Last change:	2010 Feb 08
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" Original Maintainer:	Bram Moolenaar <Bram@vim.org>
" Bram wrote/writes Vim, send money to his charity for Uganda. 
" Find more info at http://www.vim.org

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
  "set nobackup		" do not keep a backup file, use versions instead
"else
  "set backup		" keep a backup file
"endif
set nobackup		" do not keep a backup file, use versions instead

set history=1000		" keep 1000 lines of command line history
"set ruler		" show the cursor position all the time
" Set up a custom status line. Like setting ruler, but we add the buffer number and filetype to the status
"set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" set statusline=%<%y\ b%n\ %h%m%r%=%-14.(%l,%c%V%)\ %{&textwidth}\ %P

set switchbuf=useopen

" last window will always have a status line
set laststatus=2

set showcmd		" display incomplete commands

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

if version >= 730
	set undofile
	set undodir=~/.vim/undos
endif

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

set incsearch		" do incremental searching

"This line will make Vim set out tab characters, trailing whitespace and
"invisible spaces visually, and additionally use the # sign at the end of lines
"to mark lines that extend off-screen. For more info, see :h listchars
"set list
"set listchars=tab:\|.,trail:.,extends:#,nbsp:.

"In some files, like HTML and XML files, tabs are fine and showing them is
"really annoying, you can disable them easily using an autocmd declaration:
"autocmd filetype html,xml set listchars-=tab:>.

set ttyfast
set laststatus=2

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
  "autocmd FileType text,txt,mkd setlocal textwidth=78
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

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
"if !exists(":DiffOrig")
  "command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  "\ | wincmd p | diffthis
"endif


set autoread

" Allow us to save a file as root, if we have sudo privileges,
" when we're not currently useing vim as root
cmap w!! %!sudo tee > /dev/null %

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniCompletion settings
" When c-y is used to select, enter normal mode.
imap <c-y> <c-y><esc>
" Show the info preview window.
"set completeopt=menuone,preview
" set completeopt=menu,preview
set completeopt=menuone,preview,longest
"let g:SuperTabLongestHighlight = 0
" g:SuperTabMappingForward  ('<tab>')
" g:SuperTabMappingBackward ('<s-tab>')
"let g:SuperTabDefaultCompletionType = '<c-n>'
" let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
" let g:SuperTabDefaultCompletionType = 'context'
" let g:SuperTabCompletionContexts = ['s:ContextDiscover']
" let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', 'myown']
" let g:SuperTabContextDiscoverDiscovery = ["&omnifunc:<c-x><c-o>", "myown:<c-x><c-f>"]
" let g:SuperTabContextDefaultCompletionType = '<c-n>'

"(default: ".,w,b,u,t,i")
"set complete=".,w,b,u,U,t,i,kspell,d,t"
"set complete=".,w,b,u,t,i,kspell"
" Map omnicomplete to Control-o
imap <C-O> <C-X><C-O> 

" imap <C-space> <C-X><C-O>

" Mapping for the a.vim plugin
" quickly switch between source
" and header files with <C-H>
imap <silent> <C-S> <ESC>:A<CR>
nmap <silent> <C-S> <ESC>:A<CR>

" When the completion window is open, shift will cycle
" forward through the menu.
" This does not work with snipmate, so I have a hack
" in after/plugin/snipmate
" function! CleverTab()
" 	if !pumvisible() 
" 		return "\<Tab>"
" 	endif
" 
" 	return "\<C-N>"
" endfunction
" inoremap <Tab> <C-R>=CleverTab()<CR>
"

" Enter will do a simple accept of the selection
"Moved this into delimitMate to get them
"to work together
 "THIS INTERFERES WITH NICE MENU
function! CleverCR()
	if !pumvisible() 
		return "\<CR>"
	endif

	return "\<C-Y>"
endfunction
inoremap <CR> <C-R>=CleverCR()<CR>

function! ToggleRNU()
	if 0 == &rnu
		set rnu
	else
		set number 
	endif
endfunction
nmap <silent> <F3> <ESC>:call ToggleRNU()<CR>


"For example, to save a file, you type :w normally, which means:

"    Press and hold Shift
"    Press ;
"    Release the Shift key
"    Press w
"    Press Return
" This trick strips off steps 1 and 3 for each Vim command. It takes some times
" for your muscle memory to get used to this new ;w command, but once you use
" it, you don’t want to go back!
nnoremap ; :

"If you like long lines with line wrapping enabled, this solves the problem
"that pressing down jumpes your cursor “over” the current line to the next
"line. It changes behaviour so that it jumps to the next row in the editor
"(much more natural):
nnoremap j gj
nnoremap k gk

" Easier window navigation when you split up your buffers.
" Use J instead of CTRL-W j, etc.
nnoremap <C-j> <c-w>j
nnoremap <C-h> <c-w>h
nnoremap <C-k> <c-w>k
nnoremap <C-l> <c-w>l

" Auto close the preview window
"autocmd CursorHold * if pumvisible() == 0|pclose|endif
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif

""" Snipmate 
" Don't trigger snipmate when using completion
" This option currently requires the buttars hacked version
" of snipMate :( available from vimingwithbuttar at google code.
let g:SnipeMateAllowOmniTab = 1

" We're extra friendly for django 
autocmd FileType python set ft=python.django 		" For SnipMate
autocmd BufRead *.djml set ft=html.htmldjango 	" For SnipMate

autocmd FileType mkd set ft=mkd.html 	" For SnipMate, I want to use HTML
										" snippets with my markdown
autocmd BufRead *.go set ft=go 	" For SnipMate

" Setup pysmell
" source ~/.vim/plugin/pysmell.vim
" let g:pysmell_debug = 1
" autocmd FileType python set omnifunc=pysmell#Complete

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
" vertical: make a diff split vertical by default
" iwhite: ignore whitespace
" context: show 10 lines of context
"set diffopt=filler,vertical,iwhite,context:10
set diffopt=filler,vertical,context:15
let g:html_diff_one_file = 1

"Use real tabs, 4 spaces
set tabstop=4
set shiftwidth=4
set shiftround	" use multiple of shiftwidth when indenting with '<' and '>'
set smarttab

" Show matching braces
set showmatch 
" Quick blink when a match is made
set mat=5

" Keep our swap and backup files out of the way 
" and in a central palce.
"set directory=~/.vim/swapback
"set backupdir=~/.vim/swapback
" Screw the swap file
set noswapfile

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

"set foldmethod=indent
"set foldmethod=syntax
set foldmethod=manual

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

"http://concisionandconcinnity.blogspot.com/2009/07/vim-part-ii-matching-pairs.html
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
"set viminfo='1000,f1,<500,:100,@100,/100,%

" HTML output options
" Use more modern css
let html_use_css = 1

" wrap long lines
set wrap
set sidescroll=3

" Some wordwrapp foo from
" http://kmandla.wordpress.com/2009/07/27/proper-word-wrapping-in-vim/
set formatoptions+=l
set lbr

set selection=inclusive
set shortmess=atI
set wildmenu
set wildmode=list:longest
set wildignore=*.swp,*.bak,*.pyc,*.pyo,*.class,*.6

" set key timeout, good for remaps
set timeoutlen=300

" I hate it when the cursorline is an underline
" This is how I make the cursorline a hightlight
"set cursorline
"hi clear CursorLine 

" CursorLine really slows down php files
" There is something wrong with the PHP syntax
" plugin, as a work around we disable cursorline
" for PHP files. :(
au FileType php set nocursorline 


" color schemes I have liked.
"colo elflord " a low color dark theme. Great for the real console.
"colo evening " dark theme, low color console friendly
"colo xoria256 " a nice dark theme for 256 color terms
"colo wombat256 " the classic wombat theme for 256 color terms
"colo pyte " A white theme
"colo mySlate 
"colo peaksea " A light theme
"colo molokai " A dark pastelly theme, a little bisexual but very pleasing.
"colo neutron " A very nice creamy light theme.

" Explicitly say we want 256 colors when we find 256
" in the TERM environmental variable.
" When this is set it can mess up using vim on a real console.
"  Definitely in Fedora >= 11. So we try to be smart about
" it and only set it if we think it's wanted.
"
" We default to a theme that works everywere.
" Then we see if we can upgrade to a better theme
" based on the environment.
colo evening 
" evening is a nice dark theme, usually available by a default install.

if has( "gui_running" )
	" I like a white based them in GVim
	set cursorline
	hi clear CursorLine 
	"colo vylight 
	"colo wombat256 
	let g:lucius_style = "light"
	colo lucius 
elseif $TERM =~ '256' || $COLORTERM =~ 'gnome-terminal'
	" Use a console friendly theme and turn off cursorline
	" I  prefer a dark theme at the console..
	set t_Co=256
	set cursorline
	hi clear CursorLine 
	"colo jellybeans 
	
	if $TERM_META =~ 'white'
		"colo github 
		let g:lucius_style = "light"
		colo lucius 
	else
		"colo molokai 
		"colo wombat256 
		"colo jellybeans 
		"colo 256-grayvim
		"colo mywombat256 
		let g:lucius_style = "dark"
		colo lucius 
	endif
endif

" set linenumbers on by default
set number 

" drupal rules
" If you edit a lot of php-drupal you should
" use these next few lines. If not, comment them
" out and I doubt you'll miss them.
augroup drupal_module
	autocmd BufRead *.module,*.inc set filetype=php
augroup END

" autowrite: "on" saves a lot of trouble
" set autowrite
" be aggressive/paranoid and save often automatically.
set autowriteall
set	autoread

"interactive spell check
" works only in non-gui mode for now
map #sp :w<CR>:!ispell %<CR>:e %<CR> 

" Use the next line to selectively enable spell
" checking for certain filetypes.
" I usually don't want spell checking when 
" writting code, so only enable for thing with
" a lot of real words like text and markdown files.
au FileType text,markdown,rst setlocal spell spelllang=en_us
au FileType text,markdown,rst let b:NiceMenuContextRegex='[a-zA-Z0-9]' 

"set spell spelllang=en_us

" Make right mouse button work in gvim
set mousemodel=popup

" Allow toggling of paste/nopaste via F2
set pastetoggle=<F2>

" Don't acutally close buffers, just hide them.
set hidden

" dictionary: english words first
" add any text based dictionaries to the list.
" Also, you can use C-X,C-K to autocomplete a word
" using the dictionary. Or, use C-X,C-S to check spelling
" on a word, fun stuff.
set dictionary+=/usr/share/dict/words,/usr/dict/words,/usr/dict/extra.words

" http://vim.wikia.com/wiki/Improved_Hex_editing
" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" A more verbose pastetoggle
function! TogglePaste()
	if	&paste == 0
		set paste
		echo "Paste is ON!"
	else
		set nopaste
		echo "Paste is OFF!"
	endif
endfunction
" Allow toggling of paste/nopaste via F2
"set pastetoggle=<F2>
nmap <F2> <ESC>:call TogglePaste()<CR>
imap <F2> <ESC>:call TogglePaste()<CR>i

"http://plasticboy.com/markdown-vim-mode/
"Markdown format options, which I don't use 
" but I'll include them here for your experimentation
"augroup mkd
	"autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
"augroup END

" I like to put system library tags in a different tag file that
" is only generated once in a while.
set tags=tags;/
au FileType python set tags +=~/.tags/tags-python
au FileType c set tags +=~/.tags/tags-c
au FileType cpp set tags +=~/.tags/tags-cpp

" Remove menu bar from gvim
"set guioptions-=m
" Remove toolbar from gvim
set guioptions-=T
" Set gvim font. I like the Inconsolata font these days.
" You'll need to install, do it, it's very much worth it.
" A great font, and it's 100% free.
set guifont=Inconsolata\ Medium\ 12
"set guifont=Anonymous\ Pro\ 12

" I don't want variables and options saved in my views
" so remove the 'options' option from the default viewoptions setting.
" set viewoptions-=options
set viewoptions=cursor
set sessionoptions=winpos,localoptions

" End More normal Vim tweaks.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins and external addons

" LustyExplorer
nmap <silent> <c-l> <esc>:LustyBufferExplorer<CR>
imap <silent> <c-l> <esc>:LustyBufferExplorer<CR>

""" comments.vim
"A more elaborate comment set up. Use Ctr-C to comment and Ctr-x to uncomment
" This will detect file types and use oneline comments accordingle. Cool
" because you visually select regions and comment/uncomment the whole region.
" works with marked regions to.
" Just put it in your plugin directory.



""" TagList """"""""
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

let Tlist_Use_Right_Window     = 0
let Tlist_Exit_OnlyWindow      = 1
let Tlist_Enable_Fold_Column   = 0
let Tlist_Compact_Format       = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Auto_Highlight_Tag   = 1

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

""" netrw
" Tree Style listing
let g:netrw_liststyle = 3

" Lusty Explorer
nmap <C-d> <ESC>:LustyFilesystemExplorerFromHere<CR>
imap <C-d> <ESC>:LustyFilesystemExplorerFromHere<CR>



""" JSLint.vim plugin -- indespensable!
" Turn off error highlighting. I like having just the
" quickfix window.
let g:JSLintHighlightErrorLine = 0
let g:JSLintIgnoreImpliedGlobals = 1
au FileType javascript nmap <F5> <ESC>:JSLint<CR>
au FileType javascript imap <F5> <ESC>:JSLint<CR>

" run the current buffer as a python script 
" or run it through PyFlakes command.
au FileType python nmap <F1> <ESC>:w<CR>:!python %<CR>
au FileType python imap <F1> <ESC>:w<CR>:!python %<CR>
au FileType python nmap <F5> <ESC>:w<CR>:PyFlakes<CR>
au FileType python imap <F5> <ESC>:w<CR>:PyFlakes<CR>

let python_highlight_space_errors = 0

" php synax check via 'php -l'
" uses my plugin/phplint.vim
"au FileType php nmap <F5> <ESC>:w<CR>:PHPLint<CR>
"au FileType php imap <F5> <ESC>:w<CR>:PHPLint<CR>

" use tidy
" I don't use this much, so may be buggy
au FileType html nmap <F5> <ESC>:w<CR>:HTMLTidyLint<CR>
au FileType html imap <F5> <ESC>:w<CR>:HTMLTidyLint<CR>


" My own custom plugin/bashrun.vim
" Very simple, BashRun runs the buffer as a bash
" script and outputs errors into a quick fix windowl
au FileType sh,bash nmap <F1> <ESC>:w<CR>:!sh %<CR>
au FileType sh,bash imap <F1> <ESC>:w<CR>:!sh %<CR>
au FileType sh,bash nmap <F5> <ESC>:w<CR>:BashRun<CR>
au FileType sh,bash imap <F5> <ESC>:w<CR>:BashRun<CR>
"au FileType sh,bash setlocal errorformat=%f\ line\ %l:\ %m


au FileType go setlocal errorformat=%f:%l:\ %m

" json_reformat is at:
" URL: http://lloyd.github.com/yajl/
autocmd FileType json set equalprg=json_reformat
autocmd FileType xml  set equalprg=xmllint\ --format\ -

"Enable autotag.vim
"source ~/.vim/plugin/autotag.vim

" load the tag closer
"au FileType html,xhtml let b:closetag_html_style=1
"au FileType html,xml,xhtml,xsl,htmlcheetah source ~/.vim/scripts/closetag.vim

" doubleTap
"let g:loaded_doubleTap = 1
let g:DoubleTapInsertTimer = 0.8

" Set NiceMenu Delay
let g:loaded_nice_menu = 1
let g:NiceMenuDelay = '.6'
let g:NiceMenuMin = 1

" Syntax checking entire file
" Usage: :make (check file)
" :clist (view list of errors)
" :cn, :cp (move around list of errors)
"autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\
"sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
"autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\
"%l%.%#,%Z%[%^\ ]%\\@=%m

let g:maxLineLength=100

" BellyButton settings
let g:BellyButton_javascript_jslint_options = {'white':'false', 'vars':'true','bitwise':'false',
			\'predef':"['Backbone', '_', 'console','window', 'Ext', 'jQuery', '$', 'cp', 'alert', 'confirm', 'document']"}


" Sparkup options
" I don't like default mapping, I actually use
" the <c-e> default for navigation
let g:sparkupExecuteMapping = '<c-s>'
let g:sparkupNextMapping = '<c-h>'

let g:snips_author = 'Jeff Buttars'

 "End Plugins and external addons
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Misc People and places that I've gotten stuff from
"http://dancingpenguinsoflight".com"/2009/02/code-navigation-completion-snippets-in-vim/
"http://www.thegeekstuff.com/2009/01/vi-and-vim-editor-5-awesome-examples-for-automatic-word-completion-using-ctrl-x-magic/

" IBM Vim series, quite good.
" Scripting the Vim editor, Part 1: Variables, values, and expressions
" http://www.ibm.com/developerworks/linux/library/l-vim-script-1/index.html

" Scripting the Vim editor, Part 2: User-defined functions
" http://www.ibm.com/developerworks/linux/library/l-vim-script-2/index.html

" Scripting the Vim editor, Part 3: Built-in lists
" http://www.ibm.com/developerworks/linux/library/l-vim-script-3/index.html

" Scripting the Vim editor, Part 4: Dictionaries
" http://www.ibm.com/developerworks/linux/library/l-vim-script-4/index.html

" Scripting the Vim editor, Part 5: Event-driven scripting and automation
" http://www.ibm.com/developerworks/linux/library/l-vim-script-5/index.html

" Some good python settings suggestions:
" http://www.cmdln.org/2008/10/18/vim-customization-for-python/
"
" Good information on line wrapping:
" http://blog.ezyang.com/2010/03/vim-textwidth/

"au FileType php set nocursorline 
"au WinEnter * setlocal number
"au WinLeave * setlocal nonumber

runtime hacks.vim 

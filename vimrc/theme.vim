" Enable syntax highlighting
syntax enable 
"
" * [syntax][]
"

" color schemes I have liked.
" * colo elflord " a low color dark theme. Great for the real console.
" * colo evening " dark theme, low color console friendly
" * colo xoria256 " a nice dark theme for 256 color terms
" * colo wombat256 " the classic wombat theme for 256 color terms
" * colo pyte " A white theme
" * colo mySlate 
" * colo peaksea " A light theme
" * colo molokai " A dark pastelly theme, a little bisexual but very pleasing.
" * colo neutron " A very nice creamy light theme.
" * colo vylight  " A light theme
" * colo jellybeans " A dark color full theme

" Explicitly say we want 256 colors when we find 256
" in the TERM environmental variable.
" When this is set it can mess up using vim on a real console.
"  Definitely in Fedora >= 11. So we try to be smart about
" it and only set it if we think it's wanted.  
"
" We default to a theme that works everywere.
" Then we see if we can upgrade to a better theme
" based on the environment.
colo evening " evening is a nice dark theme, usually available with a default install.

if has( "gui_running" )
	" I like a white based theme in GVim
	set cursorline
	hi clear CursorLine 

	let g:lucius_style = "light"
	set background=light

	colo lucius 
	"set guioptions-=m " Will remove menu bar from gvim
	set guioptions-=T " Remove toolbar from gvim

	" Set gvim font. I like the Inconsolata font.
	" You'll need to install, do it, it's very much worth it.
	" A great font, and it's 100% free.
	set guifont=Inconsolata\ Medium\ 10
    "
    " For Win32 GUI: you can remove 't' flag from 'guioptions' for no tearoff menu entries  
        " let &[guioptions = substitute(&guioptions, "t", "", "g")
    " 
    " * [guioptions][]
    "
elseif $TERM =~ '256' || $COLORTERM =~ 'gnome-terminal'
	" Use a console friendly theme and force Vim to
	" use 256 colors if we think the console can handle it.
	set t_Co=256
	set cursorline
	hi clear CursorLine 

    set background=dark
    let g:lucius_style = "dark"
    let w:solarized_style = g:lucius_style

    if $TERM_META =~ 'white'
        set background=light
        let g:lucius_style = "light"
    endif

    colorscheme lucius

endif

" set linenumbers on by default
set number 

" A cleaner vertical split
 set fillchars=vert:\:


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ## Bundles
"
" We deal with our bundles first thing because later sections
" rely on them being available.
"
" #### [Pathogen](https://github.com/tpope/vim-pathogen)
" [Pathogen](https://github.com/tpope/vim-pathogen) is a
" nice package format for Vim _'packages'_.  
" [Vundle](https://github.com/gmarik/vundle) is a great package manager
" for Pathogen bundles.
" [NeoBundle](https://github.com/Shougo/neobundle.vim) A nice bundle manager.
"
"
" # NeoBundle config

" More or less 'borrowed' straight from the repo readme.

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
" NeoBundle 'Shougo/vimproc'

NeoBundle 'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }

" Place your bundles here!

NeoBundle 'https://github.com/Shougo/unite.vim'

NeoBundle 'https://github.com/tpope/vim-fugitive.git'
" NeoBundle 'https://github.com/kien/ctrlp.vim'
NeoBundle 'https://github.com/ctrlpvim/ctrlp.vim'
NeoBundle 'https://github.com/nvie/vim-flake8'
NeoBundle 'https://github.com/bling/vim-airline.git'
" NeoBundle 'https://github.com/itchyny/lightline.vim'
NeoBundle 'https://github.com/bling/vim-bufferline.git'
" NeoBundle 'https://github.com/kien/rainbow_parentheses.vim'
NeoBundle 'https://github.com/junegunn/rainbow_parentheses.vim'
NeoBundle 'https://github.com/scrooloose/nerdcommenter.git'
NeoBundle 'git://github.com/lrvick/Conque-Shell.git'
NeoBundle 'https://github.com/tpope/vim-eunuch.git'
NeoBundle 'https://github.com/plasticboy/vim-markdown.git'
NeoBundle 'https://github.com/airblade/vim-gitgutter.git'
NeoBundle 'git://github.com/junegunn/vim-easy-align.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'
NeoBundle 'https://github.com/vim-ruby/vim-ruby'
NeoBundle 'https://github.com/vim-scripts/ldif.vim.git'
NeoBundle 'https://github.com/tpope/vim-dispatch.git'
" NeoBundle 'https://bitbucket.org/agr/ropevim'
" NeoBundle 'vcscommand.vim'
" NeoBundle 'ZenCoding.vim'
NeoBundle 'Gundo'
" NeoBundle 'https://github.com/scrooloose/nerdtree'
NeoBundle 'https://github.com/Shougo/vimfiler.vim'
NeoBundle 'DirDiff.vim'
NeoBundle 'vim-indent-object'
NeoBundle 'nginx.vim'
NeoBundle 'patchreview.vim'
" NeoBundle 'argtextobj.vim'
" NeoBundle 'textobj-indent'
" NeoBundle 'django-template-textobjects'
" NeoBundle 'https://github.com/davidhalter/jedi-vim.git'
NeoBundle 'https://github.com/Valloric/YouCompleteMe.git'
" Load Ultisnips last to make sure it has the <tab> map
NeoBundle 'https://github.com/sirver/ultisnips'
NeoBundle 'https://github.com/honza/vim-snippets'
NeoBundle 'https://github.com/vim-scripts/stata.vim'
NeoBundle 'https://github.com/jacquesbh/vim-showmarks.git'
NeoBundle 'https://github.com/zah/nimrod.vim'
NeoBundle 'chrisbra/vim-diff-enhanced'
NeoBundle 'https://github.com/mhinz/vim-rfc'
NeoBundle 'https://github.com/vim-scripts/rfc-syntax'
NeoBundle 'https://github.com/mustache/vim-mustache-handlebars'
NeoBundle 'ryanoasis/vim-webdevicons'
NeoBundle 'hsanson/vim-android'
NewBundle 'https://github.com/junegunn/vim-peekaboo'

" Tornado template syntax
NeoBundle 'https://github.com/vim-scripts/tornadotmpl.vim.git'

" Colorschemes
"
" Solarized has been good to me. I plan to keep it a while
NeoBundle 'Solarized'

 "
 " Brief help
 " :NeoBundleList          - list configured bundles
 " :NeoBundleInstall(!)    - install(update) bundles
 " :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

call neobundle#end()

filetype plugin indent on     " Required!

 " Installation check.
NeoBundleCheck


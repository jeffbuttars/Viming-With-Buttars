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

set nocompatible " Utilize the good Vim parts

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc'

" Place your bundles here!

NeoBundle 'https://github.com/kien/ctrlp.vim'
NeoBundle 'https://github.com/nvie/vim-flake8'
NeoBundle 'https://github.com/bling/vim-airline.git'
NeoBundle 'https://github.com/itchyny/lightline.vim'
NeoBundle 'https://github.com/bling/vim-bufferline.git'
NeoBundle 'https://github.com/kien/rainbow_parentheses.vim'
NeoBundle 'https://github.com/scrooloose/nerdcommenter.git'
NeoBundle 'git://github.com/lrvick/Conque-Shell.git'
NeoBundle 'https://github.com/tpope/vim-eunuch.git'
NeoBundle 'https://github.com/plasticboy/vim-markdown.git'
NeoBundle 'https://github.com/airblade/vim-gitgutter.git'
NeoBundle 'git://github.com/junegunn/vim-easy-align.git'
NeoBundle 'git://github.com/uggedal/go-vim.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'
NeoBundle 'https://github.com/vim-ruby/vim-ruby'
" NeoBundle 'https://bitbucket.org/agr/ropevim'
NeoBundle 'vcscommand.vim'
" NeoBundle 'ZenCoding.vim'
NeoBundle 'Gundo'
NeoBundle 'The-NERD-tree'
NeoBundle 'DirDiff.vim'
NeoBundle 'vim-indent-object'
NeoBundle 'nginx.vim'
NeoBundle 'patchreview.vim'
" NeoBundle 'argtextobj.vim'
" NeoBundle 'textobj-indent'
" NeoBundle 'django-template-textobjects'
NeoBundle 'https://github.com/davidhalter/jedi-vim.git'
NeoBundle 'https://github.com/Valloric/YouCompleteMe.git'
" Load Ultisnips last to make sure it has the <tab> map
NeoBundle 'https://github.com/SirVer/ultisnips.git'
NeoBundle 'https://github.com/vim-scripts/stata.vim'

" Tornado template syntax
NeoBundle 'https://github.com/vim-scripts/tornadotmpl.vim.git'

" Colorschemes
"
" Solarized has been good to me. I plan to keep it a while
NeoBundle 'Solarized'

 filetype plugin indent on     " Required!
 "
 " Brief help
 " :NeoBundleList          - list configured bundles
 " :NeoBundleInstall(!)    - install(update) bundles
 " :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

 " Installation check.
NeoBundleCheck

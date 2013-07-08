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
"
" Call infect to get the bundle handling started.
call pathogen#infect()
" infect our locally tracked pkgs
" "call pathogen#infect('~/pkgs/vim')
"
" Brief help on Bundle commands  
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused
"
" see :h vundle for more details or wiki for FAQ
" *NOTE*: comments after Bundle command are not allowed..
"
" [Vundle](https://github.com/gmarik/vundle) Configuration
" Add vundle to our runtime path (rtp) and start vundle
"
let this_dir = expand('%:p:h')
set rtp+=''.this_dir.'/../bundle/vundle/'
" set rtp+=~/pkgs/vim/bundle/vundle/
call vundle#rc()

" Bundles
" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
"Bundle 'https://github.com/gmarik/vundle'
Bundle 'https://github.com/tpope/vim-fugitive.git'

" git-hub specific bundles:
Bundle 'https://github.com/kien/ctrlp.vim'
Bundle 'https://github.com/nvie/vim-flake8'
" Bundle 'https://github.com/klen/python-mode'
" Bundle 'git://github.com/Lokaltog/powerline.git'
Bundle 'https://github.com/bling/vim-airline.git'
Bundle 'https://github.com/bling/vim-bufferline.git'
Bundle 'https://github.com/kien/rainbow_parentheses.vim'
Bundle 'https://github.com/natw/vim-pythontextobj.git'
Bundle 'https://github.com/abudden/TagHighlight.git'
Bundle 'https://github.com/scrooloose/nerdcommenter.git'
Bundle 'git://github.com/lrvick/Conque-Shell.git'
Bundle 'https://github.com/tpope/vim-eunuch.git'
Bundle 'https://github.com/plasticboy/vim-markdown.git'
Bundle 'https://github.com/airblade/vim-gitgutter.git'
" Bundle 'git://github.com/tpope/vim-obsession.git'
Bundle 'git://github.com/junegunn/vim-easy-align.git'
Bundle 'git://github.com/uggedal/go-vim.git'
Bundle 'git://github.com/scrooloose/syntastic.git'
Bundle 'https://bitbucket.org/agr/ropevim'


" Other bundles
Bundle 'vcscommand.vim'
" Bundle 'vim-scripts/tComment'
Bundle 'ZenCoding.vim'
Bundle 'Gundo'
Bundle 'The-NERD-tree'
" Bundle 'git://github.com/vim-scripts/Conque-Shell.git'
Bundle 'Solarized'
" Bundle 'simple-pairs'  " Not a fan of this one.
Bundle 'DirDiff.vim'
Bundle 'vim-indent-object'
" Bundle 'Python-mode-klen'

" Bundle 'argtextobj.vim'
" Bundle 'textobj-indent'
" Bundle 'django-template-textobjects'

Bundle 'https://github.com/davidhalter/jedi-vim.git'
Bundle 'SuperTab-continued.'

" This one is neat, but does not play well with UltiSnips
" Bundle 'https://github.com/Valloric/YouCompleteMe.git'

" Load Ultisnips last to make sure it has the <tab> map
" Bundle 'https://github.com/vim-scripts/UltiSnips'
Bundle 'git://github.com/vim-scripts/UltiSnips.git'

" https://lampsvn.epfl.ch/trac/scala/browser/scala-tool-support/trunk/src/vim
" Bundle 'scala'

" Colorschemes
"
" [Lucius](https://github.com/vim-scripts/Lucius) is a great 256
" color theme with both light and dark 
" schemes.  
" [Hemisu](http://noahfrederick.com/vim-color-scheme-hemisu/)
" looks nice, going to try it out for a while
Bundle 'Lucius'

" The tomorrow theme(s)
Bundle 'https://github.com/chriskempson/tomorrow-theme'

" The following are schemes I like, but I'm not using them right now.
"
Bundle 'https://github.com/Lokaltog/vim-distinguished'
Bundle 'github-theme'
Bundle 'noahfrederick/Hemisu'
Bundle 'eclm_wombat.vim'
Bundle 'wombat256.vim'
Bundle 'Wombat'
Bundle 'jellybeans.vim'
Bundle 'twilight256.vim'
Bundle 'twilight'
" Bundle 'Twilight-for-python'
Bundle 'https://github.com/tpope/vim-vividchalk'
Bundle 'https://github.com/w0ng/vim-hybrid'
" Bundle 'https://github.com/vim-scripts/summerfruit256'
Bundle 'git://github.com/vim-scripts/summerfruit256.vim.git'



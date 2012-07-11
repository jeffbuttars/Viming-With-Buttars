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
call pathogen#infect('~/.vim/pkgs')
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
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Bundles
" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" git-hub specific bundles:
Bundle 'https://github.com/kien/ctrlp.vim'
Bundle 'https://github.com/nvie/vim-flake8'
" Bundle 'https://github.com/klen/python-mode'
Bundle 'https://github.com/Lokaltog/vim-powerline'
Bundle 'https://github.com/vim-scripts/UltiSnips'
Bundle 'https://github.com/kien/rainbow_parentheses.vim'


" Other bundles
Bundle 'python.vim'
Bundle 'vcscommand.vim'
Bundle 'vim-scripts/tComment'
Bundle 'ZenCoding.vim'
Bundle 'Gundo'
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
" The following are schemes I like, but I'm not using them right now.
    " Bundle 'noahfrederick/Hemisu'
    " Bundle 'eclm_wombat.vim'
    " Bundle 'wombat256.vim'
    " Bundle 'Wombat'
    " Bundle 'jellybeans.vim'
    " Bundle 'github-theme'


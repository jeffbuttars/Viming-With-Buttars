#!/bin/bash

build_ycm()
{
    # Build YouCompleteMe
    if [[ -d ~/.vim/bundle/YouCompleteMe ]]; then
        pr_info "Building YouCompleteMe"

        cd ~/.vim/bundle/YouCompleteMe
        git submodule update --init --recursive
        echo $(git rev-parse HEAD) > $THIS_DIR/last_ycm
        # ./install.sh --clang-completer --system-libclang --system-boost
        ./install.sh --clang-completer
        cd -
    fi
} #build_ycm

if [[ ! -f  $THIS_DIR/last_ycm ]]; then
    build_ycm
else
    echo $(git rev-parse HEAD) > $THIS_DIR/this_ycm
    cmp $THIS_DIR/last_ycm  $THIS_DIR/this_ycm
    lc=$?
    if [[ "$lc" != "0" ]]; then
        build_ycm
    fi
fi

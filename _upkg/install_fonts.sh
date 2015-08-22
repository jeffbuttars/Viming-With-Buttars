#!/bin/bash

GIT_DST_DIR="${PWD}/nerd-fonts"
FONT_DST_DIR='~/fonts'

mkdir -p "$FONT_DST_DIR"

if [[ -d "$GIT_DST_DIR" ]]; then
    cd "$GIT_DST_DIR"
    git pull
    cd -
else
    git clone https://github.com/ryanoasis/nerd-fonts.git "$GIT_DST_DIR"
fi

cp -f "$GIT_DST_DIR/glyph-source-fonts/devicons.ttf" "$FONT_DST_DIR/"

cd "$GIT_DST_DIR"
./install.sh
cd -

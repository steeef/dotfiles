#!/bin/bash
VIMREPO=https://vim.googlecode.com/hg/
DOWNLOADDIR=$HOME/code/vim

command -v hg >/dev/null 2>&1 || { echo >&2 "hg not installed."; exit 1; }

/bin/mkdir -p $DOWNLOADDIR
HGCLONED=$(hg -R $DOWNLOADDIR root);HGCLONEDERR=$?
if [ $HGCLONEDERR == 0 ]; then
    cd $DOWNLOADDIR && hg pull -u
else
    hg clone $VIMREPO $DOWNLOADDIR
    cd $DOWNLOADDIR
fi
./configure --with-features=huge --enable-rubyinterp --enable-pythoninterp --enable-cscope --prefix=$HOME && /usr/bin/make clean && /usr/bin/make && /usr/bin/make install


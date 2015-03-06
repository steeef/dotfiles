#!/bin/bash
VIMREPO=https://vim.googlecode.com/hg/
DOWNLOADDIR=$HOME/download/vim

command -v hg >/dev/null 2>&1 || { echo >&2 "hg not installed."; exit 1; }

/bin/mkdir -p $DOWNLOADDIR
hg archive $VIMREPO $DOWNLOADDIR
cd $DOWNLOADDIR
./configure --with-features=huge --enable-rubyinterp --enable-pythoninterp --enable-cscope --prefix=$HOME && /usr/bin/make clean && /usr/bin/make && /usr/bin/make install


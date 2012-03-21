#!/bin/bash
VIMREPO=https://vim.googlecode.com/hg/
DOWNLOADDIR=$HOME/code/vim
HG=/usr/bin/hg

/bin/mkdir -p $DOWNLOADDIR
$HG clone $VIMREPO $DOWNLOADDIR || cd $DOWNLOADDIR && $HG pull -u
cd $DOWNLOADDIR && ./configure --with-features=huge --prefix=$HOME && /usr/bin/make clean && /usr/bin/make && /usr/bin/make install


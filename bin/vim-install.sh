#!/bin/bash
VIMREPO=https://vim.googlecode.com/hg/
DOWNLOADDIR=$HOME/code/vim
HG=/usr/bin/hg

/bin/mkdir -p $DOWNLOADDIR
HGCLONED=$($HG -R $DOWNLOADDIR root);HGCLONEDERR=$?
if [ $HGCLONEDERR == 0 ]; then
    cd $DOWNLOADDIR && $HG pull -u
else
    $HG clone $VIMREPO $DOWNLOADDIR
    cd $DOWNLOADDIR
fi
./configure --with-features=huge --enable-rubyinterp --enable-pythoninterp --enable-cscope --prefix=$HOME && /usr/bin/make clean && /usr/bin/make && /usr/bin/make install


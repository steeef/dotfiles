#!/bin/bash
VIMREPO=https://github.com/vim/vim.git
DOWNLOADDIR=$HOME/code/vim

command -v git >/dev/null 2>&1 || { echo >&2 "git not installed."; exit 1; }

/bin/mkdir -p $DOWNLOADDIR
GITCLONED=$(cd $DOWNLOADDIR && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
    cd $DOWNLOADDIR && git pull
else
    rm -rf $DOWNLOADDIR
    git clone $VIMREPO $DOWNLOADDIR
    cd $DOWNLOADDIR
fi
./configure --with-features=huge --enable-rubyinterp --enable-pythoninterp --enable-cscope --prefix=$HOME && /usr/bin/make clean && /usr/bin/make && /usr/bin/make install


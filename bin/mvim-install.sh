#!/bin/bash
MVIMREPO=git://github.com/zhaocai/macvim.git
DOWNLOADDIR=$HOME/code/mvim

/bin/mkdir -p $DOWNLOADDIR
GITCLONED=$(cd $DOWNLOADDIR && git rev-parse --git-dir 2> /dev/null);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
    cd $DOWNLOADDIR && git pull
else
    git clone $MVIMREPO $DOWNLOADDIR
    cd $DOWNLOADDIR
fi
./configure --with-features=huge --enable-luainterp --enable-rubyinterp --enable-pythoninterp --enable-cscope && make && open src/MacVim/build/Release


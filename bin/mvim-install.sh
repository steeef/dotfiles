#!/bin/bash

# Clones/updates from macvim-dev repo on GitHub, and builds with specific
# features:
# - ruby
# - python
# - cscope
# - "huge" features
#
# Dependencies:
# git
#
# https://github.com/b4winckler/macvim/wiki/Building

MVIMREPO=https://github.com/macvim-dev/macvim.git
DOWNLOADDIR=$HOME/code/mvim

command -v git >/dev/null 2>&1 || { echo >&2 "git not installed."; exit 1; }

/bin/mkdir -p $DOWNLOADDIR
# Check if $DOWNLOADDIR is a git repo
GITCLONED=$(cd $DOWNLOADDIR && git rev-parse --git-dir 2> /dev/null);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
    cd $DOWNLOADDIR && git pull
else
    rm -rf $DOWNLOADDIR
    git clone $MVIMREPO $DOWNLOADDIR
    cd $DOWNLOADDIR
fi

LDFLAGS=-L/usr/lib ./configure --with-features=huge --enable-rubyinterp \
    --enable-pythoninterp --enable-cscope \
    && make \
    && open src/MacVim/build/Release # copy from this directory to /Applications

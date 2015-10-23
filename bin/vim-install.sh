#!/bin/bash

# Clones/updates from official Vim repo on GitHub, and builds with specific
# features:
# - ruby
# - python
# - cscope
# - "huge" features
#
# Dependencies:
# Debian: build-essential git ruby-dev python-dev libncurses5-dev
# RHEL: make automake gcc-c++ git ruby-devel python-devel ncurses-devel
# OS X: git

VIMREPO=https://github.com/vim/vim.git
DOWNLOADDIR=$HOME/code/vim

command -v git >/dev/null 2>&1 || { echo >&2 "git not installed."; exit 1; }

/bin/mkdir -p $DOWNLOADDIR
# Check if $DOWNLOADDIR is a git repo
GITCLONED=$(cd $DOWNLOADDIR && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
    cd $DOWNLOADDIR && git pull
else
    rm -rf $DOWNLOADDIR
    git clone $VIMREPO $DOWNLOADDIR
    cd $DOWNLOADDIR
fi
./configure --with-features=huge --enable-rubyinterp --enable-pythoninterp \
    --enable-cscope --prefix=$HOME \
    && /usr/bin/make clean \
    && /usr/bin/make \
    && /usr/bin/make install

#!/bin/bash

# Clones/updates from official Neovim repo on GitHub.
#
# Dependencies:
# https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites

VIMREPO=https://github.com/neovim/neovim.git
DOWNLOADDIR=$HOME/code/neovim

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
make clean \
  && make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$HOME -DCMAKE_BUILD_TYPE=RelWithDebInfo" \
  && make install

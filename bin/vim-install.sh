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

if [ "$(uname)" = "Darwin" ]; then
  EXTRA_ARGS="--with-python3-config-dir=/usr/local/Cellar/python/3.6.5/Frameworks/Python.framework/Versions/3.6/lib/python3.6/config-3.6m-darwin --with-python3-command=/usr/local/bin/python3"
else
  EXTRA_ARGS=""
fi

command -v git >/dev/null 2>&1 || { echo >&2 "git not installed."; exit 1; }

/bin/mkdir -p "${DOWNLOADDIR}"
# Check if $DOWNLOADDIR is a git repo
(cd "${DOWNLOADDIR}" && git rev-parse --git-dir >/dev/null);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
    cd "${DOWNLOADDIR}" && git pull
else
    rm -rf "${DOWNLOADDIR}"
    git clone "${VIMREPO}" "${DOWNLOADDIR}"
    cd "${DOWNLOADDIR}"
fi
./configure \
    --with-features=huge \
    --enable-rubyinterp \
    --disable-pythoninterp \
    --enable-python3interp \
    ${EXTRA_ARGS} \
    --enable-cscope \
    --prefix="${HOME}" \
    --enable-fail-if-missing \
    && /usr/bin/make clean \
    && /usr/bin/make \
    && /usr/bin/make install

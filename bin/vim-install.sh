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
# OS X: git python3 ruby

VIMREPO=https://github.com/vim/vim.git
DOWNLOADDIR=$HOME/code/vim

if [ "$(uname)" = "Darwin" ]; then
  python_command="/usr/local/bin/python3"
  python_version="$(${python_command} --version | awk '{print $2}')"
  python_config_dir="$(find /usr/local/Cellar -name python.o \
    | grep -F "${python_version}" | xargs dirname)"
  EXTRA_ARGS="--with-python3-config-dir=${python_config_dir} \
    --with-python3-command=${python_command}"

  # use ruby from Homebrew
  export LDFLAGS="-L/usr/local/opt/ruby/lib"
  export CPPFLAGS="-I/usr/local/opt/ruby/include"
  export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

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
/usr/bin/make distclean \
  && ./configure \
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

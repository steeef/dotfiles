#!/bin/bash

# Clones/updates from official Neovim repo on GitHub.
#
# Dependencies:
# https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites

REPO=https://github.com/neovim/neovim.git
DOWNLOADDIR=$HOME/code/neovim

command -v git >/dev/null 2>&1 || { echo >&2 "git not installed."; exit 1; }

/bin/mkdir -p "${DOWNLOADDIR}"
# Check if $DOWNLOADDIR is a git repo
if (cd "${DOWNLOADDIR}" && git rev-parse --git-dir >/dev/null 2>&1); then
  (
    cd "${DOWNLOADDIR}"
    git fetch
    if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
      git fetch --all
      git pull
    fi
  )
else
  rm -rf "${DOWNLOADDIR}"
  git clone "${REPO}" "${DOWNLOADDIR}"
fi
pushd "${DOWNLOADDIR}"
rm -rf "build" \
  && make clean \
  && make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX:PATH=$HOME -DCMAKE_BUILD_TYPE=RelWithDebInfo" \
  && make install
popd

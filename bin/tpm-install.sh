#!/bin/bash
#
# Clones/updates from official tpm repo on GitHub.
#

REPO=https://github.com/tmux-plugins/tpm.git
DOWNLOADDIR=$HOME/.tmux/plugins/tpm

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

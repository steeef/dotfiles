#!/bin/bash

# Clones/updates from official VS Code repo on GitHub
#
# Dependencies:
# Debian: build-essential git python-dev nvm
# RHEL: make automake gcc-c++ git python-devel nvm
# OS X: git xcode nvm

REPO=https://github.com/Microsoft/vscode.git
DOWNLOADDIR=$HOME/code/vscode
NVM_DIR="$HOME/.nvm"

command -v git >/dev/null 2>&1 || { echo >&2 "git not installed."; exit 1; }

/bin/mkdir -p $DOWNLOADDIR
# Check if $DOWNLOADDIR is a git repo
GITCLONED=$(cd $DOWNLOADDIR && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
    cd $DOWNLOADDIR && git pull
else
    rm -rf $DOWNLOADDIR
    git clone $REPO $DOWNLOADDIR
    cd $DOWNLOADDIR
fi

(cd $DOWNLOADDIR && . "$NVM_DIR/nvm.sh" && nvm exec stable ./scripts/npm.sh install)

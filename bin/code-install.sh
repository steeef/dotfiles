#!/bin/bash

# Clones/updates from official VS Code repo on GitHub
#
# Dependencies:
# Debian: build-essential git python-dev nvm jq
# RHEL: make automake gcc-c++ git python-devel nvm jq
# OS X: git xcode nvm jq

REPO=https://github.com/Microsoft/vscode.git
DOWNLOADDIR=$HOME/code/vscode
NVM_DIR="$HOME/.nvm"

command -v git >/dev/null 2>&1 || { echo >&2 "git not installed."; exit 1; }

/bin/mkdir -p $DOWNLOADDIR
# Check if $DOWNLOADDIR is a git repo
GITCLONED=$(cd $DOWNLOADDIR && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
    git -C $DOWNLOADDIR fetch --all
    git -C $DOWNLOADDIR reset --hard origin/master
else
    rm -rf $DOWNLOADDIR
    git clone $REPO $DOWNLOADDIR
fi
# enable extensions by modifying json with jq
jq '. + { "extensionsGallery": { "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items" }}' ${DOWNLOADDIR}/product.json > tmp.$$.json && mv tmp.$$.json ${DOWNLOADDIR}/product.json

(cd $DOWNLOADDIR && . "$NVM_DIR/nvm.sh" && nvm exec stable ./scripts/npm.sh install)

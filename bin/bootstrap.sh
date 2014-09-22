#!/bin/bash

function ensure_link {
    test -L "$HOME/$2" || ln -s "$HOME/.dotfiles/$1" "$HOME/$2"
}

mkdir -p "${HOME}/code"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/build"

ensure_link "bin"       ".bin"
ensure_link "vim/vimrc" ".vimrc"
ensure_link "vim"       ".vim"
ensure_link "ackrc"     ".ackrc"
ensure_link "bash"      ".bash"
ensure_link "bashrc"    ".bashrc"
ensure_link "gemrc"     ".gemrc"
ensure_link "gitignore" ".gitignore"
ensure_link "gvimrc"    ".gvimrc"
ensure_link "hgignore"  ".hgignore"
ensure_link "irbrc"     ".irbrc"
ensure_link "inputrc"   ".inputrc"
ensure_link "maid"      ".maid"
ensure_link "railsrc"   ".railsrc"
ensure_link "tmux"      ".tmux"
ensure_link "sshrc"     ".sshrc"
ensure_link "screenrc"  ".screenrc"
ensure_link "tmux"      ".tmux"
ensure_link "tmux.conf" ".tmux.conf"

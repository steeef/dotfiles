#!/bin/bash

function ensure_link {
    test -L "$HOME/$2" || ln -s "$HOME/.dotfiles/$1" "$HOME/$2"
}

mkdir -p "${HOME}/code"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/build"

ensure_link "bin"        ".bin"
ensure_link "vim/vimrc"  ".vimrc"
ensure_link "vim"        ".vim"
ensure_link "ackrc"      ".ackrc"
ensure_link "bash"       ".bash"
ensure_link "bashrc"     ".bashrc"
ensure_link "gemrc"      ".gemrc"
ensure_link "gitignore"  ".gitignore"
ensure_link "git_template" ".git_template"
ensure_link "hgignore"   ".hgignore"
ensure_link "irbrc"      ".irbrc"
ensure_link "inputrc"    ".inputrc"
ensure_link "maid"       ".maid"
ensure_link "tmux"       ".tmux"
ensure_link "iterm2"     ".iterm2"
ensure_link "sshrc"      ".sshrc"
ensure_link "screenrc"   ".screenrc"
ensure_link "tmux"       ".tmux"
ensure_link "Xresources" ".Xresources"
if [ "$(uname)" == 'Darwin' ]; then
    ensure_link "tmux-osx"   ".tmux.conf"
else
    ensure_link "tmux-linux" ".tmux.conf"
fi
ensure_link "tmux.conf"  ".tmux.main.conf"
ensure_link "zsh"        ".zsh"
ensure_link "zshrc"      ".zshrc"
ensure_link "zpreztorc"  ".zpreztorc"
ensure_link "slate"      ".slate"
ensure_link "fonts"      ".fonts"
ensure_link "i3"         ".i3"
ensure_link "i3/i3status.conf" ".i3status.conf"
ensure_link "hammerspoon" ".hammerspoon"

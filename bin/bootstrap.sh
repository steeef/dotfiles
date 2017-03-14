#!/usr/bin/env bash

function ensure_link {
    test -L "$HOME/$2" || ln -s "$HOME/.dotfiles/$1" "$HOME/$2"
}

mkdir -p "${HOME}/.config/beets"
mkdir -p "${HOME}/.config/Code/User"
mkdir -p "${HOME}/code"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/build"

ensure_link "Brewfile"           ".Brewfile"
ensure_link "bin"                ".bin"
ensure_link "vim/vimrc"          ".vimrc"
ensure_link "vim"                ".vim"
ensure_link "ackrc"              ".ackrc"
ensure_link "bash"               ".bash"
ensure_link "bashrc"             ".bashrc"
ensure_link "beets/config.yaml"  ".config/beets/config.yaml"
ensure_link "code/settings.json" ".config/Code/User/settings.json"
ensure_link "gemrc"              ".gemrc"
ensure_link "gitignore"          ".gitignore"
ensure_link "git_template"       ".git_template"
ensure_link "hgignore"           ".hgignore"
ensure_link "irbrc"              ".irbrc"
ensure_link "inputrc"            ".inputrc"
ensure_link "maid"               ".maid"
ensure_link "tmux"               ".tmux"
ensure_link "tmux.conf"          ".tmux.conf"
ensure_link "iterm2"             ".iterm2"
ensure_link "sshrc"              ".sshrc"
ensure_link "screenrc"           ".screenrc"
ensure_link "tmux"               ".tmux"
ensure_link "Xresources"         ".Xresources"
ensure_link "zsh"                ".zsh"
ensure_link "zshrc"              ".zshrc"
ensure_link "zpreztorc"          ".zpreztorc"
ensure_link "slate"              ".slate"
ensure_link "fonts"              ".fonts"
ensure_link "i3"                 ".i3"
ensure_link "i3/i3status.conf"   ".i3status.conf"
ensure_link "hammerspoon"        ".hammerspoon"
ensure_link "editorconfig"       ".editorconfig"

if [ "$(uname)" = "Darwin" ]; then
  # install XCode Command Line Tools if not installed
  if [ $(xcode-select -p &> /dev/null; printf $?) -ne 0 ]; then
     xcode-select --install
  fi

  # install Homebrew
  if ! command -v brew >/dev/null 2>&1; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Install packages in ~/.Bundlefile
  brew update
  brew tap homebrew/bundle
  brew bundle --global
fi

#!/usr/bin/env zsh
#
# requirements:
# - zsh

set -e

function ensure_link {
  if [ ! -L "$HOME/$2" ]; then
    if [ "$3" = "force" ]; then
      ln -sfn "$HOME/.dotfiles/$1" "$HOME/$2"
    else
      ln -s "$HOME/.dotfiles/$1" "$HOME/$2"
    fi
  fi
}

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.config/beets"
mkdir -p "${HOME}/.config/nvim"
mkdir -p "${HOME}/code"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/build"

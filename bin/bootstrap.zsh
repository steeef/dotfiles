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

ensure_link "beets/config.yaml"  ".config/beets/config.yaml" "force"
ensure_link "bin"                ".bin"
ensure_link "black"              ".config/black"
ensure_link "git_template"       ".git_template"
ensure_link "karabiner"          ".config/karabiner" "force"
ensure_link "nvim/init.lua"      ".config/nvim/init.lua" "force"
ensure_link "nvim/lua"           ".config/nvim/lua" "force"
ensure_link "zsh/p10k.zsh"       ".p10k.zsh"
ensure_link "screenrc"           ".screenrc"
ensure_link "zsh"                ".zsh"
ensure_link "ideavimrc"          ".ideavimrc"

PATH="${HOME}/bin:${HOME}/.bin:${PATH}"
export PATH

distro_and_version="$(get-distro)"
distro_version="$(echo "${distro_and_version}" | awk '{print $2}')"

function is_macos() {
  [[ $distro_and_version =~ MacOS ]]
}

function is_debian() {
  [[ $distro_and_version =~ Debian ]]
}

if is_macos; then
  # install Homebrew
  if ! command -v brew >/dev/null 2>&1; then
     echo "INFO: Installing homebrew"
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
fi

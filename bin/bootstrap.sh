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
ensure_link "gitconfig"          ".gitconfig"
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
     echo "INFO: Installing XCode Command Line Tools"
     xcode-select --install
  fi

  # install Homebrew
  if ! command -v brew >/dev/null 2>&1; then
     echo "INFO: Installing homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Install packages in ~/.Bundlefile
  echo "INFO: Updating homebrew and packages"
  brew update
  brew tap homebrew/bundle
  brew bundle --global
fi

# base16-shell setup
base16dir="${HOME}/code/base16-shell"
base16repo="https://github.com/chriskempson/base16-shell.git"
mkdir -p "${base16dir}"
GITCLONED=$(cd ${base16dir} && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
  echo "INFO: Updating base16-shell"
  (cd ${base16dir} && git pull)
else
  echo "INFO: Installing base16-shell"
  rm -rf "${base16dir}"
  git clone ${base16repo} "${base16dir}"
fi

# prezto setup
preztodir="${HOME}/.zprezto"
preztorepo="https://github.com/sorin-ionescu/prezto.git"
mkdir -p "${preztodir}"
GITCLONED=$(cd ${preztodir} && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
  echo "INFO: Updating prezto"
  (cd ${preztodir} && git pull --recurse-submodules)
else
  echo "INFO: Installing base16-shell"
  rm -rf "${preztodir}"
  git clone --recursive ${preztorepo} "${preztodir}"
fi

if command -v vim >/dev/null 2>&1; then
  # Install plugins with vim-plug
  echo "INFO: Installing vim-plug plugins"
  vim -c 'PlugInstall --sync' +qall
fi

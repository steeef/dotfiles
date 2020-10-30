#!/usr/bin/env bash
#
# requirements:
# - openssl@1.1
# - pyenv
# - pyenv-virtualenv

set -e

PYTHON_VERSIONS=(
  2.7.17
  3.8.6
  3.9.0
)
PYTHON_DEFAULT="3.9.0 3.8.6 2.7.17"
PYTHON_MODULES="${HOME}/.dotfiles/requirements.txt"

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
mkdir -p "${HOME}/.config/kitty"
mkdir -p "${HOME}/Library/Application Support/Code/User"
mkdir -p "${HOME}/code"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/build"

ensure_link "Brewfile"           ".Brewfile"
ensure_link "Xresources"         ".Xresources"
ensure_link "xinitrc"            ".xinitrc"
ensure_link "xinitrc"            ".xprofile"
ensure_link "ackrc"              ".ackrc"
ensure_link "bash"               ".bash"
ensure_link "bashrc"             ".bashrc" "force"
ensure_link "beets/config.yaml"  ".config/beets/config.yaml" "force"
ensure_link "bin"                ".bin"
ensure_link "editorconfig"       ".editorconfig"
ensure_link "fonts"              ".fonts"
ensure_link "gemrc"              ".gemrc"
ensure_link "git_template"       ".git_template"
ensure_link "gitconfig"          ".gitconfig"
ensure_link "gitignore"          ".gitignore"
ensure_link "hammerspoon"        ".hammerspoon"
ensure_link "hblock"        ".hblock"
ensure_link "hgignore"           ".hgignore"
ensure_link "karabiner"          ".config/karabiner" "force"
ensure_link "kitty.conf"          ".config/kitty/kitty.conf" "force"
ensure_link "i3"                 ".i3"
ensure_link "inputrc"            ".inputrc"
ensure_link "polybar"            ".config/polybar"
ensure_link "irbrc"              ".irbrc"
ensure_link "iterm2"             ".iterm2"
ensure_link "maid"               ".maid"
ensure_link "p10k.zsh"           ".p10k.zsh"
ensure_link "vim/vimrc"          ".config/nvim/init.vim"
ensure_link "vim/autoload"       ".config/nvim/autoload"
ensure_link "redshift"           ".config/redshift"
ensure_link "screenrc"           ".screenrc"
ensure_link "sshrc"              ".sshrc"
ensure_link "starship.toml"      ".config/starship.toml"
ensure_link "tmux"               ".tmux"
ensure_link "tmux.conf"          ".tmux.conf"
ensure_link "vim"                ".vim"
ensure_link "vim/vimrc"          ".vimrc"
ensure_link "zsh"                ".zsh"
ensure_link "zsh/zshrc"          ".zshrc" "force"
ensure_link "ideavimrc"          ".ideavimrc"

if [ "$(uname)" = "Darwin" ]; then
  ensure_link "code/settings.json" "Library/Application Support/Code/User/settings.json"
  ensure_link "code/settings.json" "Library/Application Support/Code - Insiders/User/settings.json"
  ensure_link "code/keybindings.json" "Library/Application Support/Code/User/keybindings.json"
  ensure_link "code/keybindings.json" "Library/Application Support/Code - Insiders/User/keybindings.json"
  ensure_link "code/snippets" "Library/Application Support/Code/User/snippets"
  ensure_link "code/snippets" "Library/Application Support/Code - Insiders/User/snippets"
fi

if [ "$(uname)" = "Darwin" ]; then
  echo "INFO: Copying fonts."
  rsync -aW "${HOME}/.dotfiles/fonts/" ~/Library/Fonts/
  # install XCode Command Line Tools if not installed
  if ! xcode-select -p &> /dev/null; then
     echo "INFO: Installing XCode Command Line Tools"
     xcode-select --install
  fi

  # install Homebrew
  if ! command -v brew >/dev/null 2>&1; then
     echo "INFO: Installing homebrew"
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi

  # Install packages in ~/.Bundlefile
  echo "INFO: Updating homebrew and packages"
  brew update
  brew tap homebrew/bundle
  brew bundle --global

  OPENSSL_LIB="$(find /usr/local/Cellar/openssl@1.1 -type d -depth 1)/lib"
  DYLD_LIBRARY_PATH="${OPENSSL_LIB}"
else
  FZFDIR="${HOME}/.fzf"
  if (cd "${FZFDIR}" && git rev-parse --git-dir >/dev/null 2>&1); then
    (
      cd "${FZFDIR}" || return
      git fetch
      if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
        git pull
      fi
    )
  else
    rm -rf "${FZFDIR}"
    mkdir -p "${FZFDIR}"
    git clone https://github.com/junegunn/fzf.git "${FZFDIR}"
  fi
  "${FZFDIR}/install" --key-bindings --completion --no-update-rc

  # pyenv
  PYENV_ROOT="${HOME}/.pyenv"
  if (cd "${PYENV_ROOT}" && git rev-parse --git-dir >/dev/null 2>&1); then
    (
      cd "${PYENV_ROOT}" || return
      git fetch
      if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
        git pull
      fi
    )
  else
    rm -rf "${PYENV_ROOT}"
    mkdir -p "${PYENV_ROOT}"
    git clone https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"
  fi
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

eval "$(command pyenv init -)"
eval "$(command pyenv virtualenv-init -)"

# Install python versions and setup for Neovim
for python in "${PYTHON_VERSIONS[@]}"; do
  (pyenv versions --bare --skip-aliases | grep -q "^${python}\$") \
    || (export DYLD_LIBRARY_PATH; pyenv install "${python}")
  (PYENV_VERSION="${python}" pip install --upgrade pip)
  (PYENV_VERSION="${python}" pip install --upgrade -r "${PYTHON_MODULES}")
done

# set default
(pyenv global | grep -q '^'"${PYTHON_DEFAULT}"'$') \
  || pyenv global ${PYTHON_DEFAULT}

# coc terraform-lsp install
"${HOME}/.bin/terraform-lsp_install.sh"

# vim plug install
curl -sfLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

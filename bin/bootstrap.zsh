#!/usr/bin/env zsh
#
# requirements:
# - zsh

set -e

PYTHON_VERSIONS=(
  3.8.13
  3.9.13
  3.10.4
)
PYTHON_DEFAULT=(
  3.10.4
)

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
mkdir -p "${HOME}/.config/kitty"
mkdir -p "${HOME}/.config/nvim"
mkdir -p "${HOME}/Library/Application Support/Code/User"
mkdir -p "${HOME}/Library/Application Support/Code - Insiders/User"
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
ensure_link "hblock"             ".hblock"
ensure_link "hgignore"           ".hgignore"
ensure_link "karabiner"          ".config/karabiner" "force"
ensure_link "kitty.conf"          ".config/kitty/kitty.conf" "force"
ensure_link "i3"                 ".i3"
ensure_link "inputrc"            ".inputrc"
ensure_link "polybar"            ".config/polybar"
ensure_link "irbrc"              ".irbrc"
ensure_link "iterm2"             ".iterm2"
ensure_link "maid"               ".maid"
ensure_link "nvim/init.lua"      ".config/nvim/init.lua" "force"
ensure_link "nvim/lua"           ".config/nvim/lua" "force"
ensure_link "p10k.zsh"           ".p10k.zsh"
ensure_link "redshift"           ".config/redshift"
ensure_link "screenrc"           ".screenrc"
ensure_link "sshrc"              ".sshrc"
ensure_link "tmux.conf"          ".tmux.conf"
ensure_link "vim"                ".vim"
ensure_link "vim/vimrc"          ".vimrc"
ensure_link "zsh"                ".zsh"
ensure_link "zsh/zshrc"          ".zshrc" "force"
ensure_link "ideavimrc"          ".ideavimrc"

PYENV_ROOT="${HOME}/.pyenv"
export PYENV_ROOT
PYENV_VIRTUALENV_ROOT="${PYENV_ROOT}/plugins/pyenv-virtualenv"
export PYENV_VIRTUALENV_ROOT
PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${HOME}/bin:${HOME}/.bin:${PATH}"
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
  ensure_link "code/settings.json" "Library/Application Support/Code/User/settings.json"
  ensure_link "code/settings.json" "Library/Application Support/Code - Insiders/User/settings.json"
  ensure_link "code/keybindings.json" "Library/Application Support/Code/User/keybindings.json"
  ensure_link "code/keybindings.json" "Library/Application Support/Code - Insiders/User/keybindings.json"
  ensure_link "code/snippets" "Library/Application Support/Code/User/snippets"
  ensure_link "code/snippets" "Library/Application Support/Code - Insiders/User/snippets"
fi

if is_macos; then
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

  # Launch Agent setup
  launch_agent_src_dir="${HOME}/.dotfiles/launch_agents"
  launch_agent_dst_dir="${HOME}/Library/LaunchAgents"
  for launch_agent_file in $(gfind "${launch_agent_src_dir}" -type f \
    -name '*.plist' -printf '%P\n'); do
    echo "configuring Launch Agent ${launch_agent_file}"
    cp -f "${launch_agent_src_dir}/${launch_agent_file}" "${launch_agent_dst_dir}/"
    if launchctl list | grep -q "${launch_agent_file%.plist}"; then
      launchctl unload "${launch_agent_dst_dir}/${launch_agent_file}"
    fi
    launchctl load "${launch_agent_dst_dir}/${launch_agent_file}"
  done

  # iterm2 preferences
  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${HOME}/.iterm2"
  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  macos_setup.sh
else
  sudo apt-get update

  # install bfs
  sudo apt-get -y install acl-dev libcap-dev
  bfs_install.sh

  debian_major_version="$(lsb_release -s -d | awk '{print $3}' | grep -oP '.*?(?=\.)')"
  if [ "${debian_major_version}" = "9" ]; then

    PYTHON_VERSIONS=(
      3.8.13
      3.9.13
    )
    PYTHON_DEFAULT=(
      3.9.13
    )
  fi

  # pyenv
  echo "INFO: Installing pyenv"
  sudo apt-get -y install make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
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

  echo "INFO: Installing pyenv-virtualenv"
  if (cd "${PYENV_VIRTUALENV_ROOT}" && git rev-parse --git-dir >/dev/null 2>&1); then
    (
      cd "${PYENV_VIRTUALENV_ROOT}" || return
      git fetch
      if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
        git pull
      fi
    )
  else
    rm -rf "${PYENV_VIRTUALENV_ROOT}"
    mkdir -p "${PYENV_VIRTUALENV_ROOT}"
    git clone https://github.com/pyenv/pyenv-virtualenv.git "${PYENV_VIRTUALENV_ROOT}"
  fi
fi

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install python versions
for python in "${PYTHON_VERSIONS[@]}"; do
  if is_debian; then
    CFLAGS=-I/usr/include/openssl
    LDFLAGS=-L/usr/lib
    export CFLAGS LDFLAGS
  fi
  (pyenv versions --bare --skip-aliases | grep -q "^${python}\$") \
    || (export DYLD_LIBRARY_PATH; pyenv install "${python}")
  (PYENV_VERSION="${python}" pip install --upgrade pip)
  (PYENV_VERSION="${python}" pip install --upgrade -r "${PYTHON_MODULES}")
done

# set default
pyenv global "${PYTHON_DEFAULT[@]}"

# vim plug install
curl -sfLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# neovim packer install
git clone --depth=1 https://github.com/wbthomason/packer.nvim \
    "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" 2>/dev/null || true

# tpm install
tpm-install.sh

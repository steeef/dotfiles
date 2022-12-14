#!/usr/bin/env zsh
#
# requirements:
# - zsh

set -e

PYTHON_VERSIONS=(
  3.8.13
  3.9.13
  3.10.6
)
PYTHON_DEFAULT=(
  3.10.6
)

PYTHON_MODULES="${HOME}/.dotfiles/requirements.txt"

DIRENV_VERSION=2.32.1


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
ensure_link "black"              ".config/black"
ensure_link "editorconfig"       ".editorconfig"
ensure_link "envrc"              ".envrc"
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
  ensure_link "code/settings.json" "Library/Application Support/Code/User/settings.json"
  ensure_link "code/settings.json" "Library/Application Support/Code - Insiders/User/settings.json"
  ensure_link "code/keybindings.json" "Library/Application Support/Code/User/keybindings.json"
  ensure_link "code/keybindings.json" "Library/Application Support/Code - Insiders/User/keybindings.json"
  ensure_link "code/snippets" "Library/Application Support/Code/User/snippets"
  ensure_link "code/snippets" "Library/Application Support/Code - Insiders/User/snippets"

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
  asdf_dir="${HOME}/.asdf"
  debian_major_version="$(lsb_release -s -d | awk '{print $3}' | grep -o '^[0-9]\+')"
  sudo apt-get update
  sudo apt-get -y install acl-dev libcap-dev build-essential make libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  if [[ ${debian_major_version} -gt 10 ]]; then
    bat_install.sh
  fi

  # install bfs
  bfs_install.sh

  if [ "${debian_major_version}" = "9" ]; then
    PYTHON_VERSIONS=(
      3.8.13
      3.9.13
    )
    PYTHON_DEFAULT=(
      3.9.13
    )
  fi

  # asdf
  echo "INFO: Installing asdf"
  if (cd "${asdf_dir}" && git rev-parse --git-dir >/dev/null 2>&1); then
    (
      cd "${asdf_dir}" || return
      git fetch
      if [ "$(git rev-parse HEAD)" != "$(git rev-parse @{u})" ]; then
        git pull
      fi
    )
  else
    rm -rf "${asdf_dir}"
    mkdir -p "${asdf_dir}"
    git clone https://github.com/asdf-vm/asdf.git "${asdf_dir}"
  fi
fi

if is_debian; then
  source "${asdf_dir}/asdf.sh"
elif is_macos; then
  source $(brew --prefix asdf)/libexec/asdf.sh
fi

# Install python versions
(asdf plugin list | grep -q 'python') || asdf plugin add python
asdf plugin update python
for python in "${PYTHON_VERSIONS[@]}"; do
  asdf install python "${python}"
  (asdf shell python "${python}"; pip install --upgrade pip)
  (asdf shell python "${python}"; pip install --upgrade -r "${PYTHON_MODULES}")
done
asdf reshim python

# set default
asdf global python "${PYTHON_DEFAULT[@]}"

# direnv setup
(asdf plugin list | grep -q 'direnv') || asdf plugin add direnv
asdf install direnv "${DIRENV_VERSION}"
asdf global direnv "${DIRENV_VERSION}"
asdf direnv setup --shell zsh --version "${DIRENV_VERSION}"
asdf exec direnv allow "${HOME}"

# vim plug install
curl -sfLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# neovim packer install
git clone --depth=1 https://github.com/wbthomason/packer.nvim \
    "${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim" 2>/dev/null || true

# tpm install
tpm-install.sh

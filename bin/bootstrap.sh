#!/usr/bin/env bash
#
# requirements:
# - fasd
# - node-build
# - nodenv
# - openssl@1.1
# - pyenv
# - pyenv-virtualenv
# - rbenv
# - ruby-build
#

PYTHON_VERSIONS=(
  2.7.17
  3.8.2
)
PYTHON_DEFAULT=3.8.2
PYTHON_MODULES="${HOME}/.dotfiles/requirements.txt"

RUBY_GEMFILE="${HOME}/.dotfiles/Gemfile"

RUBY_VERSIONS=(
  2.7.1
)
RUBY_DEFAULT=2.7.1

NODE_VERSIONS=(
  12.16.2
)
NODE_DEFAULT=12.16.2

COC_EXTENSIONS_PATH="${HOME}/.config/coc/extensions"
COC_EXTENSIONS=(
  bash-language-server
  dockerfile-language-server-nodejs
)

OPENSSL_LIB="$(find /usr/local/Cellar/openssl@1.1 -type d -depth 1)/lib"
DYLD_LIBRARY_PATH="${OPENSSL_LIB}"

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
ensure_link "code/settings.json" "Library/Application Support/Code/User/settings.json"
ensure_link "code/settings.json" "Library/Application Support/Code - Insiders/User/settings.json"
ensure_link "code/keybindings.json" "Library/Application Support/Code/User/keybindings.json"
ensure_link "code/keybindings.json" "Library/Application Support/Code - Insiders/User/keybindings.json"
ensure_link "code/snippets" "Library/Application Support/Code/User/snippets"
ensure_link "code/snippets" "Library/Application Support/Code - Insiders/User/snippets"
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
ensure_link "vim/vimrc"          ".config/nvim/init.vim"
ensure_link "vim/autoload"       ".config/nvim/autoload"
ensure_link "redshift"           ".config/redshift"
ensure_link "screenrc"           ".screenrc"
ensure_link "sshrc"              ".sshrc"
ensure_link "tmux"               ".tmux"
ensure_link "tmux.conf"          ".tmux.conf"
ensure_link "vim"                ".vim"
ensure_link "vim/vimrc"          ".vimrc"
ensure_link "zpreztorc"          ".zpreztorc"
ensure_link "zsh"                ".zsh"
ensure_link "zshrc"              ".zshrc"
ensure_link "ideavimrc"          ".ideavimrc"

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
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Install packages in ~/.Bundlefile
  echo "INFO: Updating homebrew and packages"
  brew update
  brew tap homebrew/bundle
  brew bundle --global

  # fzf install
  [ -f "/usr/local/opt/fzf/install" ] \
    && /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
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
fi

eval "$(command nodenv init -)"
eval "$(command pyenv init -)"
eval "$(command pyenv virtualenv-init -)"
eval "$(command rbenv init -)"

# Install python versions and setup for Neovim
for python in "${PYTHON_VERSIONS[@]}"; do
  (pyenv versions --bare --skip-aliases | grep -q "^${python}\$") \
    || (export DYLD_LIBRARY_PATH; pyenv install "${python}")
  (PYENV_VERSION="${python}" pip install --upgrade pip)
  (PYENV_VERSION="${python}" pip install --upgrade -r "${PYTHON_MODULES}")
  venv="neovim$(echo "${python}" | cut -d'.' -f1)"
  pyenv virtualenv "${python}" "${venv}"
  (pyenv activate "${venv}" && pip install --upgrade pip neovim && pyenv deactivate)
  if [ "${venv}" = "neovim2" ]; then
    var="g:python_host_prog"
  elif [ "${venv}" = "neovim3" ]; then
    var="g:python3_host_prog"
  fi
  if ! grep -q "^let ${var}=" "${HOME}/.config/nvim/python.vim"; then
    touch "${HOME}/.config/nvim/python.vim"
    echo "let ${var}='${HOME}/.pyenv/versions/${venv}/bin/python'" \
    >> "${HOME}/.config/nvim/python.vim"
  fi
done

# set default
(pyenv global | grep -q '^'${PYTHON_DEFAULT}'$') \
  || pyenv global  ${PYTHON_DEFAULT}

# now node
for node in "${NODE_VERSIONS[@]}"; do
  (nodenv versions --bare --skip-aliases | grep -q "^${node}\$") \
  || nodenv install "${node}"
done

# set default
(nodenv global | grep -q '^'${NODE_DEFAULT}'$') \
  || nodenv global ${NODE_DEFAULT}

# now ruby
for ruby in "${RUBY_VERSIONS[@]}"; do
  (rbenv versions --bare --skip-aliases | grep -q "^${ruby}\$") \
  || rbenv install "${ruby}"
done

# set default
(rbenv global | grep -q '^'${RUBY_DEFAULT}'$') \
  || rbenv global ${RUBY_DEFAULT}

bundle install --gemfile="${RUBY_GEMFILE}"

# coc language server installs
mkdir -p "${COC_EXTENSIONS_PATH}"
for extension in "${COC_EXTENSIONS[@]}"; do
  (cd  "${COC_EXTENSIONS_PATH}" && npm install "${extension}")
done

# base16-shell setup
base16dir="${HOME}/code/base16-shell"
base16repo="https://github.com/chriskempson/base16-shell.git"
mkdir -p "${base16dir}"
(cd "${base16dir}" && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
  echo "INFO: Updating base16-shell"
  (cd "${base16dir}" && git pull)
else
  echo "INFO: Installing base16-shell"
  rm -rf "${base16dir}"
  git clone ${base16repo} "${base16dir}"
fi

# prezto setup
preztodir="${HOME}/.zprezto"
preztorepo="https://github.com/sorin-ionescu/prezto.git"
mkdir -p "${preztodir}"
(cd "${preztodir}" && git rev-parse --git-dir);GITCLONEDERR=$?
if [ $GITCLONEDERR == 0 ]; then
  echo "INFO: Updating prezto"
  (cd "${preztodir}" && git pull --recurse-submodules)
else
  echo "INFO: Installing prezto"
  rm -rf "${preztodir}"
  git clone --recursive ${preztorepo} "${preztodir}"
fi

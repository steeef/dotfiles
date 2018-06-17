#!/usr/bin/env bash
#
# requirements:
# - fasd
# - nodenv
# - pyenv
# - pyenv-virtualenv
# - rbenv
# - ruby-build
#

PYTHON_VERSIONS=(
  2.7.14
  3.6.5
)
PYTHON_DEFAULT=3.6.5
PYTHON_MODULES=(
  flake8
  ipython
  neovim
  neovim-remote
)
RUBY_VERSIONS=(
  2.4.2
)
RUBY_DEFAULT=2.4.2
RUBY_MODULES="neovim"

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
mkdir -p "${HOME}/.config/nvim"
mkdir -p "${HOME}/.config/Code/User"
mkdir -p "${HOME}/code"
mkdir -p "${HOME}/bin"
mkdir -p "${HOME}/build"

ensure_link "Brewfile"           ".Brewfile"
ensure_link "Xresources"         ".Xresources"
ensure_link "xprofile"           ".xprofile"
ensure_link "ackrc"              ".ackrc"
ensure_link "bash"               ".bash"
ensure_link "bashrc"             ".bashrc" "force"
ensure_link "bin"                ".bin"
ensure_link "code/settings.json" ".config/Code/User/settings.json"
ensure_link "editorconfig"       ".editorconfig"
ensure_link "fonts"              ".fonts"
ensure_link "gemrc"              ".gemrc"
ensure_link "git_template"       ".git_template"
ensure_link "gitconfig"          ".gitconfig"
ensure_link "gitignore"          ".gitignore"
ensure_link "hammerspoon"        ".hammerspoon"
ensure_link "hgignore"           ".hgignore"
ensure_link "karabiner"          ".config/karabiner" "force"
ensure_link "i3"                 ".i3"
ensure_link "inputrc"            ".inputrc"
ensure_link "irbrc"              ".irbrc"
ensure_link "iterm2"             ".iterm2"
ensure_link "maid"               ".maid"
ensure_link "vim/vimrc"          ".config/nvim/init.vim"
ensure_link "vim/autoload"       ".config/nvim/autoload"
ensure_link "screenrc"           ".screenrc"
ensure_link "sshrc"              ".sshrc"
ensure_link "tmux"               ".tmux"
ensure_link "tmux.conf"          ".tmux.conf"
ensure_link "vim"                ".vim"
ensure_link "vim/vimrc"          ".vimrc"
ensure_link "zpreztorc"          ".zpreztorc"
ensure_link "zsh"                ".zsh"
ensure_link "zshrc"              ".zshrc"

if [ "$(uname)" = "Darwin" ]; then
  echo "INFO: Copying fonts."
  rsync -aW "${HOME}/.dotfiles/fonts/" ~/Library/Fonts/
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

  # fzf install
  [ -f "/usr/local/opt/fzf/install" ] \
    && /usr/local/opt/fzf/install --key-bindings --completion --no-update-rc
else
  FZFDIR="${HOME}/.fzf"
  if (cd "${FZFDIR}" && git rev-parse --git-dir >/dev/null 2>&1); then
    (
      cd "${FZFDIR}"
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

# pyenv and rbenv setup
for file in "${HOME}/.zshrc_local" "${HOME}/.bashrc_local"; do
  for bin in "pyenv init -" "rbenv init -" "pyenv virtualenv-init -"; do
    grep -q "${bin}" "${file}" \
      || echo 'eval "$('${bin}')"' >> "${file}"
  done
done
if [ "$(basename "${SHELL}")" = "zsh" ]; then
  source "${HOME}/.zshrc_local"
elif [ "$(basename "${SHELL}")" = "bash" ]; then
  source "${HOME}/.bashrc_local"
fi

# Install python versions and setup for Neovim
for python in "${PYTHON_VERSIONS[@]}"; do
  (pyenv versions --bare --skip-aliases | grep -q '^'${python}'$') \
  || pyenv install "${python}"
  # install linter
  (PYENV_VERSION="${python}" pip install ${PYTHON_MODULES})
  venv="neovim$(echo "${python}" | cut -d'.' -f1)"
  pyenv virtualenv "${python}" "${venv}"
  (pyenv activate "${venv}" && pip install neovim && pyenv deactivate)
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

# now ruby
for ruby in "${RUBY_VERSIONS[@]}"; do
  (rbenv versions --bare --skip-aliases | grep -q '^'${ruby}'$') \
  || rbenv install "${ruby}"
done

# set default
(rbenv global | grep -q '^'${RUBY_DEFAULT}'$') \
  || rbenv global ${RUBY_DEFAULT}

gem install "${RUBY_MODULES}"

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

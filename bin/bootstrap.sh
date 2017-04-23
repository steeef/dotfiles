#!/usr/bin/env bash
PYTHON_VERSIONS=(
  2.7.13
  3.6.0
)
PYTHON_DEFAULT=2.7.13
RUBY_VERSIONS=(
  2.4.0
)
RUBY_DEFAULT=2.4.0

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
ensure_link "i3"                 ".i3"
ensure_link "i3/i3status.conf"   ".i3status.conf"
ensure_link "karabiner"          ".config/karabiner" "force"
ensure_link "inputrc"            ".inputrc"
ensure_link "irbrc"              ".irbrc"
ensure_link "iterm2"             ".iterm2"
ensure_link "maid"               ".maid"
ensure_link "nvim/init.vim"      ".config/nvim/init.vim"
ensure_link "nvim/autoload"      ".config/nvim/autoload"
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

# pyenv and rbenv setup
for file in "${HOME}/.zshrc_local" "${HOME}/.bashrc_local"; do
  for bin in "pyenv init -" "rbenv init -" "pyenv virtualenv-init -"; do
    grep -q "${bin}" "${file}" \
      || echo 'eval "$('${bin}')"' >> "${file}"
  done
done
if [ "$(basename ${SHELL})" = "zsh" ]; then
  source "${HOME}/.zshrc_local"
elif [ "$(basename ${SHELL})" = "bash" ]; then
  source "${HOME}/.bashrc_local"
fi

# Install python versions and setup for Neovim
for python in "${PYTHON_VERSIONS[@]}"; do
  (pyenv versions --bare --skip-aliases | grep -q '^'${python}'$') \
  || pyenv install ${python}
  venv="neovim$(echo ${python} | cut -d'.' -f1)"
  pyenv virtualenv ${python} ${venv}
  (pyenv activate ${venv} && pip install neovim && pyenv deactivate)
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
  || rbenv install ${ruby}
done

# set default
(rbenv global | grep -q '^'${RUBY_DEFAULT}'$') \
  || rbenv global ${RUBY_DEFAULT}

gem install neovim

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

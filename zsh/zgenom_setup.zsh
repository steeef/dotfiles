ZGENOM_DIR="${HOME}/.zgenom"
if ! [ -d "${ZGENOM_DIR}" ]; then
  git clone git@github.com:jandamm/zgenom.git "${ZGENOM_DIR}"
fi
source "${ZGENOM_DIR}/zgenom.zsh"

if ! zgen saved; then
  zgen load zsh-users/zsh-completions # Load more completions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  zgen load jandamm/vi-mode.zsh # Show line cursor in vi mode

  # k is a zsh script / plugin to make directory listings more readable,
  # adding a bit of color and some git status information on files and
  # directories.
  zgen load supercrabtree/k

  zgen load junegunn/fzf shell/completion.zsh
  zgen load junegunn/fzf shell/key-bindings.zsh

  zgen load blimmer/zsh-aws-vault

  zgen load davidparsson/zsh-pyenv-lazy

  zgen bin clvv/fasd

  zgen save

  zgen compile "${HOME}/.zshrc"
  zgen compile "${ZSHDIR}"
fi

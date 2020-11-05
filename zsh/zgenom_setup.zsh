ZGENOM_DIR="${HOME}/.zgenom"
if ! [ -d "${ZGENOM_DIR}" ]; then
  git clone git@github.com:jandamm/zgenom.git "${ZGENOM_DIR}"
fi
source "${ZGENOM_DIR}/zgenom.zsh"

if ! zgen saved; then
  zgen load zsh-users/zsh-completions src # Load more completions
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  zgen load jandamm/vi-mode.zsh # Show line cursor in vi mode

  zgen load larkery/zsh-histdb

  # k is a zsh script / plugin to make directory listings more readable,
  # adding a bit of color and some git status information on files and
  # directories.
  zgen load supercrabtree/k

  # fzf
  zgen load junegunn/fzf shell/completion.zsh
  zgen load junegunn/fzf shell/key-bindings.zsh
  "${ZGENOM_DIR}/junegunn/fzf-master/install" --bin

  zgen load blimmer/zsh-aws-vault # aliases
  zgen load reegnz/aws-vault-zsh-plugin # completion

  zgen load davidparsson/zsh-pyenv-lazy

  # colorschemes
  zgen load chrissicool/zsh-256color
  zgen load chriskempson/base16-shell

  zgen load romkatv/powerlevel10k powerlevel10k

  zgen bin clvv/fasd
  zgen bin junegunn/fzf

  zgen save

  zgen compile "${HOME}/.zshrc"
  zgen compile "${ZSHDIR}"
fi

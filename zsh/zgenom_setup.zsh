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

  # fzf
  zgen load junegunn/fzf shell/completion.zsh
  zgen load junegunn/fzf shell/key-bindings.zsh
  "${ZGEN_DIR}/junegunn/fzf-___/install" --bin

  zgen load blimmer/zsh-aws-vault # aliases
  zgen load reegnz/aws-vault-zsh-plugin # completion

  zgen load davidparsson/zsh-pyenv-lazy

  zgen oh-my-zsh
  zgen oh-my-zsh plugins/kubectl

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

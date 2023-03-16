ZGENOM_DIR="${HOME}/.zgenom"
if ! [ -d "${ZGENOM_DIR}" ]; then
  git clone git@github.com:jandamm/zgenom.git "${ZGENOM_DIR}"
fi
source "${ZGENOM_DIR}/zgenom.zsh"

if ! zgenom saved; then
  zgenom load zsh-users/zsh-completions src # Load more completions
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search

  zgenom load jandamm/vi-mode.zsh # Show line cursor in vi mode

  zgenom load larkery/zsh-histdb

  zgenom load blimmer/zsh-aws-vault # aliases
  zgenom load reegnz/aws-vault-zsh-plugin # completion

  zgenom oh-my-zsh
  zgenom oh-my-zsh plugins/kubectl
  zgenom oh-my-zsh plugins/kubectx
  zgenom oh-my-zsh plugins/vi-mode

  # colorschemes
  zgenom load chrissicool/zsh-256color
  zgenom load chriskempson/base16-shell

  zgenom load romkatv/powerlevel10k powerlevel10k
  zgenom load dracula/zsh

  zgenom bin clvv/fasd

  zgenom save

  zgenom compile "${HOME}/.zshrc"
  zgenom compile "${ZSHDIR}"
fi

# disable oh-my-zsh update
export DISABLE_AUTO_UPDATE='true'

# correct spelling for commands
setopt correct
# turn off correct for filenames
unsetopt correctall

# history options
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_verify
setopt inc_append_history
unsetopt hist_beep

setopt INTERACTIVE_COMMENTS # Enable comments in interactive shell.

# Long running processes should return time after they complete. Specified
# in seconds.
REPORTTIME=60
TIMEFMT="%U user %S system %P cpu %*Es total"

# vi mode
bindkey -v

# command line editing with vi helpers
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line # open vim to edit command

# select the command suggested inline
bindkey '^[[Z' autosuggest-accept # shift + tab

PATH="${HOME}/.local/bin:${HOME}/.zgenom/bin:${HOME}/bin:${HOME}/.bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export PATH

# zgenom setup
ZSHDIR="${HOME}/.zsh"

# Load and recompile before plugins
setopt nullglob
for file in ${ZSHDIR}/before/*.zsh; do
  source "${file}"
done
unsetopt nullglob

zgenom autoupdate --background 7
if ! zgenom saved; then
  zgenom load zsh-users/zsh-completions src # Load more completions
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search

  zgenom load chisui/zsh-nix-shell

  zgenom load peterhurford/git-it-on.zsh # open github from repo

  zgenom load blimmer/zsh-aws-vault # aliases and prompt

  # colorschemes
  zgenom load chrissicool/zsh-256color
  zgenom load chriskempson/base16-shell

  zgenom load dracula/zsh
  zgenom load catppuccin/zsh-syntax-highlighting themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

  zgenom save

  zgenom compile "${HOME}/.zshrc"
  zgenom compile "${ZSHDIR}"
fi

# Load and recompile after plugins
setopt nullglob
for file in ${ZSHDIR}/after/*.zsh; do
  source "${file}"
done
unsetopt nullglob

# Make it easy to append your own customizations that override the above by
# loading all files from the ~/.zshrc.d directory
mkdir -p ~/.zshrc.d
if [ -n "$(ls ~/.zshrc.d)" ]; then
  for dotfile in ~/.zshrc.d/*; do
    if [ -r "${dotfile}" ]; then
      source "${dotfile}"
    fi
  done
fi

if [ "$(uname -s)" = "Linux" ]; then
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
    export SSH_AUTH_SOCK
  fi
elif [ "$(uname -s)" = "Darwin" ]; then
  SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
  export SSH_AUTH_SOCK
fi

#granted config
GRANTED_ALIAS_CONFIGURED="true"
GRANTED_ENABLE_AUTO_REASSUME="true"
export GRANTED_ALIAS_CONFIGURED GRANTED_ENABLE_AUTO_REASSUME

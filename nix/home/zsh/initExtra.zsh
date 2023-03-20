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

setopt INTERACTIVE_COMMENTS  # Enable comments in interactive shell.

# Long running processes should return time after they complete. Specified
# in seconds.
REPORTTIME=60
TIMEFMT="%U user %S system %P cpu %*Es total"

# editor settings
EDITOR=nvim
VISUAL=nvim
export EDITOR VISUAL

# vi mode
bindkey -v

# command line editing with vi helpers
autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line # open vim to edit command

PATH="${HOME}/.zgenom/bin:${HOME}/bin:${HOME}/.bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export PATH

# zgenom setup
ZSHDIR="${HOME}/.zsh"

# Load and recompile before plugins
setopt nullglob
for file in ${ZSHDIR}/before/*.zsh; do
  source "${file}"
done
unsetopt nullglob

zgenom autoupdate --background --self 7
if ! zgenom saved; then
  zgenom load zsh-users/zsh-completions src # Load more completions
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search

  zgenom load chisui/zsh-nix-shell

  zgenom load larkery/zsh-histdb

  zgenom load blimmer/zsh-aws-vault # aliases
  zgenom load reegnz/aws-vault-zsh-plugin # completion

  # colorschemes
  zgenom load chrissicool/zsh-256color
  zgenom load chriskempson/base16-shell

  zgenom load romkatv/powerlevel10k powerlevel10k
  zgenom load dracula/zsh

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
if [ -n "$(/bin/ls ~/.zshrc.d)" ]; then
  for dotfile in ~/.zshrc.d/*
  do
    if [ -r "${dotfile}" ]; then
      source "${dotfile}"
    fi
  done
fi

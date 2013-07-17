ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="prose"
DISABLE_AUTO_UPDATE="true"
plugins=(git command-coloring)

source $ZSH/oh-my-zsh.sh
# disable auto-correct
unsetopt correct_all

# aliases --------------------------------------------------
alias j='z'
alias d='cd $HOME/.dotfiles'
alias space='du -ms * .[^\.]* | sort -nr | less -i'
alias lr='ls -ltr'

# huffshell suggestions
alias s='ssh'
compdef s=ssh

# todo.txt with tmux
#alias t=todo_tmux.sh
alias t=todo.sh
compdef t=todo.sh
alias tv='clear; t view context'
alias ts='t addto someday.txt'
alias te='t edit someday'

# git
alias g='git'
compdef g=git
alias ga='git add'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"

# hg
alias hga='hg add'
alias hgl='hg pull -u'
alias hgp='hg push'
alias hgd='hg diff'
alias hgc='hg commit'
alias hgcm='hg commit -m'
alias hgs='hg status'
alias hgu='hg update -C'
compdef hgu=hg
alias hgm='hg merge'
alias hgb='hg branch'
alias hgf='hg fetch'

# environment variables ------------------------------------
export EDITOR='vim'
export PATH="${HOME}/bin:${HOME}/.bin:/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
export GREP_OPTIONS='--color=auto'
export COMMAND_MODE=unix2003
# history --------------------------------------------------
export HISTSIZE=20000
export SAVEHIST=20000
#export HISTCONTROL=erasedups
setopt append_history
setopt extended_history
#  setopt hist_expire_dups_first
# setopt hist_ignore_dups # ignore duplication command history list
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
# setopt share_history # share command history data

# z --------------------------------------------------------
source ~/.bin/z.sh
function precmd () {
    _z --add "$(pwd -P)"
}

# VI Mode -------------------------------------------------------------
#bindkey -v

# Bindkeys ------------------------------------------------------------
bindkey "^R" history-incremental-search-backward
# PageUp/Down search history to complete command
bindkey "^[[I" history-beginning-search-backward
bindkey "^[[G" history-beginning-search-forward

# Local Settings -------------------------------------------------------------
if [[ -s $HOME/.zshrc_local ]] ; then source $HOME/.zshrc_local ; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

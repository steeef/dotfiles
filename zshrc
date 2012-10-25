ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="prose"
DISABLE_AUTO_UPDATE="true"
plugins=(git command-coloring)

source $ZSH/oh-my-zsh.sh

# aliases --------------------------------------------------
alias j='z'
alias d='cd $HOME/.dotfiles'
alias space='du -ms * .[^\.]* | sort -nr | less -i'
alias lr='ls -ltr'

# todo.txt
alias t='~/.bin/todo.sh'
alias tv='clear; t view context'
alias ts='t addto someday.txt'
alias te='t edit someday'

# git
alias g='git'
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
alias hgm='hg merge'
alias hgb='hg branch'
alias hgf='hg fetch'

# environment variables ------------------------------------
export EDITOR='vim'
export PATH="${HOME}/bin:${HOME}/.bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export GREP_OPTIONS='--color=auto'
export HISTSIZE=1000
export HISTFILESIZE=1000
export HISTCONTROL=erasedups
export COMMAND_MODE=unix2003

# z --------------------------------------------------------
source ~/.bin/z.sh
function precmd () {
    _z --add "$(pwd -P)"
}

# VI Mode -------------------------------------------------------------
bindkey -v
bindkey "^R" history-incremental-search-backward

# Local Settings -------------------------------------------------------------
if [[ -s $HOME/.zshrc_local ]] ; then source $HOME/.zshrc_local ; fi

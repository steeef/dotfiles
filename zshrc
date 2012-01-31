# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="steeef"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git mercurial)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:~/.bin

alias vi='vim'
alias space='du -ms * .[^\.]* | sort -nr | less -i'
alias d='cd ~/.dotfiles'

# reboot/shutdown
alias on='sudo reboot'
alias off='sudo shutdown -h now'

# todo.txt
alias t='$HOME/.bin/todo.sh'
alias ts='$HOME/.bin/todo.sh addto someday.txt'

# git
alias gsv='git svn dcommit'

# hg
alias hgcm='hg commit -m'
alias hgu='hg update'
alias hgm='hg merge'

# set vi mode
#bindkey -v

# add custom functions
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# add local
if [ -f $HOME/.zshrc-local ]; then
    source $HOME/.zshrc-local
fi

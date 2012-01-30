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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:~/.bin
alias vi='vim'
alias space='du -ms * .[^\.]* | sort -nr | less -i'
alias d='cd ~/.dotfiles'
alias remvim='~/.bin/remvim'
alias on='sudo reboot'
alias off='sudo shutdown -h now'
alias e0='sudo ifconfig eth0 down && sudo ifconfig eth0 up'
alias t='$HOME/.bin/todo.sh'
alias ts='$HOME/.bin/todo.sh addto someday.txt'
alias rvme='rvm 1.8.7-head,1.9.2-head,ree exec'
alias gsv='git svn dcommit'

# set vi mode
#bindkey -v

# add custom functions
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

# add local
source $HOME/.zshrc-local

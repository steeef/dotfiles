alias h='cd ~'
alias ll='ls -la'
alias lr='ls -latr'

alias s='ssh'

# git
alias g='git'
alias ga='git add'
alias gl='git pull'
alias gf='git fetch --all'
alias gp='git push'
alias gd='git diff'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gsub="git submodule"
alias gbp='git-delete-merged-branches --remote origin --yes'

# docker
alias d='docker'
alias drm='docker rm $(docker ps -a -q)'
alias drmi="docker rmi \$(docker images -q --filter 'dangling=true')"

# vim
alias vim='nvim'
alias v='vim'
alias vimdiff='nvim -d'

# kubectl
alias k='kubectl'

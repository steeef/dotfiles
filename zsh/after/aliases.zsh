alias h='cd ~'
alias ll='ls --color=auto -la'
alias lr='ls --color=auto -latr'

alias s='ssh'

# git
alias g='git'
alias ga='git add'
alias gl='git pull'
alias gf='git fetch --all'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpd='git push origin --delete'
alias gd='git diff'
alias gds='git diff --staged'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git commit -a -m'
alias gb='git branch'
alias gs='git status'
alias gst='git stash'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias grm='git rm $(git ls-files --deleted)'
alias gundo='git reset --soft HEAD~1'
alias gsub="git submodule"
alias gbp="gcl"

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

# Add zsh-completions to $fpath.
fpath=("${HOME}/.zsh/completion" $fpath)

# prezto --------------------------------------------------

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
    source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
# for some reason tmux module doesn't get loaded even when in the list of
# modules. Load it manually here based on .zprezto/init.zsh
if zstyle -t ":prezto:module:tmux" loaded 'no'; then
    if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/modules/tmux/init.zsh" ]]; then
        source "${ZDOTDIR:-$HOME}/.zprezto/modules/tmux/init.zsh"
    fi
    if (( $? == 0 )); then
        zstyle ":prezto:module:tmux" loaded 'yes'
    fi
fi

# options --------------------------------------------------
# disable auto-correct
unsetopt correct_all

# environment variables ------------------------------------
export EDITOR='vim'
export PATH="${HOME}/bin:${HOME}/.bin:/usr/local/bin:/usr/local/sbin:${PATH}"
export GREP_OPTIONS='--color=auto'
export COMMAND_MODE=unix2003

# aliases --------------------------------------------------
alias space='du -ms * .[^\.]* | sort -nr | less -i'
alias lr='ls -ltr'
alias h='cd ~'
alias l='ls -G'

# huffshell suggestions
alias s='ssh'
compdef s=ssh
alias v='vim'
compdef v=vim
alias tm='tmux'
compdef tm=tmux

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
alias gcam='git commit -a -m'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias gsub="git submodule"
alias gbpurge='git branch --merged | grep -Ev "(\*|master|feature|develop|staging)" | xargs -n 1 git branch -d'

# hg
alias hga='hg add'
alias hgl='hg pull --rebase'
alias hgr='hg rebase'
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

alias goto=". goto"

# docker
alias d='docker'
alias drm='docker rm $(docker ps -a -q)'
alias drmi="docker rmi \$(docker images -q --filter 'dangling=true')"

# sudo please
alias please='sudo $(fc -ln -1)'

#Use Pygments to color less
pless() { pygmentize -f terminal256 -g -P style=monokai $* | less -FiXRM }

# delete ssh host when keys are bad
function delhost() {
  sed -i -e "$@d" ~/.ssh/known_hosts
}

# bootstrap dotfiles
function sshboot() {
  if [ -n "$1" ]; then
    ssh -t $1 "curl -sL https://gist.githubusercontent.com/steeef/2cf6345055bdec2c9b8781267e8299ab/raw/download_and_bootstrap.sh | bash -ex; bash -l"
  else
    echo "USAGE: sshboot <host>"
  fi
}

# add alias for `fuck` command
command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias)"

# docker_alias stuff
function docker_alias() {
  docker run -it --rm \
    -v $(pwd):$1 -w $1 \
    -p 3000:3000 \
    -p 8080:8080 \
    -p 8000:8000 \
    -p 80:80 \
    -p 3306:3306 \
    -p 27017:27017 \
    ${@:2}
}

# colorscheme ---------------------------------------------------------
# https://github.com/chriskempson/base16-shell
BASE16_SCHEME="tomorrow-night"
BASE16_SHELL="$HOME/code/base16-shell/scripts/base16-$BASE16_SCHEME.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# VI Mode -------------------------------------------------------------
bindkey -v

# Bindkeys ------------------------------------------------------------
bindkey "^R" history-incremental-search-backward
# PageUp/Down search history to complete command
bindkey "^[[I" history-beginning-search-backward
bindkey "^[[G" history-beginning-search-forward

# z and fzf --------------------------------------------------------
[[ -s $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh

# fix CTRL-R within Neovim terminal
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

if [ -s $HOME/.bin/z.sh ]; then
    source $HOME/.bin/z.sh
    function precmd () {
        _z --add "$(pwd -P)"
    }
    alias j='z'

    if [ -s $HOME/.fzf.zsh ]; then
        unalias z
        z() {
        if [[ -z "$*" ]]; then
            cd "$(_z -l 2>&1 | sed -n 's/^[ 0-9.,]*//p' | fzf)"
        else
            _last_z_args="$@"
            _z "$@"
        fi
        }

        zz() {
        cd "$(_z -l 2>&1 | sed -n 's/^[ 0-9.,]*//p' | fzf -q $_last_z_args)"
        }
        alias jj='zz'
    fi
fi

# Ctrl-Z --------------------------------------------------------------------

# Make Ctrl-z also resume background process
fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle flush-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Local Settings -------------------------------------------------------------
[[ -s $HOME/.zshrc_local ]] && source $HOME/.zshrc_local

# Host completion
# skip /etc/hosts since it contains adblock info
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

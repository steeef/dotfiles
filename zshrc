# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# profiling -------------------------------------------------------------------
# https://kev.inburke.com/kevin/profiling-zsh-startup-time/
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>/tmp/startlog.$$
  setopt xtrace prompt_subst
fi

# Add zsh-completions to $fpath.
fpath=("${HOME}/.zsh/completion" $fpath)

# prezto --------------------------------------------------
#
#
# Workaround for: https://github.com/sorin-ionescu/prezto/issues/1744
#
export HISTFILE="${ZDOTDIR:-$HOME}/.zhistory" # The path to the history file.

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
if [ "$(uname)" = "Darwin" ]; then
  export PATH="${HOME}/bin:${HOME}/.bin:${HOME}/.pyenv/bin:${HOME}/.rbenv/bin:${HOME}/.nodenv/bin:$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:/usr/local/sbin:${PATH}"
else
  export PATH="${HOME}/bin:${HOME}/.bin:${HOME}/.pyenv/bin:${HOME}/.rbenv/bin:${HOME}/.nodenv/bin:/usr/local/bin:/usr/local/sbin:${PATH}"
fi
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
alias gp='git publish'
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
alias gbpurge='git branch --merged | grep -Ev "(\*|main|master|feature|develop|staging)" | xargs -n 1 git branch -d'

alias goto=". goto"

# docker
alias d='docker'
alias drm='docker rm $(docker ps -a -q)'
alias drmi="docker rmi \$(docker images -q --filter 'dangling=true')"

# homebrew
alias bup='brew update; brew upgrade; brew upgrade --cask'
alias bclean='brew cleanup'

# sudo please
alias please='sudo $(fc -ln -1)'

# aws-vault
alias av='aws-vault'
alias ave='aws-vault exec --duration=1h'

# terraform
alias tf='terraform'
alias tfa='terraform apply'
alias tfi='terraform init'
alias tfs='terraform workspace show'

whitenoise() { play -q -c 2 -n synth brownnoise band -n 1600 1500 tremolo .1 30 & }

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

# lookup cheatsheets
function cheat() {
  curl cht.sh/$1
}

function notify() {
  if [ -n "$1" ]; then
    osascript -e 'display notification "'"$1"'" with title "Notify"' && say "$1"
  else
    echo "USAGE: notify <message>"
  fi
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

# fasd ----------------------------------------------------------------------
if command -v fasd >/dev/null 2>&1; then
  fasd_cache="$HOME/.fasd-init"
  if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init zsh-hook zsh-ccomp zsh-ccomp-install  zsh-wcomp zsh-wcomp-install >| "$fasd_cache"
  fi
  source "$fasd_cache"
  unset fasd_cac

  # aliases
  alias a='fasd -a'
  alias sd='fasd -sid'
  alias sf='fasd -sif'
  alias d='fasd -d'
  alias f='fasd -f'
  # function to execute built-in cd
  fasd_cd() {
    if [ $# -le 1 ]; then
      fasd "$@"
    else
      local _fasd_ret="$(fasd -e 'printf %s' "$@")"
      [ -z "$_fasd_ret" ] && return
      [ -d "$_fasd_ret" ] && cd "$_fasd_ret" || printf %s\n "$_fasd_ret"
    fi
  }
  alias z='fasd_cd -d'
  alias zz='fasd_cd -d -i'
fi

# fzf -----------------------------------------------------------------------
# fzf in tmux pane
[ -n "$TMUX" ] && export FZF_TMUX=1
[[ -s $HOME/.fzf.zsh ]] && source $HOME/.fzf.zsh

# fix CTRL-R within Neovim terminal
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="bfs ~ -nohidden -type d -printf '~/%P\n'"

# fasd & fzf change directory - jump using `fasd` if given argument,
# filter output of `fasd` using `fzf` else
unalias z
z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

# git stuff
# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

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

# pyenv ----------------------------------------------------------------------
eval "$(command pyenv init -)"
eval "$(command pyenv virtualenv-init -)"

# rbenv ----------------------------------------------------------------------
eval "$(command rbenv init -)"

# nodenv ----------------------------------------------------------------------
eval "$(command nodenv init -)"
alias yarn="$(nodenv which yarn 2>/dev/null)"


# aws-vault login ------------------------------------------------------------

function awslogin() {
  url="$(aws-vault login --duration=8h --no-session ${1} --stdout)"
  if [[ ${url} =~ ^https://.* ]]; then
    nohup /Applications/Firefox.app/Contents/MacOS/firefox \
      -no-remote  -foreground \
      -profile "${HOME}/Library/Application Support/Firefox/Profiles/aws_${1}" \
      -P "aws_${1}" \
      -new-window "${url}" >/dev/null 2>&1 &
  else
    echo "ERROR: ${url}"
  fi
}
alias avl='awslogin'

# Local Settings -------------------------------------------------------------
[[ -s $HOME/.zshrc_local ]] && source $HOME/.zshrc_local

# Host completion
# skip /etc/hosts since it contains adblock info
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# end profiling --------------------------------------------------------------
if [[ "$PROFILE_STARTUP" == true ]]; then
unsetopt xtrace
exec 2>&3 3>&-
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

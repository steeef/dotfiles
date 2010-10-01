function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

setopt prompt_subst
autoload colors
colors

autoload -U add-zsh-hook
autoload -Uz vcs_info

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

add-zsh-hook precmd steeef_precmd

steeef_precmd() {
    vcs_info
}

PROMPT=$'
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}%~%{$reset_color%} $vcs_info_msg_0_
$(virtualenv_info)$ '

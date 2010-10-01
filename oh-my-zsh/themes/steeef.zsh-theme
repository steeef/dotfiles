function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}
PR_GIT_UPDATE=1

setopt prompt_subst
autoload colors
colors

autoload -U add-zsh-hook
autoload -Uz vcs_info

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr   'Â¹'  # display Â¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr     'Â²'  # display Â² if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats "(%{$fg[magenta]%}%b%u%c%{$reset_color%})(%{$fg[green]%}%a%{$reset_color%})"
zstyle ':vcs_info:*:prompt:*' formats       "(%{$fg[magenta]%}%b%u%c%{$reset_color%})"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""                             "%~"


function steeef_preexec {
    case "$(history $HISTCMD)" in
        *git*)
            PR_GIT_UPDATE=1
            ;;
    esac
}
add-zsh-hook preexec steeef_preexec

function steeef_chpwd {
    PR_GIT_UPDATE=1
}
add-zsh-hook chpwd steeef_chpwd

function steeef_precmd {
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        vcs_info 'prompt'
        PR_GIT_UPDATE=
    fi
}
add-zsh-hook precmd steeef_precmd

PROMPT=$'
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}%~%{$reset_color%} $vcs_info_msg_0_
$(virtualenv_info)$ '

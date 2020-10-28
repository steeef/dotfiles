fasd_cache="${HOME}/.fasd-init"
if [ "$(command -v fasd)" -nt "${fasd_cache}" -o ! -s "${fasd_cache}" ]; then
  fasd --init zsh-hook zsh-ccomp zsh-ccomp-install  zsh-wcomp zsh-wcomp-install >| "${fasd_cache}"
fi
source "${fasd_cache}"
unset fasd_cac
#
# function to execute built-in cd
fasd_cd() {
  if [ $# -le 1 ]; then
    fasd "$@"
  else
    local _fasd_ret="$(fasd -e 'printf %s' "$@")"
    [ -z "${_fasd_ret}" ] && return
    [ -d "${_fasd_ret}" ] && cd "${_fasd_ret}" || printf %s\n "${_fasd_ret}"
  fi
}

# fasd & fzf change directory - jump using `fasd` if given argument,
# filter output of `fasd` using `fzf` else
z() {
    [ $# -gt 0 ] && fasd_cd -d "$*" && return
    local dir
    dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

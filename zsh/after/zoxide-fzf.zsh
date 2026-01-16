# Override z to use fzf when no args given
function z() {
  if [[ $# -eq 0 ]]; then
    local dir=$(zoxide query -l | fzf --height 40% --reverse)
    [[ -n "$dir" ]] && cd "$dir"
  else
    __zoxide_z "$@"
  fi
}

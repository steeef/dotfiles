# tw <TAB> - complete tatari-tv repo names for the first argument only
_tw() {
  local -a repos
  _arguments '1:repo:->repos'
  case $state in
  repos)
    repos=(${(f)"$(tw --list-repos 2>/dev/null)"})
    _describe 'tatari-tv repo' repos
    ;;
  esac
}
compdef _tw tw

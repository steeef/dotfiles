function sudoedit() {
  env SUDO_EDITOR="$(which nvim)" sudoedit "$@"
}

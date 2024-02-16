#!/usr/bin/env bash
# source: https://gist.github.com/J-Swift/a4dad59843f1a1f512a72308031b5a44

set -euo pipefail

os="$(uname -s)"
nodename="$(uname -n)"

if [ "${os}" = "Darwin" ]; then
  home_manager_config='macbook'
else
  home_manager_config='linux'
fi

readonly real_script_dir="${HOME}/.dotfiles"

header() {
  local -r msg="${1:-}"
  echo '--------------------------------------------------------------------------------'
  echo "> ${msg}"
  echo '--------------------------------------------------------------------------------'
}

footer() {
  echo
}

main() {
  if [ "${os}" = "Darwin" ]; then
    header 'brew update'
    brew update
    brew upgrade
    brew upgrade --cask
    footer
  fi

  header 'home-manager switch'
  nix flake update "${real_script_dir}"

  if [ -f "/etc/NIXOS" ]; then
    header 'nixos update'
    sudo nixos-rebuild switch --flake "${real_script_dir}#${nodename}"
    footer
  fi

  home-manager switch --flake "path:${real_script_dir}#${USER}@${home_manager_config}"
  footer

  header 'home-manager expire-generations "-30 days"'
  home-manager expire-generations '-30 days'
  footer

  if [ "${os}" = "Darwin" ]; then
    header 'nix-darwin switch'
    darwin-rebuild switch --flake "${real_script_dir}"
    footer
  fi

  echo '> Done.'
}

main

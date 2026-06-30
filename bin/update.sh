#!/usr/bin/env bash
# source: https://gist.github.com/J-Swift/a4dad59843f1a1f512a72308031b5a44

set -euo pipefail

os="$(uname -s)"
nodename="$(uname -n)"

if [ "${os}" = "Darwin" ]; then
  home_manager_config="$(hostname)"
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

# Homebrew's `brew upgrade --cask` skips outdated casks unless `--greedy` is
# given, but `--greedy` re-upgrades version=latest casks every run. Upgrade only
# outdated casks that have a real version. (mirrors `bup` in zsh/after/homebrew.zsh)
upgrade_versioned_casks() {
  local outdated_casks unversioned_casks cask
  outdated_casks="$(brew outdated --cask --greedy | awk '{print $1}')"
  unversioned_casks="$(brew list --cask --versions | grep -w 'latest' |
    awk '{print $1}' | tr '\n' ' ')"

  if [ -n "${outdated_casks}" ]; then
    echo "brew: upgrading casks:"
    echo "${outdated_casks}"
    while read -r cask; do
      if ! [[ ${unversioned_casks} =~ ${cask} ]]; then
        brew upgrade --cask "${cask}"
      fi
    done <<<"${outdated_casks}"
  fi
}

main() {
  if [ "${os}" = "Darwin" ]; then
    header 'brew update'
    export HOMEBREW_NO_ASK=1 HOMEBREW_NO_ENV_HINTS=1
    brew update
    brew upgrade
    upgrade_versioned_casks
    footer
  fi

  header 'nix flake update'
  nix flake update --flake "${real_script_dir}"

  if [ -f "/etc/NIXOS" ]; then
    header 'nixos update'
    sudo nixos-rebuild switch --flake "${real_script_dir}#${nodename}"
    footer
  fi

  header 'home-manager switch'
  home-manager switch --flake "path:${real_script_dir}#${USER}@${home_manager_config}"
  footer

  if [ "${os}" = "Darwin" ]; then
    header 'nix-darwin switch'
    sudo darwin-rebuild switch --flake "${real_script_dir}"
    footer
  fi

  echo '> Done.'
}

main

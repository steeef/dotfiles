#!/usr/bin/env bash

set -e

PATH="/usr/local/bin:${PATH}"

SCRIPT_DIR=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DOTFILES_DIR=$(dirname "${SCRIPT_DIR}")

os="$(uname -s)"
arch="$(uname -m)"

load_nix_environment() {
  if [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}

# install Homebrew first
if [ "${os}" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "INFO: Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

load_nix_environment

# install nix
if ! command -v nix >/dev/null 2>&1; then
  # deal with https://github.com/NixOS/nix/issues/3861
  sudo chmod 0644 /etc/synthetic.conf

  sh <(curl -L https://nixos.org/nix/install)
fi

load_nix_environment

# enable flakes
local_config_file="${HOME}/.config/nix/nix.conf"
mkdir -p "$(dirname "${local_config_file}")"
if ! grep -qR "^experimental-features = nix-command flakes" "${local_config_file}"; then
  echo "experimental-features = nix-command flakes" >>"${local_config_file}"
fi

case "${os}-${arch}" in
"Darwin-x86_64")
  echo "INFO: Running Home Manager configuration for MacOS ${arch}"
  nix run "${DOTFILES_DIR}#homeConfigurations.${USER}@macbook.activationPackage"
  ;;
"Linux-x86_64")
  echo "INFO: Running Home Manager configuration for Linux ${arch}"
  nix run "${DOTFILES_DIR}#homeConfigurations.${USER}@linux.activationPackage"
  ;;
*)
  echo "ERROR: unsupported OS and arch: ${os}-${arch}"
  ;;
esac

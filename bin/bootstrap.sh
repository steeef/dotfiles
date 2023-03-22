#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
DOTFILES_DIR=$(dirname "${SCRIPT_DIR}")

os="$(uname -s)"
arch="$(uname -m)"

# install Homebrew first
if [ "${os}" = "Darwin" ]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "INFO: Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# install nix
if ! command -v nix >/dev/null 2>&1; then
  sh <(curl -L https://nixos.org/nix/install)
fi

# enable flakes permanently
file="/etc/nix/nix.conf"
key="experimental-features"
value="nix-command flakes"

if ! grep -qR "^[#]*\s*${key}\s*=.*" $file; then
  echo "INFO: appending: ${key} = ${value}"
  echo "$key = $value" | sudo tee -a $file >/dev/null
else
  echo "INFO: setting: ${key} = ${value}"
  sudo sed -i '' r "s/^[#]*\s*${key}\s*=.*/$key = $value/" $file
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

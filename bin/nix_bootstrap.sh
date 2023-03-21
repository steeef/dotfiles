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

# install nix via https://zero-to-nix.com
if ! command -v nix >/dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf -L "https://install.determinate.systems/nix" | sh -s -- install
fi

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

case "${os}-${arch}" in
"Darwin-x86_64")
        echo "Running Home Manager configuration for MacOS ${arch}"
        nix run "${DOTFILES_DIR}#homeConfigurations.${USER}@macbook.activationPackage"
        ;;
"Linux-x86_64")
        echo "Running Home Manager configuration for Linux ${arch}"
        nix run "${DOTFILES_DIR}#homeConfigurations.${USER}@linux.activationPackage"
        ;;
*)
        echo "ERROR: unsupported OS and arch: ${os}-${arch}"
        ;;
esac

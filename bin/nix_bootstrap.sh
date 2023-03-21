#!/usr/bin/env bash

set -e

PATH="${HOME}/bin:${HOME}/.bin:${PATH}"
export PATH

os="$(uname -s)"
arch="$(uname -m)"

function is_macos() {
        [[ $os =~ Darwin ]]
}

function is_linux() {
        [[ $os =~ Linux ]]
}

# install nix via https://zero-to-nix.com
if ! command -v nix >/dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf -L "https://install.determinate.systems/nix" | sh -s -- install
fi

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

if [ "${arch}" = "x86_64" ]; then
        if is_macos; then
                nix run ~/.dotfiles#homeConfigurations.${USER}@macbook.activationPackage
        elif is_linux; then
                nix run ~/.dotfiles#homeConfigurations.${USER}@linux.activationPackage
        else
                echo "ERROR: unknown distribution"
        fi
elif [ "${arch}" = "aarch64" ]; then
        echo "ERROR: aarch64 not supported (yet)"
else
        echo "ERROR: unknown architecture"
fi

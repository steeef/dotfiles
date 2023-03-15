#!/usr/bin/env zsh
#
# requirements:
# - zsh

set -e

PATH="${HOME}/bin:${HOME}/.bin:${PATH}"
export PATH

distro_and_version="$(get-distro)"
arch="$(echo "${distro_and_version}" | awk '{print $3}')"

function is_macos() {
        [[ $distro_and_version =~ MacOS ]]
}

function is_debian() {
        [[ $distro_and_version =~ Debian ]]
}

# install nix via https://zero-to-nix.com
if ! command -v nix >/dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf -L "https://install.determinate.systems/nix" | sh -s -- install
fi

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

if [ "${arch}" = "x86_64" ]; then
        if is_macos; then
                nix run ~/.dotfiles#homeConfigurations.macbook.activationPackage
        elif is_debian; then
                nix run ~/.dotfiles#homeConfigurations.linux.activationPackage
        else
                echo "ERROR: unknown distribution"
        fi
elif [ "${arch}" = "aarch64" ]; then
        echo "ERROR: aarch64 not supported (yet)"
else
        echo "ERROR: unknown architecture"
fi

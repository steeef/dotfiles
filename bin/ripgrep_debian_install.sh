#!/usr/bin/env bash

set -e

RIPGREP_VERSION="12.1.1"
RIPGREP_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb"
RIPGREP_CHECKSUM="6bbe751f27791992bd634d35d188b8db82687e72904e8ab2d234051f32d82699"

function cleanup {
  if [ -d "${RIPGREP_DOWNLOAD_DIR}" ]; then
    rm -rf "${RIPGREP_DOWNLOAD_DIR}"
  fi
}
trap cleanup EXIT


if ! command -v rg >/dev/null 2>&1 \
  || [ "$(rg --version | head -n 1 | awk '{print $2}')" != "${RIPGREP_VERSION}" ]; then

  RIPGREP_DOWNLOAD_DIR="$(mktemp -d)"
  (curl -fsSL "${RIPGREP_URL}" -o "${RIPGREP_DOWNLOAD_DIR}/ripgrep.deb" \
    && cd "${RIPGREP_DOWNLOAD_DIR}" \
    && echo "${RIPGREP_CHECKSUM} *ripgrep.deb" | sha256sum -c - \
    && sudo dpkg -i ripgrep.deb)
fi

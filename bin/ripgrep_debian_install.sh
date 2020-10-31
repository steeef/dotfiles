#!/usr/bin/env bash

set -e

RIPGREP_VERSION="12.1.1"
RIPGREP_URL="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep_${RIPGREP_VERSION}_amd64.deb"
RIPGREP_CHECKSUM="18ef498312073da55d2f2f65c6a906085c68368a23c9a45a87fcb8539be96608"

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

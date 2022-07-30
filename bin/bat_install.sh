#!/usr/bin/env bash

set -e

BAT_VERSION="0.21.0"
BAT_URL="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_amd64.deb"

function cleanup {
  if [ -d "${BAT_DOWNLOAD_DIR}" ]; then
    rm -rf "${BAT_DOWNLOAD_DIR}"
  fi
}
trap cleanup EXIT


if ! command -v bfs >/dev/null 2>&1 \
  || [ "$(bat --version | awk '{print $2}')" != "${BAT_VERSION}" ]; then

  BAT_DOWNLOAD_DIR="$(mktemp -d)"
  (curl -fsSL "${BAT_URL}" -o "${BAT_DOWNLOAD_DIR}/bat.deb" \
    && sudo dpkg -i "${BAT_DOWNLOAD_DIR}/bat.deb")
fi

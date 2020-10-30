#!/usr/bin/env bash

set -e

BFS_VERSION="2.0"
BFS_URL="https://github.com/tavianator/bfs/archive/${BFS_VERSION}.tar.gz"
BFS_CHECKSUM="afbde70742f4bac3f3b030b36531fe0bd67dbdda61ce0457f3a1e5681405df33"

function cleanup {
  if [ -d "${BFS_DOWNLOAD_DIR}" ]; then
    rm -rf "${BFS_DOWNLOAD_DIR}"
  fi
}
trap cleanup EXIT


if ! command -v bfs >/dev/null 2>&1 \
  || [ "$(bfs --version | head -n 1 | awk '{print $2}')" != "${BFS_VERSION}" ]; then

  BFS_DOWNLOAD_DIR="$(mktemp -d)"
  (curl -fsSL "${BFS_URL}" -o "${BFS_DOWNLOAD_DIR}/bfs.tar.gz" \
    && cd "${BFS_DOWNLOAD_DIR}" \
    && echo "${BFS_CHECKSUM} *bfs.tar.gz" | sha256sum -c - \
    && tar zxf bfs.tar.gz \
    && cd "bfs-${BFS_VERSION}" \
    && make clean \
    && make release \
    && cp bfs "${HOME}/bin/bfs")
fi

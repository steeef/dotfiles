#!/usr/bin/env bash

set -e

TERRAFORM_LSP_VERSION=0.0.10

if [ "$(uname)" = "Darwin" ]; then
  SHA256SUM="$(which gsha256sum)"
  TERRAFORM_LSP_CHECKSUM=936dbb076683dca4210286726a2504116407b3c870ac9b58efc4860f6b1c315f
  TERRAFORM_LSP_URL="https://github.com/juliosueiras/terraform-lsp/releases/download/v${TERRAFORM_LSP_VERSION}/terraform-lsp_${TERRAFORM_LSP_VERSION}_darwin_amd64.tar.gz"
else
  SHA256SUM="$(which sha256sum)"
  TERRAFORM_LSP_CHECKSUM=73624dde3d1bad07eb482534af56570e2b7218d3fd47fc0c0ea8fbb0c7a7d07a
  TERRAFORM_LSP_URL="https://github.com/juliosueiras/terraform-lsp/releases/download/v${TERRAFORM_LSP_VERSION}/terraform-lsp_${TERRAFORM_LSP_VERSION}_linux_amd64.tar.gz"
fi

function cleanup {
  if [ -d "${TERRAFORM_LSP_DOWNLOAD_DIR}" ]; then
    rm -rf "${TERRAFORM_LSP_DOWNLOAD_DIR}"
  fi
}
trap cleanup EXIT


if ! command -v terraform-lsp >/dev/null 2>&1 \
  || [ "$(terraform-lsp --version | cut -d',' -f1 | tr -d 'v')" != "${TERRAFORM_LSP_VERSION}" ]; then

  TERRAFORM_LSP_DOWNLOAD_DIR="$(mktemp -d)"
  (curl -fsSL "${TERRAFORM_LSP_URL}" -o "${TERRAFORM_LSP_DOWNLOAD_DIR}/terraform-lsp.tar.gz" \
    && cd "${TERRAFORM_LSP_DOWNLOAD_DIR}" \
    && echo "${TERRAFORM_LSP_CHECKSUM} *terraform-lsp.tar.gz" | $SHA256SUM -c - \

    && tar zxf terraform-lsp.tar.gz \
    && mv "${TERRAFORM_LSP_DOWNLOAD_DIR}/terraform-lsp" "${HOME}/bin/terraform-lsp")
fi

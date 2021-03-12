#!/usr/bin/env bash

set -e

TERRAFORM_LS_VERSION=0.15.0

if [ "$(uname)" = "Darwin" ]; then
  SHA256SUM="$(which gsha256sum)"
  TERRAFORM_LS_CHECKSUM=6248cdf24cf0d37fff13826012a4677b3c95f1c12e2c77f2a6bcd5e9dafb83a3
  TERRAFORM_LS_URL="https://github.com/hashicorp/terraform-ls/releases/download/v${TERRAFORM_LS_VERSION}/terraform-ls_${TERRAFORM_LS_VERSION}_darwin_amd64.zip"
else
  SHA256SUM="$(which sha256sum)"
  TERRAFORM_LS_CHECKSUM=9dd5de3030ac2d80b9465987b5294dfc18b2846bc89c12a9d95ed0ed21761ed8
  TERRAFORM_LS_URL="https://github.com/hashicorp/terraform-ls/releases/download/v${TERRAFORM_LS_VERSION}/terraform-ls_${TERRAFORM_LS_VERSION}_linux_amd64.zip"
fi

function cleanup {
  if [ -d "${TERRAFORM_LS_DOWNLOAD_DIR}" ]; then
    rm -rf "${TERRAFORM_LS_DOWNLOAD_DIR}"
  fi
}
trap cleanup EXIT


if ! command -v terraform-ls >/dev/null 2>&1 \
  || [ "$(terraform-ls --version 2>&1)" != "${TERRAFORM_LS_VERSION}" ]; then

  TERRAFORM_LS_DOWNLOAD_DIR="$(mktemp -d)"
  (curl -fsSL "${TERRAFORM_LS_URL}" -o "${TERRAFORM_LS_DOWNLOAD_DIR}/terraform-ls.zip" \
    && cd "${TERRAFORM_LS_DOWNLOAD_DIR}" \
    && echo "${TERRAFORM_LS_CHECKSUM} *terraform-ls.zip" | $SHA256SUM -c - \
    && unzip terraform-ls.zip \
    && mv "${TERRAFORM_LS_DOWNLOAD_DIR}/terraform-ls" "${HOME}/bin/terraform-ls")
fi

#!/usr/bin/env bash

set -e

TERRAFORM_LS_VERSION=0.19.0

if [ "$(uname)" = "Darwin" ]; then
  SHA256SUM="$(which gsha256sum)"
  TERRAFORM_LS_CHECKSUM=6b598604cf45b5df883e6151937b7bc4938b00330ccf1945d5077dbacde580af
  TERRAFORM_LS_URL="https://github.com/hashicorp/terraform-ls/releases/download/v${TERRAFORM_LS_VERSION}/terraform-ls_${TERRAFORM_LS_VERSION}_darwin_amd64.zip"
else
  SHA256SUM="$(which sha256sum)"
  TERRAFORM_LS_CHECKSUM=cc320ba1f3cb4d2fcbae8a0d7d5ec679c0e8521ea655a3212eeb755386ac9a27
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

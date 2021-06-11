#!/usr/bin/env bash

set -e

TERRAFORM_LS_VERSION=0.18.0

if [ "$(uname)" = "Darwin" ]; then
  SHA256SUM="$(which gsha256sum)"
  TERRAFORM_LS_CHECKSUM=0c68ce725f2a5904f349bdf621baa9f9ca46cd3d4f9fdc22c2b319eaa5f547cf
  TERRAFORM_LS_URL="https://github.com/hashicorp/terraform-ls/releases/download/v${TERRAFORM_LS_VERSION}/terraform-ls_${TERRAFORM_LS_VERSION}_darwin_amd64.zip"
else
  SHA256SUM="$(which sha256sum)"
  TERRAFORM_LS_CHECKSUM=1aa74ceaff310bb0e0fb5ba79dc0b66cf8019899d9fffee315113bbd13798448
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

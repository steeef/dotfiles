#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

while read -r p; do
  code --install-extension "${p}"
done < "${DIR}/../code/extensions"
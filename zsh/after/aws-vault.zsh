export AWS_VAULT_KEYCHAIN_NAME=login
export AWS_VAULT_PROMPT=ykman

function awslogin() {
  url="$(aws-vault login --duration=8h --no-session ${1} --stdout)"
  if [[ ${url} =~ ^https://.* ]]; then
    nohup /Applications/Firefox.app/Contents/MacOS/firefox \
      -no-remote  -foreground \
      -profile "${HOME}/Library/Application Support/Firefox/Profiles/aws_${1}" \
      -P "aws_${1}" \
      -new-window "${url}" >/dev/null 2>&1 &
  else
    echo "ERROR: ${url}"
  fi
}
alias avl='awslogin'
alias ave='aws-vault exec'

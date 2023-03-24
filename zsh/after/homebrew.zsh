# for some reason Homebrew's `brew upgrade --cask` will not upgrade outdated
# casks unless the `--greedy` flag is included. However, that also lists any
# cask with version = "latest", which we don't want to upgrade, since they
# would be upgraded everytime `brew upgrade --cask --greedy` is called. Use
# this function instead to only upgrade outdated casks with version set.
function upgrade_versioned_casks() {
  outdated_casks="$(brew outdated --cask --greedy | awk '{print $1}')"
  unversioned_casks="$(brew list --cask --versions | grep -w 'latest' \
    | awk '{print $1}' | tr '\n' ' ')"

  if [ -n "${outdated_casks}" ]; then
    echo "brew: upgrading casks:"
    echo "${outdated_casks}"
    while read -r cask; do
      if ! [[ ${unversioned_casks} =~ ${cask} ]]; then
        brew upgrade --cask "${cask}"
      fi
    done <<< "${outdated_casks}"
  fi
}
alias bup='brew update; brew upgrade; upgrade_versioned_casks'
alias bclean='brew cleanup'

# tw <repo> - clone/fetch a tatari-tv repo into ~/code/work and cd into it.
# A shell function (not a script) so the `cd` lands in your actual shell.

_tw_refresh_cache() {
  local cache_file="$1"
  mkdir -p "${cache_file:h}"
  gh repo list tatari-tv --limit 1000 --no-archived --json name -q '.[].name' | sort >"${cache_file}.new" &&
    mv "${cache_file}.new" "${cache_file}" || {
    echo "tw: failed to refresh repo list from gh" >&2
    return 1
  }
}

_tw_list_repos() {
  local cache_file="${HOME}/.cache/tatari-work-repos"
  if [[ ! -f "${cache_file}" ]] || [[ -n "$(find "${cache_file}" -mtime +0 2>/dev/null)" ]]; then
    _tw_refresh_cache "${cache_file}" || return 1
  fi
  cat "${cache_file}"
}

_tw_launch_repo() {
  local repo="$1"
  if [[ ! "${repo}" =~ ^[A-Za-z0-9._-]+$ ]]; then
    echo "tw: invalid repo name '${repo}'" >&2
    return 1
  fi

  local work_dir="${HOME}/code/work"
  mkdir -p "${work_dir}" || return 1
  local target="${work_dir}/${repo}"
  local already_existed=0

  if [[ -d "${target}" ]]; then
    already_existed=1
    local origin_url
    origin_url="$(git -C "${target}" remote get-url origin 2>/dev/null)"
    if [[ "${origin_url}" != *"tatari-tv/${repo}" && "${origin_url}" != *"tatari-tv/${repo}.git" ]]; then
      echo "tw: ${target} exists but its origin ('${origin_url}') doesn't match tatari-tv/${repo}" >&2
      return 1
    fi
  else
    gh repo clone "tatari-tv/${repo}" "${target}" || return 1
  fi

  cd "${target}" || return 1

  if [[ "${already_existed}" -eq 1 ]]; then
    git fetch origin --prune || return 1

    local default_branch
    default_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null)"
    if [[ -z "${default_branch}" ]]; then
      # origin/HEAD is normally set at clone time; only re-detect it (an
      # extra round-trip to the remote) if it's somehow missing.
      git remote set-head origin -a >/dev/null 2>&1
      default_branch="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null)"
    fi
    default_branch="${default_branch#refs/remotes/origin/}"
    default_branch="${default_branch:-main}"

    # gcl()-style checkout: a no-op if already on default_branch, and git
    # refuses on conflicting local changes — no separate dirty-tree check.
    if git checkout "${default_branch}"; then
      # merge, not pull — avoids fetching a second time (already fetched above).
      if ! git merge --ff-only "origin/${default_branch}"; then
        echo "tw: ${repo} has diverged from origin/${default_branch}; left as-is" >&2
      fi
    else
      echo "tw: couldn't switch ${repo} to ${default_branch}; left as-is" >&2
    fi
  fi

  if ! aws sts get-caller-identity >/dev/null 2>&1; then
    aws sso login || return 1
  fi
}

tw() {
  case "${1:-}" in
  --list-repos)
    _tw_list_repos
    ;;
  "")
    local repo
    repo="$(_tw_list_repos | fzf --prompt="tw> ")"
    [[ -n "${repo}" ]] || return 1
    _tw_launch_repo "${repo}"
    ;;
  *)
    _tw_launch_repo "$1"
    ;;
  esac
}

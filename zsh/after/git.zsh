# fbr - checkout git branch (local + remote), sorted by most recent commit
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=50 --sort=-committerdate \
    refs/heads/ refs/remotes/ \
    --format="%(refname:short)" | grep -v 'HEAD') &&
  branch=$(echo "${branches}" |
    fzf -d $((2 + $(wc -l <<<"${branches}"))) +m) &&
  git checkout $(echo "${branch}" | sed "s/.* //" | sed "s#[^/]*/##")
}

# gcl: git-cleanup-remote-and-local-branches
#
# Cleaning up remote and local branches:
# 1. Prune remote branches when they are deleted or merged
# 2. Remove local branches that are merged into main
# 3. Remove local branches whose remote tracking branch is gone

function git_prune_remote() {
  git fetch --prune
}

function git_remove_merged_local_branch() {
  git branch --merged | grep -Ev "(^\*|master|main|staging)" | sed 's/^[+ ]*//' | while read branch; do
    worktree=$(git worktree list | grep "\[$branch\]" | awk '{print $1}')
    if [[ -n "$worktree" ]]; then
      git worktree remove "$worktree" 2>/dev/null || { echo "Could not remove worktree for $branch, skipping" >&2; continue; }
    fi
    git branch -d "$branch"
  done
}

# Remove local branches whose remote tracking branch no longer exists
# (i.e., branches that were merged and deleted on the remote)
function git_remove_orphaned_local_branches() {
  git branch -vv | grep ': gone]' | awk '{if ($1 == "+" || $1 == "*") print $2; else print $1}' | while read branch; do
    worktree=$(git worktree list | grep "\[$branch\]" | awk '{print $1}')
    if [[ -n "$worktree" ]]; then
      git worktree remove "$worktree" 2>/dev/null || { echo "Could not remove worktree for $branch, skipping" >&2; continue; }
    fi
    git branch -D "$branch"
  done
}

# Clean up remote and local branches
function gcl() {
  local default_branch
  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null) || default_branch="refs/remotes/origin/main"
  default_branch=${default_branch#refs/remotes/origin/}
  git checkout "$default_branch" || return 1
  git pull || return 1
  git_prune_remote
  git worktree prune
  git_remove_merged_local_branch
  git_remove_orphaned_local_branches
}

# gsummary - codebase health diagnostic (churn, bus factor, bug clusters, crisis commits, timeline)
function gsummary() {
  echo "\n=== Churn Hotspots (last year) ==="
  git log --format=format: --name-only --since="1 year ago" | grep -v '^$' | sort | uniq -c | sort -nr | head -20

  echo "\n=== Bus Factor (all time) ==="
  git shortlog -sn --no-merges | head -20

  echo "\n=== Recent Contributors (6 months) ==="
  git shortlog -sn --no-merges --since="6 months ago" | head -10

  echo "\n=== Bug Hotspots ==="
  git log -i -E --grep="fix|bug|broken" --name-only --format='' | grep -v '^$' | sort | uniq -c | sort -nr | head -20

  echo "\n=== Crisis Commits (reverts/hotfixes) ==="
  git log --oneline --since="1 year ago" | grep -iE 'revert|hotfix|emergency|rollback' || echo "(none)"

  echo "\n=== Activity Timeline ==="
  git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c
}

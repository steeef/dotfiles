# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "${branches}" |
      fzf -d $((2 + $(wc -l <<<"${branches}"))) +m) &&
    git checkout $(echo "${branch}" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
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
      git worktree remove "$worktree" || { echo "Failed to remove worktree for $branch, skipping" >&2; continue; }
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
      git worktree remove "$worktree" || { echo "Worktree for $branch has changes, skipping" >&2; continue; }
    fi
    git branch -D "$branch"
  done
}

# Clean up remote and local branches
function gcl() {
  (git checkout main && git pull)
  git_prune_remote
  git worktree prune
  git_remove_merged_local_branch
  git_remove_orphaned_local_branches
}

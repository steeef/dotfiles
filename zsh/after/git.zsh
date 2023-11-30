# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "${branches}" |
      fzf -d $((2 + $(wc -l <<<"${branches}"))) +m) &&
    git checkout $(echo "${branch}" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# https://blog.takanabe.tokyo/en/2020/04/remove-squash-merged-local-git-branches/
#
# gcl: git-cleanup-remote-and-local-branches
#
# Cleaning up remote and local branch is delivered as follows:
# 1. Prune remote branches when they are deleted or merged
# 2. Remove local branches when their remote branches are removed
# 3. Remove local branches when a main included squash and merge commits

function git_prune_remote() {
  git fetch --prune
}

function git_remove_merged_local_branch() {
  git branch --merged | egrep -v "(^\*|master|main|staging)" | xargs -I % git branch -d %
}

# When we use `Squash and merge` on GitHub,
# `git branch --merged` cannot detect the squash-merged branches.
# As a result, git_remove_merged_local_branch() cannot clean up
# unused local branches. This function detects and removes local branches
# when remote branches are squash-merged.
#
# There is an edge case. If you add suggested commits on GitHub,
# the contents in local and remote are different. As a result,
# This clean up function cannot remove local squash-merged branch.
function git_remove_squash_merged_local_branch() {
  git checkout -q main &&
    git for-each-ref refs/heads/ "--format=%(refname:short)" |
    while read branch; do
      ancestor=$(git merge-base main $branch) &&
        [[ $(git cherry main $(git commit-tree $(git rev-parse $branch^{tree}) -p $ancestor -m _)) == "-"* ]] &&
        git branch -D $branch
    done
}

# Clean up remote and local branches
function gcl() {
  git pull origin main
  git_prune_remote
  git_remove_merged_local_branch
  git_remove_squash_merged_local_branch
}

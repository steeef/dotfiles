#!/usr/bin/env bash
set -euo pipefail

S="$(cd "$(dirname "$0")" && pwd)/sync_ticket_thoughts.sh"
T="$(mktemp -d)"
cd "$T"
git init -q --bare r.git
git clone -q r.git w 2>/dev/null
cd w
mkdir -p p
for f in T-1-plan T-10-plan T-2-plan; do echo a >"p/$f.md"; done
git add p
git commit -qm init
git push -q origin HEAD

echo x >>p/T-1-plan.md
echo y >>p/T-10-plan.md
echo n >p/T-1-new.md
mv p/T-2-plan.md "$T/"

"$S" p T-1 "t1" >/dev/null 2>&1
[ "$(git log -1 --format=%s)" = t1 ]
[ "$(git show --name-only --format= HEAD | sort | tr '\n' ' ')" = "p/T-1-new.md p/T-1-plan.md " ]
[ "$(git status --short | sort | tr '\n' ' ')" = " D p/T-2-plan.md  M p/T-10-plan.md " ]

"$S" p NOPE-9 "x" | grep -q "No changed files"
[ "$(git log -1 --format=%s)" = t1 ]

"$S" p T-2 "t2" >/dev/null 2>&1
git show --name-status --format= HEAD | grep -q "^D.*T-2-plan.md"

echo PASS

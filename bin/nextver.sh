#! /bin/bash

step="${1:-patch}"

base="$2"
if [ -z "$base" ]; then
  base=$(git tag --sort v:refname 2>/dev/null | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | tail -n 1)
  if [ -z "$base" ]; then
    base=0.0.0
  fi
fi

if [[ "$base" =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
  MAJOR="${BASH_REMATCH[1]}"
  MINOR="${BASH_REMATCH[2]}"
  PATCH="${BASH_REMATCH[3]}"
fi

case "$step" in
  major)
    ((MAJOR += 1))
    ((MINOR = 0))
    ((PATCH = 0))
    ;;
  minor)
    ((MINOR += 1))
    ((PATCH = 0))
    ;;
  patch)
    ((PATCH += 1))
    ;;
esac

echo "v$MAJOR.$MINOR.$PATCH"

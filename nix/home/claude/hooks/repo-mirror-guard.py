#!/usr/bin/env python3
import json
import os
import re
import shlex
import subprocess
import sys

REPO_MIRROR = os.path.expanduser("~/.bin/repo-mirror")
SLUG = re.compile(r"^/?repos/([\w.-]+/[\w.-]+)")
REPO_FLAG = re.compile(r"repo:([\w.-]+/[\w.-]+)")


def _tokens(command):
    try:
        return shlex.split(command)
    except ValueError:
        return command.split()


def _is_gh(token):
    return os.path.basename(token) == "gh"


def _repo_slugs_from_search(tokens):
    slugs = []
    for i, token in enumerate(tokens):
        if token in ("--repo", "-R") and i + 1 < len(tokens):
            slugs.append(tokens[i + 1])
        elif token.startswith("--repo="):
            slugs.append(token.split("=", 1)[1])
        else:
            match = REPO_FLAG.search(token)
            if match:
                slugs.append(match.group(1))
    return slugs


def _graphql_owner_name(tokens):
    owner = name = None
    for i, token in enumerate(tokens):
        if token == "-F" and i + 1 < len(tokens):
            key, _, value = tokens[i + 1].partition("=")
            if key == "owner":
                owner = value
            elif key == "name":
                name = value
    return f"{owner}/{name}" if owner and name else None


def extract_slugs(command):
    tokens = _tokens(command)
    if not any(_is_gh(t) for t in tokens):
        return []

    if "api" in tokens:
        for token in tokens:
            match = SLUG.match(token)
            if match:
                return [match.group(1)]
        if "graphql" in tokens:
            slug = _graphql_owner_name(tokens)
            if slug:
                return [slug]

    if any(a == "search" and b == "code" for a, b in zip(tokens, tokens[1:])):
        return _repo_slugs_from_search(tokens)

    return []


def mirrored_path(slug):
    try:
        result = subprocess.run([REPO_MIRROR, "path", slug], capture_output=True, text=True, timeout=2)
    except Exception:
        return None
    path = result.stdout.strip()
    if path and os.path.isdir(os.path.join(path, ".git")):
        return path
    return None


if __name__ == "__main__":
    data = json.load(sys.stdin)

    if data.get("tool_name") != "Bash":
        print(json.dumps({"decision": "approve"}))
        sys.exit(0)

    command = data.get("tool_input", {}).get("command", "")
    blocked = None
    for slug in dict.fromkeys(extract_slugs(command)):
        path = mirrored_path(slug)
        if path:
            blocked = (slug, path)
            break

    if blocked:
        slug, path = blocked
        reason = (
            f"{slug} has a local mirror at {path} - read from there instead "
            f"(e.g. `git -C {path} grep ...`). Run `~/.bin/repo-mirror sync {slug}` "
            f"if it looks stale, or delete {path} to remove the mirror and lift this block."
        )
        print(json.dumps({"decision": "block", "reason": reason}))
    else:
        print(json.dumps({"decision": "approve"}))

    sys.exit(0)

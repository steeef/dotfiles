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
GRAPHQL_OWNER_NAME = re.compile(r'owner:\s*"([\w.-]+)".*?name:\s*"([\w.-]+)"', re.DOTALL)


def _tokens(command):
    try:
        return shlex.split(command)
    except ValueError:
        return command.split()


def extract_slug(command):
    tokens = _tokens(command)
    if "gh" not in tokens:
        return None

    if "api" in tokens:
        for token in tokens:
            match = SLUG.match(token)
            if match:
                return match.group(1)
        match = GRAPHQL_OWNER_NAME.search(command)
        if match:
            return f"{match.group(1)}/{match.group(2)}"

    if "search" in tokens and "code" in tokens:
        for i, token in enumerate(tokens):
            if token in ("--repo", "-R") and i + 1 < len(tokens):
                return tokens[i + 1]
            if token.startswith("--repo="):
                return token.split("=", 1)[1]
            match = REPO_FLAG.search(token)
            if match:
                return match.group(1)

    return None


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
    slug = extract_slug(command)
    path = mirrored_path(slug) if slug else None

    if path:
        reason = (
            f"{slug} has a local mirror at {path} - read from there instead "
            f"(e.g. `git -C {path} grep ...`). Run `~/.bin/repo-mirror sync {slug}` "
            f"if it looks stale, or delete {path} to remove the mirror and lift this block."
        )
        print(json.dumps({"decision": "block", "reason": reason}))
    else:
        print(json.dumps({"decision": "approve"}))

    sys.exit(0)

host := `hostname -s`
hm := "path:" + justfile_directory() + "#" + env("USER") + "@" + host

default:
    @just --list

# home-manager switch (replaces `hms`)
switch:
    home-manager switch --flake {{hm}}

# nix-darwin switch (replaces `dr`)
[macos]
darwin:
    sudo darwin-rebuild switch --flake {{justfile_directory()}}

# build without activating
build:
    home-manager build --flake {{hm}}

# every declared host must evaluate
check:
    nix flake check

# changed files only; hooks rewrite in place
lint *files=`git ls-files -m -o --exclude-standard | tr '\n' ' '`:
    if command -v prek >/dev/null; then prek run --files {{files}}; else pre-commit run --files {{files}}; fi

fmt:
    alejandra .
    statix fix

# lock bump only
update:
    nix flake update

# brew + flake update + switch
update-all:
    bin/update.sh

pi-outdated:
    bin/pi-box --outdated

pi-box *args:
    bin/pi-box {{args}}

# list claude skill names
skills:
    @ls -1 nix/home/claude/skills

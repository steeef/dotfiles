# Config placement preference

- For configs that point to or contain credentials (API keys, service account paths, tool-specific .env files), write them directly to their conventional location (e.g. `~/.gemini/.env`, `~/.config/<tool>/...`) rather than embedding the values inside `nix/home/*.nix` home-manager modules.
- Why: keeps creds-pointing content out of the dotfiles repo. Nix modules are for tool installs and stable, non-secret config; declarative management of creds-adjacent config is over-engineering here.
- How to apply: when setting up auth for a CLI tool (gemini, codex, etc.) that supports a native dotfile/env-file convention, write that file directly and leave nix/home-manager to handle only the package install. Don't wrap auth env vars in `home.file."...".text` or `home.sessionVariables` unless asked.

# UnifiOS persistence

- On UnifiOS (Unifi Cloud Gateway), `/etc/systemd/system/` is not persistent — it gets overwritten on reboot or firmware updates.
- How to apply: any custom systemd units or startup logic must be placed in `/data/on_boot.d/` as shell scripts. Scripts there run on every boot, so they should (re)create unit files and run `systemctl daemon-reload && systemctl enable --now <unit>`.

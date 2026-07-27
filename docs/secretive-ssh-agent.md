# Secretive SSH Agent

`sp` (this Mac) uses [Secretive](https://github.com/maxgoedjen/secretive) to
back SSH auth and git commit signing with the Secure Enclave, running
**additively** alongside 1Password's SSH agent — nothing was removed from
1Password, this is a parallel identity being evaluated before any cutover.
A YubiKey is the planned next phase (ed25519 support, cross-machine reuse);
Secretive was chosen first because it needed no new hardware.

No key material — public or private — lives in this repo. Secure Enclave
keys are hardware-bound to this specific Mac (non-exportable, no iCloud
sync), and this repo is published publicly, so all `.pub` files and
`allowed_signers` are created and kept locally under `~/.ssh/`, outside git,
the same way `~/.ssh/config` itself has always been handled here. The nix
modules below only ever reference *paths*, never key contents.

## What's nix-managed

- `nix/darwin/default.nix` — the `secretive` Homebrew cask, scoped to
  `machine == "sp"` only (other machines aren't opted in yet).
- `nix/home/git/default.nix` — `programs.git.signing` set to
  `format = "ssh"` with `key` pointing at a local pubkey path
  (`~/.ssh/id_secretive_git_sign.pub`), plus a small wrapper script
  (`pkgs.writeShellScript`) that pins `SSH_AUTH_SOCK` to Secretive's agent
  socket just for the signing operation — the global `SSH_AUTH_SOCK`
  (`nix/home/zsh/initExtra.zsh`) still points at 1Password for everything
  else.

## What's local-only (not in this repo)

- `~/.ssh/config` — per-host `Host` blocks scoping specific hosts to
  Secretive's `IdentityAgent`
  (`~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh`),
  placed above the 1Password-backed catch-all `Host *` block so everything
  else is unaffected.
- Every `~/.ssh/*.pub` file Secretive's keys are exported to.
- `~/.ssh/allowed_signers`, used for local `git log --show-signature`
  verification.

## Key-to-host mapping

Each key is a separate Secure Enclave identity (ECDSA P-256 — the only type
the Secure Enclave supports), named by purpose:

| Secretive key | Used for |
| --- | --- |
| `github` | GitHub SSH auth — registered on GitHub, but `github.com` still routes through 1Password by default in `~/.ssh/config`; this key is proven working, not yet the default path. |
| `git-sign` | Git commit/tag signing — this one *is* the default now (`programs.git.signing`). |
| `steeef.net` | `goto`, `avi`, `epiphyte`, `vid` (the Docker hosts in `~/code/infra`). |
| `IoT` | `powerpi` only — `dns-iot`/`dns-guest` were decommissioned. |

`ubnt` and `git.steeef.net` (self-hosted Forgejo) are untouched, still on
1Password's `steeef.net` key.

## Adding another machine

Secure Enclave keys can't be exported or synced, so a second Mac needs its
own set generated locally in Secretive — the shared nix config doesn't need
to change, since it only references local paths (e.g.
`~/.ssh/id_secretive_git_sign.pub`), and each machine's Secretive-generated
key just needs to land at that same path. Separately: register the new
machine's `github`/`git-sign` keys as *additional* Authentication/Signing
keys on GitHub (GitHub allows multiple valid keys per account, no reason to
replace), append its `steeef.net`/`IoT` keys to the relevant hosts'
`authorized_keys`, and copy the `~/.ssh/config` `Host` blocks over by hand.

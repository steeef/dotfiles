# Secretive SSH Agent

`sp` and `ltm-3914` use [Secretive](https://github.com/maxgoedjen/secretive)
to back SSH auth and git commit signing with the Secure Enclave. Secretive is
now the **default** SSH agent on both machines (`SSH_AUTH_SOCK` in
`nix/home/zsh/initExtra.zsh`, and the catch-all `Host *` block in each
machine's local `~/.ssh/config`); 1Password stays installed for password
management and continues to back two explicit exceptions — see
"Key-to-host mapping" below. A YubiKey is the planned next phase (ed25519
support, cross-machine reuse); Secretive was chosen first because it needed
no new hardware.

No key material — public or private — lives in this repo. Secure Enclave
keys are hardware-bound to this specific Mac (non-exportable, no iCloud
sync), and this repo is published publicly, so all `.pub` files and
`allowed_signers` are created and kept locally under `~/.ssh/`, outside git,
the same way `~/.ssh/config` itself has always been handled here. The nix
modules below only ever reference *paths*, never key contents.

## What's nix-managed

- `nix/darwin/default.nix` — the `secretive` Homebrew cask, scoped to
  `machine == "sp"` or `"ltm-3914"` (other machines aren't opted in yet; see
  "Adding another machine" below).
- `nix/home/git/default.nix` — `programs.git.signing` set to
  `format = "ssh"` with `key` pointing at a local pubkey path
  (`~/.ssh/id_secretive_git_sign_personal.pub`, the default/personal
  identity), plus a small wrapper script (`pkgs.writeShellScript`) that pins
  `SSH_AUTH_SOCK` to Secretive's agent socket for the signing operation. The
  work identity override (`~/.gitconfig-work`, loaded via `gitdir:~/code/work/`)
  uses the separate `git-sign` key instead, signed with plain `ssh-keygen`
  (works now that `SSH_AUTH_SOCK` defaults to Secretive globally — no wrapper
  needed there).
- `nix/home/zsh/initExtra.zsh` — the global `SSH_AUTH_SOCK` on Darwin now
  points at Secretive's agent socket by default (shared across every Mac,
  not machine-gated).

## What's local-only (not in this repo)

- `~/.ssh/config` — `Host` blocks for `ubnt` and `git.steeef.net` pin
  `IdentityAgent` to 1Password's socket (the two exceptions); the catch-all
  `Host *` block's `IdentityAgent` points at Secretive's socket
  (`~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh`),
  making it the default for everything else. Each machine's `~/.ssh/config`
  is independent — there's no shared file to sync.
- Every `~/.ssh/*.pub` file Secretive's keys are exported to.
- `~/.ssh/allowed_signers`, used for local `git log --show-signature`
  verification.
- `~/.gitconfig-work` — the work-identity `user.signingkey` (path to
  `~/.ssh/id_secretive_git_sign.pub`) and `gpg.ssh.program` (`ssh-keygen`).
  This file predates Secretive and used to hardcode a 1Password key plus
  1Password's `op-ssh-sign` binary; both were migrated here as part of the
  cutover.

## Key-to-host mapping

Secure Enclave keys are non-exportable and machine-bound, so `sp` and
`ltm-3914` each generated their own independent set of keys in Secretive —
same names and purposes, different underlying key material per machine.
Each key is a separate Secure Enclave identity (ECDSA P-256 — the only type
the Secure Enclave supports), named by purpose:

| Secretive key | Used for |
| --- | --- |
| `github` | Personal GitHub SSH auth (`steeef` account) — `IdentityFile` on the `personal-github` `Host` block; registered as an additional Authentication key on the personal GitHub account. |
| `github-tatari` | Work GitHub SSH auth (`stephen-tatari` account) — `IdentityFile` on the `github.com`/`gist.github.com`/`tatari.github.com`/`tatari.gist.github.com` `Host` block; registered as an additional Authentication key on the work GitHub account. |
| `git-sign-personal` | Git commit/tag signing for the default/personal identity — `programs.git.signing.key`, registered as a Signing Key on `steeef`. |
| `git-sign` | Git commit/tag signing for the work identity (via `~/.gitconfig-work`) — registered as a Signing Key on `stephen-tatari`. |
| `steeef.net` | `goto`, `avi`, `epiphyte`, `vid` (the Docker hosts in `~/code/infra`). |
| `IoT` | `powerpi` only — `dns-iot`/`dns-guest` were decommissioned. |

GitHub public keys are globally unique across accounts — the same key can't
be registered as a Signing Key (or Authentication key) on two different
accounts, which is why personal and work identities each need their own
`git-sign*`/`github*` key rather than sharing one.

Both GitHub `Host` blocks keep their own `IdentityFile` (so the right
account's key is offered), while `IdentityAgent` comes from whichever
`Host` block matches — the catch-all for everything except the two
exceptions below.

`ubnt` and `git.steeef.net` (self-hosted Forgejo) are untouched, still on
1Password's `steeef.net` key.

## Adding another machine

Secure Enclave keys can't be exported or synced, so a new Mac needs its own
set generated locally in Secretive, at the same local paths the nix config
already references (e.g. `~/.ssh/id_secretive_git_sign_personal.pub`) — but
unlike the rest of the setup, the `secretive` Homebrew cask is gated by an
explicit machine allowlist in `nix/darwin/default.nix`, so add the new
machine name there first. Separately: register the new machine's
`github`/`github-tatari`/`git-sign-personal` keys as *additional*
Authentication/Signing keys on the matching GitHub account (one key per
account — see the uniqueness note above), register `git-sign` as a Signing
Key on the work account and point `~/.gitconfig-work`'s `user.signingkey` at
it, append `steeef.net`/`IoT` keys to the relevant hosts' `authorized_keys`,
and copy the `~/.ssh/config` `Host` blocks over by hand.

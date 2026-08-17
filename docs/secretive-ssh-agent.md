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
  (`~/.ssh/id_secretive_git_sign_steeef.pub`, the default/personal
  identity), plus a small wrapper script (`pkgs.writeShellScript`) that pins
  `SSH_AUTH_SOCK` to Secretive's agent socket for the signing operation. The
  work identity override (`~/.gitconfig-work`, loaded via `gitdir:~/code/work/`)
  uses the separate `git-sign-tatari` key instead, signed with plain
  `ssh-keygen` (works now that `SSH_AUTH_SOCK` defaults to Secretive globally
  — no wrapper needed there).
- `nix/home/zsh/initExtra.zsh` — the global `SSH_AUTH_SOCK` on Darwin now
  points at Secretive's agent socket by default (shared across every Mac,
  not machine-gated).

## What's local-only (not in this repo)

- `~/.ssh/config` — the `Host ubnt` block pins `IdentityAgent` to 1Password's
  socket (the one remaining exception); the catch-all `Host *` block's
  `IdentityAgent` points at Secretive's socket
  (`~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh`),
  making it the default for everything else. Each machine's `~/.ssh/config`
  is independent — there's no shared file to sync.
- Every `~/.ssh/*.pub` file Secretive's keys are exported to.
- `~/.ssh/allowed_signers`, used for local `git log --show-signature`
  verification.
- `~/.gitconfig-work` — the work-identity `user.signingkey` (path to
  `~/.ssh/id_secretive_git_sign_tatari.pub`) and `gpg.ssh.program`
  (`ssh-keygen`). This file predates Secretive and used to hardcode a
  1Password key plus 1Password's `op-ssh-sign` binary; both were migrated
  here as part of the cutover.

## HTTPS fetch/clone doesn't need Secretive

`nix/home/git/default.nix`'s `url."git@github.com:".pushInsteadOf =
"https://github.com/"` only rewrites **pushes** to SSH; fetch/clone/pull of an
`https://github.com/...` URL stays plain HTTPS and never touches Secretive.
This used to be a blanket `insteadOf`, which silently rewrote *every*
`https://github.com/` operation (including Homebrew's internal tap fetches
during `brew update`) to SSH. Homebrew updates several taps back-to-back, each
triggering a Secretive Touch ID prompt — and Secretive can only show one
prompt at a time, so all but the first request are rejected outright
("agent refused operation"), a known unfixed upstream bug
([secretive#776](https://github.com/maxgoedjen/secretive/issues/776),
[secretive#532](https://github.com/maxgoedjen/secretive/issues/532)). Scoping
the rewrite to pushes only avoids triggering Secretive for reads that never
needed authentication in the first place. Tradeoff: cloning a *private* repo
via a literal `https://github.com/...` URL (instead of `git@github.com:...`
or `gh repo clone`) now attempts real HTTPS auth, which will fail since no
GitHub PAT is stored in the macOS keychain — use the SSH form instead.

## Touch ID prompt frequency

Commit/tag signing calls `ssh-keygen -Y sign` directly against Secretive's
agent socket (`SSH_AUTH_SOCK`) — a local call, not a network connection, so
`~/.ssh/config`'s `ControlMaster`/`ControlPath`/`ControlPersist` (SSH
connection multiplexing to remote hosts) never enters the picture and can't
affect how often Touch ID fires. Prompt frequency is governed entirely by
Secretive's own per-key **Protection Level**, set when the key is created and
not editable afterward ([secretive#572](https://github.com/maxgoedjen/secretive/issues/572)):
`Require Authentication` gates every use behind Touch ID, `Notify` allows the
operation immediately and just posts a notification. `git-sign-tatari` and
`git-sign-steeef` are both set to `Notify` for exactly this reason — commit
signing happens often enough that per-signature Touch ID was disruptive.
Auth keys (`github`, `github-tatari`, etc.) are left on `Require`. Changing
an existing key's level isn't possible; it means creating a replacement key,
re-registering it as a GitHub Signing Key, and updating
`~/.ssh/allowed_signers`/the nix `signing.key` path (or `~/.gitconfig-work`
for the work identity).

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
| `git-sign-steeef` | Git commit/tag signing for the default/personal identity — `programs.git.signing.key`, registered as a Signing Key on `steeef` (GitHub) and on `git.steeef.net` (Forgejo). Protection Level `Notify`. |
| `git-sign-tatari` | Git commit/tag signing for the work identity (via `~/.gitconfig-work`) — registered as a Signing Key on `stephen-tatari`. Protection Level `Notify`. |
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

`ubnt` is untouched, still on 1Password's `steeef.net` key. `git.steeef.net`
(self-hosted Forgejo) now uses Secretive for both auth (the same
`steeef.net` key already used for the `goto`/`avi`/`epiphyte`/`vid` Docker
hosts) and signature verification (`git-sign-steeef`).

## Adding another machine

Secure Enclave keys can't be exported or synced, so a new Mac needs its own
set generated locally in Secretive, at the same local paths the nix config
already references (e.g. `~/.ssh/id_secretive_git_sign_steeef.pub`) — but
unlike the rest of the setup, the `secretive` Homebrew cask is gated by an
explicit machine allowlist in `nix/darwin/default.nix`, so add the new
machine name there first. The two signing keys (`git-sign-steeef`,
`git-sign-tatari`) should be created with Protection Level `Notify`; the rest
default to `Require`. Separately: register the new machine's
`github`/`github-tatari`/`git-sign-steeef` keys as *additional*
Authentication/Signing keys on the matching GitHub account (one key per
account — see the uniqueness note above), register `git-sign-tatari` as a
Signing Key on the work account and point `~/.gitconfig-work`'s
`user.signingkey` at it, append `steeef.net`/`IoT` keys to the relevant
hosts' `authorized_keys`, and copy the `~/.ssh/config` `Host` blocks over by
hand.

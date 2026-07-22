---
paths:
  - "flake.nix"
  - "flake.lock"
  - "nix/**/*"
---

# Nix system management

- `hms` — Home Manager switch (`home-manager switch --flake $HOME/.dotfiles#$USER@$(hostname)`).
- `dr` — Darwin system switch (`sudo darwin-rebuild switch --flake $HOME/.dotfiles`).

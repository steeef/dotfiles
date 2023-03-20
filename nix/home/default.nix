{ lib, pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # get some paths on Linux set
  targets.genericLinux.enable = if pkgs.stdenv.isDarwin then false else true;

  home.packages = with pkgs; [
    bash
    bfs
    cowsay
    curl
    fasd
    coreutils
    findutils
    gnugrep
    gnused
    jq
    nil
    nixpkgs-fmt
    ponysay
    reattach-to-user-namespace
    rename
    ripgrep
    ssh-copy-id
    statix
    tree
    watch
    wget
  ];

  imports = [
    ./bat.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./neovim.nix
    ./tmux
    ./zsh
  ]
  ++ lib.optionals pkgs.stdenv.isDarwin [
    ./iterm2
  ];
}

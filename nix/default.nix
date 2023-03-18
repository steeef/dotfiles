{ pkgs, lib, ... }: {
  home.username = "sprice";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/sprice" else "/home/sprice";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";

  # get some paths on Linux set
  targets.genericLinux.enable = if pkgs.stdenv.isDarwin then false else true;

  home.packages = with pkgs; [
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
  ];
}

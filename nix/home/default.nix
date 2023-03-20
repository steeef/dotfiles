{ pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bash
    bfs
    cowsay
    curl
    fasd
    fd
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

{ config, pkgs, ... }: {
  home.username = "sprice";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/sprice" else "/home/sprice";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    bat
    bfs
    curl
    jq
    ripgrep
    tree
    watch
    wget
  ];
}

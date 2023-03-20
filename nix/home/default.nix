{ pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    actionlint
    awscli2
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
    marksman
    nil
    nixpkgs-fmt
    nodePackages.yaml-language-server
    ponysay
    rdiff-backup
    reattach-to-user-namespace
    rename
    ripgrep
    shellcheck
    shfmt
    sqlite
    ssh-copy-id
    statix
    sumneko-lua-language-server
    terraform-ls
    tflint
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
    ./symlinks.nix
    ./tmux
    ./zsh
  ];
}

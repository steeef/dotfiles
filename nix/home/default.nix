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
    kubectx
    marksman
    nil
    nixpkgs-fmt
    nodePackages.yaml-language-server
    ponysay
    postgresql
    rdiff-backup
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
    vault
    watch
    wget
    yubikey-manager
    yubikey-personalization
  ];

  imports = [
    ./bat.nix
    ./direnv.nix
    ./directories.nix
    ./editorconfig.nix
    ./fzf.nix
    ./gh.nix
    ./git
    ./neovim.nix
    ./nix-index.nix
    ./symlinks.nix
    ./tmux
    ./zsh
  ];
}

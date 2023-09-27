{ pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    _1password
    aws-vault
    awscli2
    bash
    bfs
    cowsay
    curl
    fasd
    fd
    go
    coreutils
    findutils
    gnugrep
    gnused
    hidapitester
    jq
    k9s
    kubectx
    kubectl
    kubernetes-helm
    kustomize
    lazygit
    ncdu
    nixpkgs-fmt
    ponysay
    postgresql
    rdiff-backup
    rename
    ripgrep
    sqlite
    ssh-copy-id
    stern
    terraform
    tree
    unzip
    vagrant
    vault
    vendir
    watch
    wget
    yq-go
    yt-dlp
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

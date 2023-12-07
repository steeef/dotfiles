{ pkgs, ... }: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # do not install fish
  programs.fish.enable = false;

  home.packages = with pkgs; [
    _1password
    aws-vault
    awscli2
    bash
    bfs
    coreutils
    cowsay
    curl
    fasd
    fd
    gcc
    gnumake
    go
    coreutils
    findutils
    gnugrep
    gnused
    granted
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
    rsnapshot
    rsync
    ruff
    sqlite
    ssh-copy-id
    stern
    stylua
    terraform
    tig
    tree
    tree-sitter
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
    ./ripgrep.nix
    ./rsnapshot.nix
    ./symlinks.nix
    ./tmux
    ./zsh
  ];
}


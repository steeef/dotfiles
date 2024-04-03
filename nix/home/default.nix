{pkgs, ...}: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };

  # do not install fish
  programs.fish = {
    enable = false;
    package = {};
  };

  home.packages = with pkgs; [
    _1password
    alejandra
    aws-vault
    awscli2
    bash
    bfs
    btop
    coreutils
    cowsay
    curl
    difftastic
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
    kind
    kubectx
    kubectl
    kubernetes-helm
    kustomize
    lazygit
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
    ./firefox
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

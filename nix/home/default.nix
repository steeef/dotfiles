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
    _1password-cli
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
    ffmpeg-headless
    findutils
    gnugrep
    gnused
    hidapitester
    jq
    kind
    kubectx
    kubectl
    kubernetes-helm
    kustomize
    lazygit
    nixpkgs-fmt
    nmap
    ponysay
    postgresql
    pyright
    rdiff-backup
    rename
    rsnapshot
    rsync
    ruff
    sox
    sqlite
    ssh-copy-id
    stern
    stylua
    tenv
    tflint
    tig
    tree
    tree-sitter
    unzip
    uv
    vendir
    watch
    wget
    yq-go
    yt-dlp
    #    yubikey-manager
    yubikey-personalization
  ];

  imports = [
    ./atuin.nix
    ./bat.nix
    ./direnv.nix
    ./directories.nix
    ./editorconfig.nix
    ./firefox
    ./fzf.nix
    ./gh.nix
    ./git
    ./granted.nix
    ./k9s
    ./neovim.nix
    ./nix-index.nix
    ./oh-my-posh
    ./ripgrep.nix
    ./rsnapshot.nix
    ./symlinks.nix
    ./tmux
    ./zsh
  ];
}

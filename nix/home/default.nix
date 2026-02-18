{pkgs, ...}: {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Environment variables for native compilation (psycopg2, etc.)
  home.sessionVariables = {
    LIBRARY_PATH = "${pkgs.openssl.out}/lib:${pkgs.postgresql.lib}/lib";
    C_INCLUDE_PATH = "${pkgs.openssl.dev}/include:${pkgs.postgresql.dev}/include";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
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
    cargo
    coreutils
    cowsay
    curl
    deadnix
    difftastic
    fd
    gcc
    gnumake
    go
    ffmpeg-headless
    findutils
    fnm
    gnugrep
    gnused
    hidapitester
    hugo
    jq
    kind
    kubectx
    kubectl
    kubernetes-helm
    kustomize
    lazygit
    libiconv
    nixpkgs-fmt
    nmap
    ponysay
    pipx
    prek
    postgresql
    postgresql.pg_config # pg_config for psycopg2 compilation
    postgresql.dev # headers for psycopg2 compilation
    python313
    pyright
    rdiff-backup
    rename
    rsnapshot
    rsync
    ruff
    rustc
    shfmt
    sox
    sqlite
    ssh-copy-id
    statix
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
    (pkgs.callPackage ./yamlfmt-preserve-backslash.nix {})
    yq-go
    yt-dlp
    #    yubikey-manager
    yubikey-personalization
  ];

  xdg.configFile."yt-dlp/config".text = ''
    --no-js-runtimes
    --js-runtimes bun
  '';

  imports = [
    ./atuin.nix
    ./bat.nix
    ./claude
    ./codex.nix
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
    ./opencode.nix
    ./ripgrep.nix
    ./rsnapshot.nix
    ./symlinks.nix
    ./tmux
    ./zoxide.nix
    ./zsh
  ];
}

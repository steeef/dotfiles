{ pkgs, lib, ... }: {
  home.username = "sprice";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/sprice" else "/home/sprice";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    bfs
    curl
    fasd
    coreutils
    findutils
    gnugrep
    gnused
    jq
    nil
    nixpkgs-fmt
    reattach-to-user-namespace
    rename
    ripgrep
    ssh-copy-id
    statix
    tree
    watch
    wget
  ];

  home.activation.zgenom = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD git clone "https://github.com/jandamm/zgenom.git" "''${HOME}/.zgenom" 2> /dev/null || git -C "''${HOME}/.zgenom" pull
  '';

  programs.bat = {
    enable = true;
    themes = {
      dracula = builtins.readFile (pkgs.fetchFromGitHub
        {
          owner = "dracula";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
          sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
        } + "/Dracula.tmTheme");
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --no-ignore --hidden --follow -g \"!{.git,node_modules}/*\" 2> /dev/null";
    fileWidgetCommand = "rg --files --no-ignore --hidden --follow -g \"!{.git,node_modules}/*\" 2> /dev/null";
    changeDirWidgetCommand = "bfs ~ -nohidden -type d -printf '~/%P\\n' 2> /dev/null";
    tmux.enableShellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      go = "!f() { git checkout -b \"$1\" 2> /dev/null || git checkout \"$1\"; }; f";
      set-upstream = "!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`";
    };
    userEmail = "stephen@stp5.net";
    userName = "Stephen Price";
    extraConfig = {
      apply = {
        whitespace = "nowarn";
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      commit = {
        verbose = true;
      };
      core = {
        excludesfile = "~/.gitignore";
        autocrlf = "input";
      };
      credential = {
        helper = "osxkeychain";
      };
      diff = {
        compactionHeuristic = "off";
        indentHeuristic = "on";
      };
      fetch = {
        prune = "true";
      };
      init = {
        templatedir = "~/.git_template";
        defaultBranch = "main";
      };
      format = {
        pretty = "%C(yellow)%h%Creset %s %C(red)(%cr)%Creset";
      };
      merge = {
        tool = "vimdiff";
        prompt = "false";
      };
      pull = {
        rebase = "false";
      };
      push = {
        default = "current";
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
    includes = [{
      condition = "gitdir:~/code/work/";
      path = "~/.gitconfig-work";
    }];
  };

  programs.tmux = {
    enable = true;
    secureSocket = if pkgs.stdenv.isDarwin then false else true;
    mouse = true;
    escapeTime = 0;
    historyLimit = 30000;
    newSession = true;
    prefix = "C-Space";
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      dracula
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-boot 'on'
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
          set -g @continuum-boot-options 'iterm'
        '';
      }
    ];

    extraConfig = lib.strings.fileContents ./tmux.conf;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    autocd = true;

    enableCompletion = true;
    initExtraBeforeCompInit = ''
      source "''${ZGEN_DIR}/zgenom.zsh"
    '';
    completionInit = ''
      autoload -U compinit
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zcache
      compinit
    '';

    defaultKeymap = "viins";

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignorePatterns = [ "ls" "cd" "cd .." "h" "fc" "pwd" "exit" "date" "* --help" ];
      ignoreSpace = true;
      path = "$HOME/.zshistory";
      size = 100000;
      save = 100000;
      share = true;
    };

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
  };
}

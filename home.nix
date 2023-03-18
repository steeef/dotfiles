{ pkgs, lib, ... }: {
  home.username = "sprice";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/sprice" else "/home/sprice";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";

  # get some paths on Linux set
  targets.genericLinux.enable = if pkgs.stdenv.isDarwin then false else true;

  home.packages = with pkgs; [
    bfs
    cowsay
    curl
    fasd
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
      ZGEN_COMPINIT_FLAGS='-i'
      ZSH_COMPDUMP="''${HOME}/.zcompdump_''${ZSH_VERSION}"
      ZGEN_CUSTOM_COMPDUMP="''${ZSH_COMPDUMP}"
      export ZSH_COMPDUMP

      # Add some completions settings
      setopt ALWAYS_TO_END     # Move cursor to the end of a completed word.
      setopt AUTO_LIST         # Automatically list choices on ambiguous completion.
      setopt AUTO_MENU         # Show completion menu on a successive tab press.
      setopt AUTO_PARAM_SLASH  # If completed parameter is a directory, add a trailing slash.
      setopt COMPLETE_IN_WORD  # Complete from both ends of a word.
      unsetopt MENU_COMPLETE   # Do not autoselect the first completion entry.

      # install and load zgenom
      ZGEN_DIR="''${HOME}/.zgenom"
      export ZGEN_DIR
      if ! [ -d "''${ZGEN_DIR}" ]; then
        git clone "https://github.com/jandamm/zgenom.git" "''${ZGEN_DIR}"
      fi
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

    initExtra = ''
            # disable oh-my-zsh update
            export DISABLE_AUTO_UPDATE='true'

            # correct spelling for commands
            setopt correct
            # turn off correct for filenames
            unsetopt correctall

            # history options
            setopt hist_ignore_all_dups
            setopt hist_reduce_blanks
            setopt hist_save_no_dups
            setopt hist_verify
            setopt inc_append_history
            unsetopt hist_beep

            setopt INTERACTIVE_COMMENTS  # Enable comments in interactive shell.

            # Long running processes should return time after they complete. Specified
            # in seconds.
            REPORTTIME=60
            TIMEFMT="%U user %S system %P cpu %*Es total"

      # editor settings
      EDITOR=nvim
      VISUAL=nvim
      export EDITOR VISUAL

      # expand aliases inline
      # https://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html
      globalias() {
         if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
           zle _expand_alias
           zle expand-word
         fi
         zle self-insert
      }
      zle -N globalias
      bindkey " " globalias

      # command line editing with vi helpers
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd "^V" edit-command-line # open vim to edit command

      # history searching
      bindkey "^R" history-incremental-search-backward
      # PageUp/Down search history to complete command
      bindkey "^[[I" history-beginning-search-backward
      bindkey "^[[G" history-beginning-search-forward

      PATH="''${HOME}/.zgenom/bin:''${HOME}/bin:''${HOME}/.bin:/usr/local/bin:/usr/local/sbin:''${PATH}"
      export PATH

      # zgenom setup
      ZSHDIR="''${HOME}/.zsh"

      # Load and recompile before plugins
      setopt nullglob
      for file in ''${ZSHDIR}/before/*.zsh; do
        source "''${file}"
      done
      unsetopt nullglob

      zgenom autoupdate --background --self 7
      if ! zgenom saved; then
        zgenom load zsh-users/zsh-completions src # Load more completions
        zgenom load zsh-users/zsh-syntax-highlighting
        zgenom load zsh-users/zsh-history-substring-search

        zgenom load jandamm/vi-mode.zsh # Show line cursor in vi mode

        zgenom load chisui/zsh-nix-shell

        zgenom load larkery/zsh-histdb

        zgenom load blimmer/zsh-aws-vault # aliases
        zgenom load reegnz/aws-vault-zsh-plugin # completion

        zgenom oh-my-zsh
        zgenom oh-my-zsh plugins/kubectl
        zgenom oh-my-zsh plugins/kubectx
        zgenom oh-my-zsh plugins/vi-mode

        # colorschemes
        zgenom load chrissicool/zsh-256color
        zgenom load chriskempson/base16-shell

        zgenom load romkatv/powerlevel10k powerlevel10k
        zgenom load dracula/zsh

        zgenom save

        zgenom compile "''${HOME}/.zshrc"
        zgenom compile "''${ZSHDIR}"
      fi

      # Load and recompile after plugins
      setopt nullglob
      for file in ''${ZSHDIR}/after/*.zsh; do
        source "''${file}"
      done
      unsetopt nullglob

      # Make it easy to append your own customizations that override the above by
      # loading all files from the ~/.zshrc.d directory
      mkdir -p ~/.zshrc.d
      if [ -n "$(/bin/ls ~/.zshrc.d)" ]; then
        for dotfile in ~/.zshrc.d/*
        do
          if [ -r "''${dotfile}" ]; then
            source "''${dotfile}"
          fi
        done
      fi
    '';
  };
}

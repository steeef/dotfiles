{ config, pkgs, ... }: {
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

  programs.bat = {
    enable = true;
    themes = {
      dracula = builtins.readFile (pkgs.fetchFromGitHub {
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
    mouse = true;
    newSession = true;
    prefix = "C-Space";
    terminal = "screen-256color";

    plugins = with pkgs; [
      tmuxPlugins.dracula
      {
        plugin = tmuxPlugin.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = tmuxPlugin.continuum;
        extraConfig = ''
          set -g @continuum-boot 'on'
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5'
          set -g @continuum-boot-options 'iterm'
        '';
      }
    ];

    extraConfig = ''
      set -g status off
      set-option -g history-limit 30000
      set-window-option -g automatic-rename
      unbind C-b

      # quick pane cycling
      unbind ^A
      bind ^A select-pane -t :.+

      # use vi mode
      setw -g mode-keys vi
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # smart pane switching with awareness of vim splits
      # https://github.com/christoomey/vim-tmux-navigator
      is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?x?)(diff)?$"'
      bind -n 'C-h' if-shell "$is_vim" "send-keys C-h" "select-pane -L"
      bind -n 'C-j' if-shell "$is_vim" "send-keys C-j" "select-pane -D"
      bind -n 'C-k' if-shell "$is_vim" "send-keys C-k" "select-pane -U"
      bind -n 'C-l' if-shell "$is_vim" "send-keys C-l" "select-pane -R"
      bind -n 'C-\' if-shell "$is_vim" "send-keys C-\\" "select-pane -l"

      # add map for Ctrl-L to clear
      bind C-l send-keys C-l

      # use w to create panes
      bind w split-window -h

      # send a command to screen/tmux session running inside tmux (e.g., ssh session)
      bind-key a send-prefix

      # vim copy/paste
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-pipe "reattach-to-user-namespace pbcopy"
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send -X copy-pipe "reattach-to-user-namespace pbcopy"
    '';
  };
}

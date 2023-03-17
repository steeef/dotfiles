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
    reattach-to-user-namespace
    rename
    ripgrep
    ssh-copy-id
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
}

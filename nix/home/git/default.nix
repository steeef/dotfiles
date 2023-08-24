{ lib, ... }: {
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
    ignores = lib.splitString "\n" (lib.strings.fileContents ./gitignore);
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

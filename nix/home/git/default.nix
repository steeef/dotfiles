{lib, ...}: {
  programs.git = {
    enable = true;
    ignores = lib.splitString "\n" (lib.strings.fileContents ./gitignore);
    settings = {
      alias = {
        co = "checkout";
        lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        go = "!f() { git checkout \"$1\" 2>/dev/null || git checkout -b \"$1\"; }; f";
        set-upstream = "!git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`";
        ds = "diff --staged";
        lo = "log --oneline";
        ll = "log --graph --topo-order --date=short --abbrev-commit --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn]%Creset'";
        undo = "reset --soft HEAD~1";
        cane = "commit --amend --no-edit";
      };
      user = {
        email = "stephen@stp5.net";
        name = "Stephen Price";
      };
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
        algorithm = "histogram";
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
        conflictstyle = "zdiff3";
        tool = "vimdiff";
        prompt = "false";
      };
      pull = {
        rebase = "false";
      };
      push = {
        default = "current";
      };
      rerere = {
        enabled = "true";
        autoUpdate = "true";
      };
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
    includes = [
      {
        condition = "gitdir:~/code/work/";
        path = "~/.gitconfig-work";
      }
    ];
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
    options = {
      background = "dark";
    };
  };
}

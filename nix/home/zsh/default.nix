{
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    # autosuggestion is loaded via zgenom in initExtra.zsh instead of here —
    # fzf-tab must load before it, and this native option sources it too
    # early (right after compinit, before initContent/zgenom ever runs).

    syntaxHighlighting = {
      enable = true;
    };

    enableCompletion = true;
    initContent = lib.mkMerge [
      (lib.mkBefore (lib.strings.fileContents ./initExtraFirst.zsh))
      (lib.mkOrder 550 (lib.strings.fileContents ./initExtraBeforeCompInit.zsh))
      (lib.strings.fileContents ./initExtra.zsh)
    ];
    completionInit = ''
      autoload -U compinit
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path ~/.zcache
      compinit
    '';

    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      ignorePatterns = ["ls" "cd" "cd .." "h" "fc" "pwd" "exit" "date" "* --help"];
      ignoreSpace = true;
      path = "$HOME/.zhistory";
      size = 100000;
      save = 100000;
      share = true;
    };

    sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = "nvim";
    };
  };
}

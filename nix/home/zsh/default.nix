{ lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autocd = true;

    syntaxHighlighting = {
      enable = true;
    };

    enableCompletion = true;
    initExtraBeforeCompInit = lib.strings.fileContents ./initExtraBeforeCompInit.zsh;
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
      ignorePatterns = [ "ls" "cd" "cd .." "h" "fc" "pwd" "exit" "date" "* --help" ];
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

    initExtraFirst = lib.strings.fileContents ./initExtraFirst.zsh;
    initExtra = lib.strings.fileContents ./initExtra.zsh;
  };
}

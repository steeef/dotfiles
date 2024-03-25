{
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
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
      GRANTED_ALIAS_CONFIGURED = "true";
      GRANTED_ENABLE_AUTO_REASSUME = true;
    };

    envExtra = ''
      alias assume="source ${pkgs.granted}/bin/.assume-wrapped"
    '';

    initExtraFirst = lib.strings.fileContents ./initExtraFirst.zsh;
    initExtra = lib.strings.fileContents ./initExtra.zsh;
  };
}

{ lib, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    autocd = true;

    enableCompletion = true;
    initExtraBeforeCompInit = lib.strings.fileContents ./initExtraBeforeCompInit.zsh;
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

    initExtraFirst = lib.strings.fileContents ./initExtraFirst.zsh;
    initExtra = lib.strings.fileContents ./initExtra.zsh;
  };
}

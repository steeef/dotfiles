{ ... }: {
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

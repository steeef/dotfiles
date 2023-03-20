{ pkgs, lib, ... }: {
  programs.tmux = {
    enable = true;
    secureSocket = if pkgs.stdenv.isDarwin then false else true;
    mouse = true;
    escapeTime = 0;
    historyLimit = 30000;
    keyMode = "vi";
    newSession = true;
    prefix = "C-Space";
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
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
}

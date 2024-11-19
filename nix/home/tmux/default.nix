{
  pkgs,
  lib,
  ...
}: let
  tmux = pkgs.callPackage ./tmux.nix {};
in {
  programs.tmux = {
    enable = true;
    package = tmux;
    shell = "${pkgs.zsh}/bin/zsh";
    secureSocket =
      if pkgs.stdenv.isDarwin
      then false
      else true;
    mouse = true;
    escapeTime = 0;
    historyLimit = 30000;
    keyMode = "vi";
    newSession = true;
    prefix = "C-Space";
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'macchiato' # latte, frappe, macchiato or mocha
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_date_time_text '%a %M/%D'
        '';
      }
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

    extraConfig = ''
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{?#{==:#{pane_current_command},zsh},#{b:pane_current_path},#{pane_current_command}}'

      # quick pane cycling
      unbind ^A
      bind ^A select-pane -t :.+

      # use vi mode
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

      # status bar settings
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_date_time}"

    '';

    # extraConfig = lib.strings.fileContents ./extraConfig.conf;
  };
}

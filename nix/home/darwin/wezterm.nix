{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'

      local config = {}

      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.font = wezterm.font 'Monaco'
      config.font_size = 10.0
      config.color_scheme = 'Catppuccin Macchiato'
      config.freetype_render_target = 'Mono'
      config.freetype_load_target = 'Mono'
      config.window_close_confirmation = 'NeverPrompt'
      config.window_decorations = 'RESIZE'
      config.default_prog = {
        '/bin/zsh',
        '-l',
        '-c',
        'tmux attach -t main || tmux new -s main',
      }
      config.enable_tab_bar = false
      config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
      }
      config.font_rules = {
        {
          italic = true,
          font = wezterm.font {
            family = 'Monaco',
            weight = 'Regular',
            style = 'Normal',
          },
        },
        {
          intensity = 'Bold',
          font = wezterm.font {
            family = 'Monaco',
            weight = 'Regular',
            style = 'Normal',
          },
        },
      }
      return config
    '';
  };
}

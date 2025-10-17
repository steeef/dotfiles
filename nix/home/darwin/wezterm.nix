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
      return config
    '';
  };
}

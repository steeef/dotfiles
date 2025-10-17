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
      config.window_close_confirmation = 'NeverPrompt'
      config.window_decorations = 'RESIZE'
      config.term = 'wezterm'
      config.front_end = 'OpenGL'
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
      config.freetype_load_target = 'Light'
      config.freetype_render_target = 'Light'
      local function apply_hinting(window)
        local dims = window:get_dimensions()
        local overrides = window:get_config_overrides() or {}
        local dpi = dims and dims.dpi or nil
        local low_dpi = dpi and dpi <= 140
        local desired_load = low_dpi and 'Mono' or 'Light'
        local desired_render = low_dpi and 'Mono' or 'Light'
        if overrides.freetype_load_target ~= desired_load or overrides.freetype_render_target ~= desired_render then
          overrides.freetype_load_target = desired_load
          overrides.freetype_render_target = desired_render
          window:set_config_overrides(overrides)
          wezterm.log_warn(
            string.format(
              'dpi=%s load=%s render=%s',
              dpi or 'nil',
              desired_load,
              desired_render
            )
          )
        end
      end
      wezterm.on('window-config-reloaded', function(window, pane)
        apply_hinting(window)
      end)
      wezterm.on('window-resized', function(window, pane)
        apply_hinting(window)
      end)
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

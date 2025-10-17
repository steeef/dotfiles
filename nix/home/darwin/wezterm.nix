{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local mux = wezterm.mux

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
      config.use_resize_increments = true
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
      local cache_dir = wezterm.home_dir .. '/.cache/wezterm'
      local state_path = cache_dir .. '/window-state'
      local function ensure_cache_dir()
        local success, _, stderr = wezterm.run_child_process { 'mkdir', '-p', cache_dir }
        if not success then
          wezterm.log_error('failed to create wezterm cache dir: ' .. tostring(stderr))
        end
      end
      local function read_window_state()
        local f = io.open(state_path, 'r')
        if not f then
          return nil
        end
        local contents = f:read('*a')
        f:close()
        if not contents or contents == "" then
          return nil
        end
        local width, height, pos_x, pos_y = contents:match('^(%d+)%s+(%d+)%s+(%-?%d+)%s+(%-?%d+)%s*$')
        if not width then
          width, height = contents:match('^(%d+)%s+(%d+)%s*$')
        end
        if not width or not height then
          return nil
        end
        local state = {
          width = tonumber(width),
          height = tonumber(height),
        }
        if pos_x and pos_y then
          state.pos_x = tonumber(pos_x)
          state.pos_y = tonumber(pos_y)
        end
        return state
      end
      local function write_window_state(state)
        ensure_cache_dir()
        local f, err = io.open(state_path, 'w')
        if not f then
          wezterm.log_error('failed to store window state: ' .. tostring(err))
          return
        end
        local contents = string.format('%d %d', state.width, state.height)
        if state.pos_x and state.pos_y then
          contents = string.format('%s %d %d', contents, state.pos_x, state.pos_y)
        end
        f:write(contents)
        f:close()
      end
      local function capture_window_state(window)
        local dims = window.get_dimensions and window:get_dimensions() or nil
        if dims and dims.is_full_screen then
          return
        end
        local gui = window.gui_window and window:gui_window() or nil
        if not gui then
          return
        end
        local width = dims and (dims.pixel_width or dims.width) or nil
        local height = dims and (dims.pixel_height or dims.height) or nil
        if (not width or not height) or width <= 0 or height <= 0 then
          local inner_width, inner_height = gui:get_inner_size()
          width = inner_width
          height = inner_height
        end
        if (not width or not height) or width <= 0 or height <= 0 then
          return
        end
        local pos_x
        local pos_y
        if gui.get_position then
          pos_x, pos_y = gui:get_position()
        end
        local state = {
          width = math.floor(width + 0.5),
          height = math.floor(height + 0.5),
        }
        if pos_x and pos_y then
          state.pos_x = math.floor(pos_x + 0.5)
          state.pos_y = math.floor(pos_y + 0.5)
        end
        write_window_state(state)
      end
      local function apply_saved_window_state(window)
        local state = read_window_state()
        if not state then
          return
        end
        local gui = window.gui_window and window:gui_window() or nil
        if not gui then
          return
        end
        gui:set_inner_size(state.width, state.height)
        if state.pos_x and state.pos_y and gui.set_position then
          gui:set_position(state.pos_x, state.pos_y)
        end
      end
      local function apply_hinting(window)
        local dims = window:get_dimensions()
        local overrides = window:get_config_overrides() or {}
        local dpi = dims and dims.dpi or nil
        local low_dpi = dpi and dpi <= 140
        local desired_load = low_dpi and 'Mono' or 'Light'
        local desired_render = low_dpi and 'Mono' or 'Light'
        local changed = false
        if overrides.freetype_load_target ~= desired_load or overrides.freetype_render_target ~= desired_render then
          overrides.freetype_load_target = desired_load
          overrides.freetype_render_target = desired_render
          changed = true
        end
        overrides.window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0,
        }
        if changed then
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
      wezterm.on('gui-startup', function(cmd)
        local _, _, window = mux.spawn_window(cmd or {})
        apply_saved_window_state(window)
        apply_hinting(window)
        capture_window_state(window)
      end)
      wezterm.on('window-created', function(window, _)
        apply_saved_window_state(window)
        apply_hinting(window)
        capture_window_state(window)
      end)
      wezterm.on('window-config-reloaded', function(window, pane)
        apply_hinting(window)
        capture_window_state(window)
      end)
      wezterm.on('window-resized', function(window, pane)
        apply_hinting(window)
        capture_window_state(window)
      end)
      wezterm.on('window-moved', function(window, pane)
        capture_window_state(window)
      end)
      wezterm.on('window-focus-changed', function(window, pane)
        if not window:is_focused() then
          capture_window_state(window)
        end
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

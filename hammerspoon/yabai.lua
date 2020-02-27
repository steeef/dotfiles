function yabai()
  mod1 = {"alt"}
  mod2 = {"shift", "alt"}
  mod3 = {"cmd", "alt"}

  bindings = {
    -- Focus window
    { mod = mod1, key = 'h', command = "yabai -m window --focus west" },
    { mod = mod1, key = 'j', command = "yabai -m window --focus south" },
    { mod = mod1, key = 'k', command = "yabai -m window --focus north" },
    { mod = mod1, key = 'l', command = "yabai -m window --focus east" },
    { mod = mod1, key = 'p', command = "yabai -m window --focus prev" },
    { mod = mod1, key = 'n', command = "yabai -m window --focus next" },
    -- Fullscreen
    { mod = mod1, key = 'f', command = "yabai -m window --grid 1:1:0:0:1:1" },
    -- swap windows
    { mod = mod2, key = 'h', command = "yabai -m window --swap west" },
    { mod = mod2, key = 'j', command = "yabai -m window --swap south" },
    { mod = mod2, key = 'k', command = "yabai -m window --swap north" },
    { mod = mod2, key = 'l', command = "yabai -m window --swap east" },
    -- move windows
    { mod = mod3, key = 'h', command = "yabai -m window --warp west" },
    { mod = mod3, key = 'j', command = "yabai -m window --warp south" },
    { mod = mod3, key = 'k', command = "yabai -m window --warp north" },
    { mod = mod3, key = 'l', command = "yabai -m window --warp east" },
    -- make floating window fill left-half of screen
    { mod = hyper, key = 'left', command = "yabai -m window --grid 1:2:0:0:1:1" },
    -- make floating window fill right-half of screen
    { mod = hyper, key = 'left', command = "yabai -m window --grid 1:2:1:0:1:1" }
  }

  for _, binding in ipairs(bindings) do
    hs.hotkey.bind(binding.mod, binding.key, function()
                    hs.execute(binding.command, true)
    end)
  end
end

yabai()

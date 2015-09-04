--------------------------------------------------------------------------------
-- constants
--------------------------------------------------------------------------------
local mod = {"cmd", "alt", "shift", "ctrl"}

--------------------------------------------------------------------------------
-- settings
--------------------------------------------------------------------------------
hs.window.animationDuration = 0


function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

-- Reload config
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- Type clipboard
hs.hotkey.bind(mod, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

-- Start Screensaver
hs.hotkey.bind(mod, "0", function()
    hs.timer.doAfter(1, function()
        hs.caffeinate.startScreensaver()
    end)
end)

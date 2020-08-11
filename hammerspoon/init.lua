-- Lots of stuff from https://github.com/rtoshiro/hammerspoon-init

--------------------------------------------------------------------------------
-- constants
--------------------------------------------------------------------------------
local hyper = {"cmd", "alt", "shift", "ctrl"}

--------------------------------------------------------------------------------
-- settings
--------------------------------------------------------------------------------

require "usb"
require "amphetamine"
local wm = require('window-management')

function config()
  -- Type clipboard
  hs.hotkey.bind(hyper, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

  -- paste as Markdown code
  hs.hotkey.bind(hyper, "b", function()
    hs.eventtap.keyStrokes("```")
    hs.eventtap.keyStroke('cmd', 'v')
  end)

  -- Start Screensaver
  --
  -- Normally I'd use the built-in function, but that doesn't seem to work
  -- right, so call the app directly
  hs.hotkey.bind(hyper, "0", function()
    hs.timer.doAfter(1, function()
      os.execute(os.getenv("HOME") .. '/.bin/maclock -q')
    end)
  end)

  -- Applications
  hs.hotkey.bind(hyper, "f", function()
    hs.application.launchOrFocus('Finder')
  end)
  hs.hotkey.bind(hyper, "m", function()
    hs.application.launchOrFocus('Messages')
  end)
  hs.hotkey.bind(hyper, "p", function()
    hs.application.launchOrFocus('Slack')
  end)
  hs.hotkey.bind(hyper, "j", nil, function()
    hs.application.launchOrFocus('Firefox')
  end)
  hs.hotkey.bind(hyper, "k", nil, function()
    hs.application.launchOrFocus('Visual Studio Code - Insiders')
  end)
  hs.hotkey.bind(hyper, "l", function()
    hs.application.launchOrFocus('Spotify')
  end)
  hs.hotkey.bind(hyper, "r", function()
    hs.application.launchOrFocus('Reminders')
  end)
  hs.hotkey.bind(hyper, "i", function()
    hs.application.launchOrFocus('iTerm')
  end)
  hs.hotkey.bind(hyper, "g", function()
    hs.application.launchOrFocus('Mailplane')
  end)
  hs.hotkey.bind(hyper, "t", function()
    hs.application.launchOrFocus('Tweetbot')
  end)
  hs.hotkey.bind(hyper, "u", function()
    hs.application.launchOrFocus('1Password 7')
  end)

  -- window management
  hs.hotkey.bind(hyper, "1", function()
    hs.window.focusedWindow():moveOneScreenEast()
  end)
  hs.hotkey.bind(hyper, "2", function()
    wm.windowMaximize(0)
  end)
  hs.hotkey.bind(hyper, "up", function()
    wm.moveWindowToPosition(wm.screenPositions.top)
  end)
  hs.hotkey.bind(hyper, "down", function()
    wm.moveWindowToPosition(wm.screenPositions.bottom)
  end)
  hs.hotkey.bind(hyper, "left", function()
    wm.moveWindowToPosition(wm.screenPositions.left)
  end)
  hs.hotkey.bind(hyper, "right", function()
    wm.moveWindowToPosition(wm.screenPositions.right)
  end)

  -- media keys
  hs.hotkey.bind(hyper, "9", function()
    hs.eventtap.event.newSystemKeyEvent('PLAY', true):post()
  end)
  hs.hotkey.bind(hyper, "8", function()
    hs.eventtap.event.newSystemKeyEvent('PREVIOUS', true):post()
  end)
  hs.hotkey.bind(hyper, "-", function()
    hs.eventtap.event.newSystemKeyEvent('STOP', true):post()
  end)

  -- Keychain password entry
  hs.hotkey.bind(hyper, "w", function()
    typeKeychainEntry('QS_1_creds', 'account')
  end)
  hs.hotkey.bind(hyper, "e", function()
    typeKeychainEntry('QS_1_creds', 'password')
  end)
  hs.hotkey.bind(hyper, "s", function()
    typeKeychainEntry('QS_2_creds', 'account')
  end)
  hs.hotkey.bind(hyper, "x", function()
    typeKeychainEntry('QS_2_creds', 'password')
  end)
end

function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == "Finder") then
        appObject:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
end

function typeKeychainEntry(keychainEntry, keychainField)
  if keychainField == 'password' then
    command = "security find-generic-password -gl '" .. keychainEntry ..  "' -w " ..
      "|tr -d '\\n'"
  else
    command = "security find-generic-password -l '" .. keychainEntry .. "'" ..
      "| grep '\"acct\"' | sed 's/.*\"acct\".*=\"\\([a-zA-Z0-9]*\\)\"/\\1/'" ..
      "| tr -d '\\n'"
  end

  output = hs.execute(command)
  hs.eventtap.keyStrokes(output)
end


--------------------------------------------------------------------------------
-- reload config
--------------------------------------------------------------------------------
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


config()

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

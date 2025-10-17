-- Lots of stuff from https://github.com/rtoshiro/hammerspoon-init
-- hyper from https://github.com/evantravers/hammerspoon

--------------------------------------------------------------------------------
-- settings
--------------------------------------------------------------------------------

config = {}
config.applications = {}

require("amphetamine")
require("camera-lights")

hyper = require("hyper")
hyper.start(config)

local wm = require("window-management")

-- Type clipboard
hyper:bind({}, "V", nil, function()
  hs.eventtap.keyStrokes(hs.pasteboard.getContents())
end)

-- paste as Markdown code
hyper:bind({}, "b", nil, function()
  hs.eventtap.keyStrokes("```")
  hs.timer.doAfter(1 / 5, function()
    hs.eventtap.keyStroke("cmd", "v")
  end)
end)

-- Start Screensaver
--
-- Normally I'd use the built-in function, but that doesn't seem to work
-- right, so call the app directly
hyper:bind({}, "0", nil, function()
  hs.timer.doAfter(1, function()
    os.execute(os.getenv("HOME") .. "/.bin/maclock -q")
  end)
end)

-- system sleep
hyper:bind({ "ctrl" }, "0", nil, function()
  hs.timer.doAfter(1, function()
    hs.caffeinate.systemSleep()
  end)
end)

-- Applications
hyper:bind({}, "f", nil, function()
  hs.application.launchOrFocus("Finder")
end)
hyper:bind({}, "m", nil, function()
  hs.application.launchOrFocus("Messages")
end)
hyper:bind({}, "p", nil, function()
  hs.application.launchOrFocus("Slack")
end)
hyper:bind({}, "j", nil, function()
  hs.application.launchOrFocus("Firefox")
end)
hyper:bind({}, "l", nil, function()
  hs.application.launchOrFocus("Music")
end)
hyper:bind({}, "r", nil, function()
  hs.application.launchOrFocus("Reminders")
end)
hyper:bind({}, "i", nil, function()
  hs.application.launchOrFocus(os.getenv("HOME") .. "/Applications/Nix/WezTerm.app")
end)
hyper:bind({}, "g", nil, function()
  hs.application.launchOrFocus("Mail")
end)
hyper:bind({}, "c", nil, function()
  hs.application.launchOrFocus("Fantastical")
end)
hyper:bind({}, "t", nil, function()
  hs.application.launchOrFocus("Ivory")
end)
hyper:bind({}, "u", nil, function()
  hs.application.launchOrFocus("1Password")
end)
hyper:bind({}, "z", nil, function()
  hs.application.launchOrFocus("Unread")
end)

-- window management
hyper:bind({}, "1", nil, function()
  -- get the focused window
  local win = hs.window.focusedWindow()
  -- get the screen where the focused window is displayed, a.k.a. current screen
  local screen = win:screen()
  -- compute the unitRect of the focused window relative to the current screen
  -- and move the window to the next screen setting the same unitRect
  win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
end)
hyper:bind({}, "2", nil, function()
  wm.windowMaximize(0)
end)
hyper:bind({}, "up", nil, function()
  wm.moveWindowToPosition(wm.screenPositions.top)
end)
hyper:bind({}, "down", nil, function()
  wm.moveWindowToPosition(wm.screenPositions.bottom)
end)
hyper:bind({}, "left", nil, function()
  wm.moveWindowToPosition(wm.screenPositions.left)
end)
hyper:bind({}, "right", nil, function()
  wm.moveWindowToPosition(wm.screenPositions.right)
end)

-- Keychain password entry
hyper:bind({}, "w", nil, function()
  typeKeychainEntry("QS_1_creds", "account")
end)
hyper:bind({}, "e", nil, function()
  typeKeychainEntry("QS_1_creds", "password")
end)
hyper:bind({}, "s", nil, function()
  typeKeychainEntry("QS_2_creds", "account")
end)
hyper:bind({}, "x", nil, function()
  typeKeychainEntry("QS_2_creds", "password")
end)

-- Apple Music shortcuts
hyper:bind({}, "6", nil, function()
  hs.applescript([[tell application "Music" to set loved of current track to true]])
end)
hyper:bind({}, "7", nil, function()
  hs.applescript([[tell application "Music" to set loved of current track to false]])
end)

function applicationWatcher(appName, eventType, appObject)
  if eventType == hs.application.watcher.activated then
    if appName == "Finder" then
      appObject:selectMenuItem({ "Window", "Bring All to Front" })
    end
  end
end

function typeKeychainEntry(keychainEntry, keychainField)
  if keychainField == "password" then
    command = "security find-generic-password -gl '" .. keychainEntry .. "' -w " .. "|tr -d '\\n'"
  else
    command = "security find-generic-password -l '"
      .. keychainEntry
      .. "'"
      .. '| grep \'"acct"\' | sed \'s/.*"acct".*="\\([a-zA-Z0-9]*\\)"/\\1/\''
      .. "| tr -d '\\n'"
  end

  output = hs.execute(command)
  hs.eventtap.keyStrokes(output)
end

--------------------------------------------------------------------------------
-- reload config
--------------------------------------------------------------------------------
function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
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

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

hs.alert.show("🔨🥄✅")

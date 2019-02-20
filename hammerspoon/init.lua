-- Lots of stuff from https://github.com/rtoshiro/hammerspoon-init

--------------------------------------------------------------------------------
-- constants
--------------------------------------------------------------------------------
local hyper = {"cmd", "alt", "shift", "ctrl"}

--------------------------------------------------------------------------------
-- settings
--------------------------------------------------------------------------------
hs.window.animationDuration = 0
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDHEIGHT = 2
hs.grid.GRIDWIDTH = 2

require "usb"

function config()
  -- Force reload
  hs.hotkey.bind(hyper, "k", function()
    hs.reload()
    hs.notify.show("Hammerspoon", "Config reloaded.")
  end)

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
  hs.hotkey.bind(hyper, "y", function()
    hs.application.launchOrFocus('Calendar')
  end)
  hs.hotkey.bind(hyper, "p", function()
    hs.application.launchOrFocus('Slack')
  end)
  hs.hotkey.bind(hyper, "j", nil, function()
    hs.application.launchOrFocus('Firefox')
  end)
  hs.hotkey.bind(hyper, "k", nil, function()
    hs.application.launchOrFocus('Visual Studio Code')
  end)
  hs.hotkey.bind(hyper, "l", function()
    hs.application.launchOrFocus('Swinsian')
  end)
  hs.hotkey.bind(hyper, "r", function()
    hs.application.launchOrFocus('Reminders')
  end)
  hs.hotkey.bind(hyper, "i", function()
    hs.application.launchOrFocus('iTerm')
  end)
  hs.hotkey.bind(hyper, "n", function()
    hs.application.launchOrFocus('nvALT')
  end)
  hs.hotkey.bind(hyper, "g", function()
    hs.application.launchOrFocus('Boxy')
  end)
  hs.hotkey.bind(hyper, "c", function()
    hs.application.launchOrFocus('Google Play Music Desktop Player')
  end)
  hs.hotkey.bind(hyper, "t", function()
    hs.application.launchOrFocus('Tweetbot')
  end)
  hs.hotkey.bind(hyper, "u", function()
    hs.application.launchOrFocus('1Password 7')
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

function chromeTab(tabName, tabUrl)
  hs.applescript.applescript([[
    on run
      tell application "Google Chrome"
        set found to false
        set allWins to every window
        repeat with currWin in allWins
          set allTabs to every tab of currWin
          set i to 0
          repeat with currTab in allTabs
            set i to i + 1
            try
              if URL of currTab contains "]] .. tabUrl .. [[" then
                set (active tab index of (currWin)) to i
                # tell window currWin to activate
                set the index of currWin to 1
                set found to true
              end if
            end try
          end repeat
        end repeat
        if (found = false) then
          set myTab to make new tab at end of tabs of window 1
          set URL of myTab to "]] .. tabUrl .. [["
        end if
        activate
      end tell
      tell application "System Events" to tell process "Google Chrome"
        set frontmost to true
        set windowMenu to menu bar item "Window" of menu bar 1
        set allUIElements to entire contents of windowMenu
        repeat with m in allUIElements
          try
            if name of m contains "]] .. tabName .. [[" then
              click m
              exit repeat
            end if
          end try
        end repeat
      end tell
    end run
  ]])
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

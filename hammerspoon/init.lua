-- Lots of stuff from https://github.com/rtoshiro/hammerspoon-init

--------------------------------------------------------------------------------
-- constants
--------------------------------------------------------------------------------
local hyper = {"cmd", "alt", "shift", "ctrl"}

--------------------------------------------------------------------------------
-- settings
--------------------------------------------------------------------------------
hs.window.animationDuration = 0



function config()
  -- Type clipboard
  hs.hotkey.bind(hyper, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)

  -- Start Screensaver
  hs.hotkey.bind(hyper, "0", function()
    hs.timer.doAfter(1, function()
      hs.caffeinate.startScreensaver()
    end)
  end)

  -- window management
  hs.hotkey.bind(hyper, "right", function()
    local win = hs.window.focusedWindow()
    win:right()
  end)

  hs.hotkey.bind(hyper, "left", function()
    local win = hs.window.focusedWindow()
    win:left()
  end)

  hs.hotkey.bind(hyper, "up", function()
    local win = hs.window.focusedWindow()
    win:up()
  end)

  hs.hotkey.bind(hyper, "down", function()
    local win = hs.window.focusedWindow()
    win:down()
  end)

  hs.hotkey.bind(hyper, "2", function()
    local win = hs.window.focusedWindow()
    hs.window.fullscreenCenter(win)
  end)

  hs.hotkey.bind(hyper, "1", hs.grid.pushWindowNextScreen)

  -- Applications
  hs.hotkey.bind(hyper, "k", function()
    hs.application.launchOrFocus('Xccello')
  end)
  hs.hotkey.bind(hyper, "f", function()
    hs.application.launchOrFocus('Finder')
  end)
  hs.hotkey.bind(hyper, "m", function()
    hs.application.launchOrFocus('Microsoft Lync')
  end)
  hs.hotkey.bind(hyper, "y", function()
    hs.application.launchOrFocus('Calendar')
  end)
  hs.hotkey.bind(hyper, "o", function()
    hs.application.launchOrFocus('Mail')
  end)
  hs.hotkey.bind(hyper, "p", function()
    hs.application.launchOrFocus('Slack')
  end)
  hs.hotkey.bind(hyper, "b", function()
    hs.application.launchOrFocus('HipChat')
  end)
  hs.hotkey.bind(hyper, "j", function()
    hs.application.launchOrFocus('Google Chrome')
  end)
  hs.hotkey.bind(hyper, "l", function()
    hs.application.launchOrFocus('Firefox')
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

  -- Google Chrome - tab switching
  hs.hotkey.bind(hyper, "g", function()
    chromeTab('Inbox - steeef@gmail.com', 'https://inbox.google.com')
  end)
  hs.hotkey.bind(hyper, "c", function()
    chromeTab(' - Google Play Music', 'https://play.google.com/music/listen')
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

--------------------------------------------------------------------------------
-- window layout stuff
--------------------------------------------------------------------------------

function hs.screen.get(screen_name)
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    if screen:name() == screen_name then
      return screen
    end
  end
end

-- Returns the width of the smaller screen size
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minWidth(isFullscreen)
  local min_width = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_width = math.min(min_width, screen_frame.w)
  end
  return min_width
end

-- isFullscreen = false removes the toolbar
-- and dock sizes
-- Returns the height of the smaller screen size
function hs.screen.minHeight(isFullscreen)
  local min_height = math.maxinteger
  local allScreens = hs.screen.allScreens()
  for i, screen in ipairs(allScreens) do
    local screen_frame = screen:frame()
    if (isFullscreen) then
      screen_frame = screen:fullFrame()
    end
    min_height = math.min(min_height, screen_frame.h)
  end
  return min_height
end

-- If you are using more than one monitor, returns X
-- considering the reference screen minus smaller screen
-- = (MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2
-- If using only one monitor, returns the X of ref screen
function hs.screen.minX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + ((refScreen:frame().w - hs.screen.minWidth()) / 2)
  end
  return min_x
end

-- If you are using more than one monitor, returns Y
-- considering the focused screen minus smaller screen
-- = (MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2
-- If using only one monitor, returns the Y of focused screen
function hs.screen.minY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + ((refScreen:frame().h - hs.screen.minHeight()) / 2)
  end
  return min_y
end

-- If you are using more than one monitor, returns the
-- half of minX and 0
-- = ((MAX_REFSCREEN_WIDTH - MIN_AVAILABLE_WIDTH) / 2) / 2
-- If using only one monitor, returns the X of ref screen
function hs.screen.almostMinX(refScreen)
  local min_x = refScreen:frame().x
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_x = refScreen:frame().x + (((refScreen:frame().w - hs.screen.minWidth()) / 2) - ((refScreen:frame().w - hs.screen.minWidth()) / 4))
  end
  return min_x
end

-- If you are using more than one monitor, returns the
-- half of minY and 0
-- = ((MAX_REFSCREEN_HEIGHT - MIN_AVAILABLE_HEIGHT) / 2) / 2
-- If using only one monitor, returns the Y of ref screen
function hs.screen.almostMinY(refScreen)
  local min_y = refScreen:frame().y
  local allScreens = hs.screen.allScreens()
  if (#allScreens > 1) then
    min_y = refScreen:frame().y + (((refScreen:frame().h - hs.screen.minHeight()) / 2) - ((refScreen:frame().h - hs.screen.minHeight()) / 4))
  end
  return min_y
end

-- Returns the frame of the smaller available screen
-- considering the context of refScreen
-- isFullscreen = false removes the toolbar
-- and dock sizes
function hs.screen.minFrame(refScreen, isFullscreen)
  return {
    x = hs.screen.minX(refScreen),
    y = hs.screen.minY(refScreen),
    w = hs.screen.minWidth(isFullscreen),
    h = hs.screen.minHeight(isFullscreen)
  }
end

-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function hs.window.right(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.x = minFrame.x + (minFrame.w/2)
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function hs.window.left(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.w = minFrame.w/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function hs.window.up(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function hs.window.down(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.y = minFrame.y + minFrame.h/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function hs.window.upLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  minFrame.w = minFrame.w/2
  minFrame.h = minFrame.h/2
  win:setFrame(minFrame)
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function hs.window.downLeft(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x,
    y = minFrame.y + minFrame.h/2,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +-----------------+
-- |                 |
-- |        +--------|
-- |        |  HERE  |
-- +-----------------+
function hs.window.downRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x + minFrame.w/2,
    y = minFrame.y + minFrame.h/2,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +-----------------+
-- |        |  HERE  |
-- |        +--------|
-- |                 |
-- +-----------------+
function hs.window.upRight(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = minFrame.x + minFrame.w/2,
    y = minFrame.y,
    w = minFrame.w/2,
    h = minFrame.h/2
  })
end

-- +------------------+
-- |                  |
-- |    +--------+    +--> minY
-- |    |  HERE  |    |
-- |    +--------+    |
-- |                  |
-- +------------------+
-- Where the window's size is equal to
-- the smaller available screen size
function hs.window.fullscreenCenter(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame(minFrame)
end

-- +------------------+
-- |                  |
-- |  +------------+  +--> minY
-- |  |    HERE    |  |
-- |  +------------+  |
-- |                  |
-- +------------------+
function hs.window.fullscreenAlmostCenter(win)
  local offsetW = hs.screen.minX(win:screen()) - hs.screen.almostMinX(win:screen())
  win:setFrame({
    x = hs.screen.almostMinX(win:screen()),
    y = hs.screen.minY(win:screen()),
    w = hs.screen.minWidth(isFullscreen) + (2 * offsetW),
    h = hs.screen.minHeight(isFullscreen)
  })
end

-- It like fullscreen but with minY and minHeight values
-- +------------------+
-- |                  |
-- +------------------+--> minY
-- |       HERE       |
-- +------------------+--> minHeight
-- |                  |
-- +------------------+
function hs.window.fullscreenWidth(win)
  local minFrame = hs.screen.minFrame(win:screen(), false)
  win:setFrame({
    x = win:screen():frame().x,
    y = minFrame.y,
    w = win:screen():frame().w,
    h = minFrame.h
  })
end

function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == "Finder") then
        appObject:selectMenuItem({"Window", "Bring All to Front"})
    elseif (appName == "Finder") then
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

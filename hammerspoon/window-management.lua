local This = {}

-- To easily layout windows on the screen, we use hs.grid to create a 4x4 grid.
-- If you want to use a more detailed grid, simply change its dimension here
local GRID_SIZE = 4
local HALF_GRID_SIZE = GRID_SIZE / 2

local weztermCacheDir = hs.fs.pathToAbsolute(os.getenv('HOME') .. '/.cache/wezterm')
local weztermStatePath = os.getenv('HOME') .. '/.cache/wezterm/window-state.json'

local function ensureWeztermCacheDir()
  if weztermCacheDir then
    return
  end
  local path = os.getenv('HOME') .. '/.cache/wezterm'
  hs.fs.mkdir(path)
  weztermCacheDir = hs.fs.pathToAbsolute(path)
end

local function readWeztermState()
  local file = io.open(weztermStatePath, 'r')
  if not file then
    return {}
  end
  local contents = file:read('*a')
  file:close()
  if not contents or contents == '' then
    return {}
  end
  local ok, decoded = pcall(hs.json.decode, contents)
  if not ok or type(decoded) ~= 'table' then
    return {}
  end
  return decoded
end

local function mergeTables(base, updates)
  for key, value in pairs(updates) do
    if type(value) == 'table' and type(base[key]) == 'table' then
      mergeTables(base[key], value)
    else
      base[key] = value
    end
  end
  return base
end

local function writeWeztermState(update)
  ensureWeztermCacheDir()
  local state = mergeTables(readWeztermState(), update)
  state.updated_by = update.updated_by or 'hammerspoon'
  state.updated_at = os.time()
  local file, err = io.open(weztermStatePath, 'w')
  if not file then
    hs.printf('wezterm state write failed: %s', err or 'unknown error')
    return
  end
  file:write(hs.json.encode(state, true))
  file:close()
end

local function isWeztermWindow(window)
  if not window then
    return false
  end
  local app = window:application()
  if not app then
    return false
  end
  local name = app:name() or ''
  name = name:lower()
  return name:find('wezterm') ~= nil
end

local function recordWeztermPlacement(window)
  if not isWeztermWindow(window) then
    return
  end
  local frame = window:frame()
  if not frame then
    return
  end
  local screen = window:screen()
  local screenInfo
  if screen then
    local frame = screen:frame()
    screenInfo = {
      uuid = screen:getUUID(),
      name = screen:name(),
      x = math.floor(frame.x + 0.5),
      y = math.floor(frame.y + 0.5),
      width = math.floor(frame.w + 0.5),
      height = math.floor(frame.h + 0.5),
    }
  end
  writeWeztermState({
    width = math.floor(frame.w + 0.5),
    height = math.floor(frame.h + 0.5),
    pos_x = math.floor(frame.x + 0.5),
    pos_y = math.floor(frame.y + 0.5),
    screen = screenInfo,
    updated_by = 'hammerspoon',
  })
end

local function detectScreens()
  local result = { builtin = nil, external = nil }
  for _, screen in ipairs(hs.screen.allScreens()) do
    if screen:isBuiltin() then
      if not result.builtin then
        result.builtin = screen
      end
    else
      if not result.external then
        result.external = screen
      end
    end
  end
  if not result.builtin then
    result.builtin = hs.screen.mainScreen()
  end
  if not result.external then
    for _, screen in ipairs(hs.screen.allScreens()) do
      if screen ~= result.builtin then
        result.external = screen
        break
      end
    end
  end
  return result
end

local function applyWeztermPlacement(window)
  if not isWeztermWindow(window) then
    return
  end
  local state = readWeztermState()
  local targetFrame
  local targetScreen
  if state and state.screen and state.screen.uuid then
    targetScreen = hs.screen.find(state.screen.uuid)
  end
  if not targetScreen and state and state.screen and state.screen.name then
    targetScreen = hs.screen.find(state.screen.name)
  end
  if not targetScreen then
    local screens = detectScreens()
    targetScreen = screens.external or screens.builtin or hs.screen.mainScreen()
  end
  if state and state.width and state.height then
    local width = state.width
    local height = state.height
    if state.pos_x and state.pos_y then
      local offsetX = state.pos_x
      local offsetY = state.pos_y
      if state.screen and targetScreen and state.screen.x and state.screen.y then
        local currentFrame = targetScreen:frame()
        offsetX = currentFrame.x + (state.pos_x - state.screen.x)
        offsetY = currentFrame.y + (state.pos_y - state.screen.y)
      end
      targetFrame = hs.geometry.rect(offsetX, offsetY, width, height)
    end
  end
  if not targetFrame and targetScreen then
    local screenFrame = targetScreen:frame()
    if targetScreen:isBuiltin() then
      local width = math.max(math.floor(screenFrame.w * 0.55), 800)
      local height = math.max(math.floor(screenFrame.h * 0.7), 600)
      targetFrame = hs.geometry.rect(screenFrame.x, screenFrame.y, width, height)
    else
      local width = math.max(math.floor(screenFrame.w / 2), 800)
      local height = screenFrame.h
      targetFrame = hs.geometry.rect(
        screenFrame.x + screenFrame.w - width,
        screenFrame.y,
        width,
        height
      )
    end
  end
  if targetFrame then
    window:setFrame(targetFrame, 0)
    recordWeztermPlacement(window)
  end
end

-- Set the grid size and add a few pixels of margin
-- Also, don't animate window changes... That's too slow
hs.grid.setGrid(GRID_SIZE .. 'x' .. GRID_SIZE)
hs.grid.setMargins({0, 0})
hs.window.animationDuration = 0

-- Defining screen positions
local screenPositions       = {}
screenPositions.left        = {x = 0,              y = 0,              w = HALF_GRID_SIZE, h = GRID_SIZE     }
screenPositions.right       = {x = HALF_GRID_SIZE, y = 0,              w = HALF_GRID_SIZE, h = GRID_SIZE     }
screenPositions.top         = {x = 0,              y = 0,              w = GRID_SIZE,      h = HALF_GRID_SIZE}
screenPositions.bottom      = {x = 0,              y = HALF_GRID_SIZE, w = GRID_SIZE,      h = HALF_GRID_SIZE}

screenPositions.topLeft     = {x = 0,              y = 0,              w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}
screenPositions.topRight    = {x = HALF_GRID_SIZE, y = 0,              w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}
screenPositions.bottomLeft  = {x = 0,              y = HALF_GRID_SIZE, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}
screenPositions.bottomRight = {x = HALF_GRID_SIZE, y = HALF_GRID_SIZE, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}

This.screenPositions = screenPositions

-- This function will move either the specified or the focuesd
-- window to the requested screen position
function This.moveWindowToPosition(cell, window)
  if window == nil then
    window = hs.window.focusedWindow()
  end
  if window then
    local screen = window:screen()
    hs.grid.set(window, cell, screen)
    recordWeztermPlacement(window)
  end
end

-- This function will move either the specified or the focused
-- window to the center of the sreen and let it fill up the
-- entire screen.
function This.windowMaximize(factor, window)
   if window == nil then
      window = hs.window.focusedWindow()
   end
   if window then
      window:maximize()
      recordWeztermPlacement(window)
   end
end

function This.recordWeztermWindowState(window)
  recordWeztermPlacement(window or hs.window.focusedWindow())
end

function This.applyWeztermWindowState(window)
  applyWeztermPlacement(window or hs.window.focusedWindow())
end

return This

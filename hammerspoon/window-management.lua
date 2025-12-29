local This = {}

-- To easily layout windows on the screen, we use hs.grid to create a 4x4 grid.
-- If you want to use a more detailed grid, simply change its dimension here
local GRID_SIZE = 4
local HALF_GRID_SIZE = GRID_SIZE / 2

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

-- This function will move either the specified or the focused
-- window to the requested screen position
function This.moveWindowToPosition(cell, window)
  if window == nil then
    window = hs.window.focusedWindow()
  end
  if window and window:isStandard() then
    local app = window:application()
    -- Skip Hammerspoon's own windows - they don't support frame manipulation
    if app and app:name() == "Hammerspoon" then return end
    local screen = window:screen()
    if screen then
      local ok, err = pcall(function()
        hs.grid.set(window, cell, screen)
      end)
      if not ok then
        print("Grid set failed for: " .. (app and app:name() or "unknown") .. " - " .. tostring(err))
      end
    end
  end
end

-- This function will move either the specified or the focused
-- window to the center of the screen and let it fill up the
-- entire screen.
function This.windowMaximize(factor, window)
   if window == nil then
      window = hs.window.focusedWindow()
   end
   if window and window:isStandard() then
      local app = window:application()
      -- Skip Hammerspoon's own windows - they don't support frame manipulation
      if app and app:name() == "Hammerspoon" then return end
      local ok, err = pcall(function()
        window:maximize()
      end)
      if not ok then
        print("Maximize failed for: " .. (app and app:name() or "unknown") .. " - " .. tostring(err))
      end
   end
end

return This

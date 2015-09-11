--[[
A script to load pass (http://www.passwordstore.org) entries in Hammerspoon, based on
this AppleScript:
http://git.zx2c4.com/password-store/tree/contrib/pass.applescript
]]--

local pasteboard = require("hs.pasteboard")
local shellPath = "/opt/local/bin:/usr/local/bin:$PATH"

function getPassword()
  local success, selectedPassword = hs.applescript([[
    return the text returned of (display dialog "password" default answer "" buttons {"OK"} with title "pass" default button 1)
  ]])
  if success then
     password, found = hs.execute("export PATH=" .. shellPath .. "; pass " .. selectedPassword)
    if found then
      password = password:gsub("\n$", "") -- remove line break
      pasteboard.setContents(password)
      hs.notify.new({
        title="Pass",
        informativeText="password for '" .. selectedPassword .. "' copied to pasteboard."
      }):send():release()
    else
      hs.notify.new({
        title="Pass",
        informativeText="password not found for '" .. selectedPassword .. "'."
      }):send():release()
    end
  end
end

local usbWatcher = nil

-- This is our usbWatcher function
-- lock when yubikey is removed
function usbDeviceCallback(data)
  -- this line will let you know the name of each usb device you connect, useful for the string match below
  -- hs.notify.show("USB", "You just connected", data["productName"])
  -- Replace "Yubikey" with the name of the usb device you want to use.
  if string.match(data["productName"], "Yubikey NEO") then
    if (data["eventType"] == "added") then
      hs.notify.show("Yubikey", "You just connected", data["productName"])
      -- wake the screen up, so knock will activate
      -- get knock here http://www.knocktounlock.com
      -- os.execute("caffeinate -u -t 5")
      os.execute("~/.bin/fix-gpg")
    elseif (data["eventType"] == "removed") then
      -- replace +000000000000 with a phone number registered to iMessage
      -- hs.messages.iMessage("+", "Your Yubikey was just removed.")
      -- this locks to screensaver
      -- os.execute("pmset displaysleepnow")
      hs.timer.doAfter(1, function()
        hs.application.launchOrFocus('/System/Library/Frameworks/' ..
        'ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app')
      end)
    end
  end
end

-- Start the usb watcher
usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()

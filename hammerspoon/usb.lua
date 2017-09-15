-- Switch between Karabiner-Elements profiles by keyboard

function switchKarabinerElementsProfile(name)
  hs.execute("~/.bin/karabiner_cli --select-profile " .. name)
  hs.notify.show("ErgoDox", "Switching to profile", name)
end

-- from https://gist.github.com/ojkelly/45dda0a5a7066c6a79a038ece8bde55a
local usbWatcher = nil

-- This is our usbWatcher function
-- lock when yubikey is removed
function usbDeviceCallback(data)
  -- this line will let you know the name of each usb device you connect, useful for the string match below
  -- hs.notify.show("USB", "You just connected", data["productName"])
  -- Replace "Yubikey" with the name of the usb device you want to use.
  -- hs.notify.show("USB", "You just connected/disconnected", data["productName"])
  if string.match(data["productName"], "Yubikey NEO") then
    if (data["eventType"] == "added") then
      hs.notify.show("Yubikey", "You just connected", data["productName"])
      -- os.execute("~/.bin/fix-gpg")
    elseif (data["eventType"] == "removed") then
      hs.timer.doAfter(1, function()
        hs.application.launchOrFocus('/System/Library/Frameworks/' ..
        'ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app')
      end)
    end
  elseif string.match(data["productName"], "ErgoDox EZ") then
    if (data["eventType"] == "added") then
      switchKarabinerElementsProfile("ergodox")
    elseif (data["eventType"] == "removed") then
      switchKarabinerElementsProfile("default")
    end
  end
end

-- Start the usb watcher
usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()
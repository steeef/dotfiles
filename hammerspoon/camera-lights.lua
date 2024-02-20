function stopConfigureAndStartPropertyWatcher(camera)
  if camera:isPropertyWatcherRunning() then
    camera:stopPropertyWatcher()
  end

  camera:setPropertyWatcherCallback(function(camera, property, scope, element)
    checkLights()
  end)
  camera:startPropertyWatcher()
end

function checkLights()
  local anyCameraInUse = false
  for k, camera in pairs(hs.camera.allCameras()) do
    if camera:isInUse() then
      anyCameraInUse = true
    end
  end

  if anyCameraInUse then
    hs.execute("PATH=~/.nix-profile/bin:$PATH ~/.bin/litra_control.sh on")
  else
    hs.execute("PATH=~/.nix-profile/bin:$PATH ~/.bin/litra_control.sh off")
  end
end

for k, camera in pairs(hs.camera.allCameras()) do
  stopConfigureAndStartPropertyWatcher(camera)
end

hs.camera.setWatcherCallback(function(camera, state)
  if state == "Added" then
    stopConfigureAndStartPropertyWatcher(camera)
  end
  checkLights()
end)
hs.camera.startWatcher()

-- check lights on startup to make sure they are on
checkLights()

#!/usr/bin/env bash
#
# hidutil.sh
#
# Remap keyboard keys

# map left ctrl to F19 for use with Hammerspoon hyper key
hidutil property --set '{
  "UserKeyMapping":[
    {
      "HIDKeyboardModifierMappingSrc":0x7000000E0,
      "HIDKeyboardModifierMappingDst":0x70000006E
    }
  ]
}'

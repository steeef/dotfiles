#!/usr/bin/env bash

hidutil property --set '{
  "UserKeyMapping":[
    {
      "HIDKeyboardModifierMappingSrc":0x7000000E0,
      "HIDKeyboardModifierMappingDst":0x70000006E
    }
  ]
}'

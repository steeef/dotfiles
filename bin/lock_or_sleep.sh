#!/usr/bin/env bash

if [ "$(cat /sys/class/power_supply/AC/online)" = "0" ]; then
  systemctl suspend
else
  light-locker-command -l
fi

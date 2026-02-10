#!/usr/bin/env bash
# codes from https://ultracrepidarian.phfactor.net/2022/03/09/controlling-the-logitech-litra-on-macos/

set -e

if ! command -v hidapitester >/dev/null 2>&1; then
  echo "ERROR: can't find hidapitester"
  exit 1
fi

state_file="${HOME}/.litra_brightness"
set_brightness_prefix="0x11,0xff,0x04,0x4c,0x00,"

function hid() {
  hidapitester --vidpid 046D/C900 --open --length 20 --send-output "$1"
}

function get_brightness() {
  declare -i litra_brightness
  # shellcheck source=/dev/null
  . "${state_file}" 2>/dev/null || :
  : ${litra_brightness:=0}
  echo "${litra_brightness}"
}

function set_brightness() {
  brightness_value="$1"
  if [ -n "${brightness_value}" ]; then
    declare -i litra_brightness
    litra_brightness=$brightness_value
    declare -p litra_brightness >"${state_file}"
    hid "${set_brightness_prefix}${brightness_value}"
  fi
}

function raise_brightness() {
  state=$(get_brightness)
  litra_brightness=$((state + 10))
  set_brightness "${litra_brightness}"
}

function lower_brightness() {
  state=$(get_brightness)
  litra_brightness=$((state - 10))
  set_brightness "${litra_brightness}"
}

case "${1}" in
  "on")
    hid "0x11,0xff,0x04,0x1c,0x01"
    ;;
  "off")
    hid "0x11,0xff,0x04,0x1c"
    ;;
  "up")
    raise_brightness
    ;;
  "down")
    lower_brightness
    ;;
  "min")
    set_brightness 20
    ;;
  "medium")
    set_brightness 70
    ;;
  "max")
    set_brightness 240
    ;;
  "2700K")
    hid "0x11,0xff,0x04,0x9c,10,140"
    ;;
  "3200K")
    hid "0x11,0xff,0x04,0x9c,12,128"
    ;;
  "6500K")
    hid "0x11,0xff,0x04,0x9c,25,100"
    ;;
  *)
    echo "ERROR: unknown code"
    ;;
esac

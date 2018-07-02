# Source the system xinit scripts
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
  for f in /etc/X11/xinit/xinitrc.d/?* ; do
    # shellcheck source=/dev/null
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

# lock
light-locker --lock-after-screensaver 5 --lock-on-lid --lock-on-suspend &

# clipboard history in rofi
/usr/bin/greenclip daemon &

# capslock to ctrl
setxkbmap -option ctrl:nocaps
# ctrl to escape if pressed alone
xcape -e 'Control_L=Escape' -t 175

# parens for shifts, brackets for alts
xcape -e 'Shift_L=Shift_L|parenleft' -t 130
xcape -e 'Shift_R=Shift_R|parenright' -t 130
xcape -e 'Alt_L=Shift_L|bracketleft' -t 130
xcape -e 'Alt_R=Shift_R|bracketright' -t 130

# reassign ctrl key to Hyper_L, which can be added to mod3 for a spare
# modifier
xmodmap -e "clear mod3"
xmodmap -e "clear mod4"
xmodmap -e "clear control"
xmodmap -e "keycode 37 = Hyper_L"
xmodmap -e "add mod3 = Hyper_L"
xmodmap -e "add mod4 = Super_L Super_R"
xmodmap -e "add control = Control_L Control_R"

# no beeping!
xset b off

# mute all sound
amixer sset Master mute &

# powersaving
xbacklight -set 30
xset +dpms
xset dpms 1200 0 0
xautolock -time 21 -locker "${HOME}/.bin/lock_or_sleep.sh" &

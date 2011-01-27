xsetroot -cursor_name left_ptr &
xrdb -merge $HOME/.Xresources &
xrdb -merge $HOME/.Xdefaults &
$HOME/.bin/tray &
/usr/bin/VBoxClient-all &
eval `ssh-agent`
(sleep 10; xmodmap -f $HOME/.xmodmap) &
xmonad

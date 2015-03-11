# System tray
sh ~/.xmobar_scripts/trayer.sh &
# Config
xrdb -load ~/.Xresources
# Background
sh ~/.fehbg &
xcompmgr -c &
# justgetflux.com
~/AUR/xflux -z 12180
# Screensaver
/usr/bin/xscreensaver -no-splash &
# Cloud
dropboxd &
/usr/bin/megasync &
# New key bindings
setxkbmap -model pc104 -layout us,us -variant ,dvorak -option grp:alt_shift_toggle
xmodmap ~/.Xmodmap &
# Notification menu
/usr/bin/dunst -follow mouse -config ~/.dunstrc &
# Yay!
exec xmonad

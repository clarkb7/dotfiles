# System tray
sh ~/.xmobar_scripts/trayer.sh &
# Config
xrdb -load ~/.Xresources
# Background
sh ~/.fehbg &
xcompmgr -c &
# justgetflux.com
xflux -z 12180
# Screensaver
/usr/bin/xscreensaver -no-splash &
# Cloud
#dropbox &
/usr/bin/megasync &
# New key bindings
setxkbmap -model pc104 -layout us,us -variant ,dvorak -option grp:alt_shift_toggle
xmodmap ~/.Xmodmap &
# Notification menu
/usr/bin/dunst -follow mouse -config ~/.dunstrc &
# Synergy
#synergy &
# Clipboard
autocutsel -fork &
# emacs daemon
KONSOLE_DBUS_SESSION=1 emacs -nw --daemon
# Yay!
exec xmonad

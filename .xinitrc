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
# Dropbox
dropboxd &
# New key bindings
xmodmap ~/.Xmodmap &
# Notification menu
/usr/bin/dunst -follow mouse -config ~/.dunstrc &
# Yay!
exec xmonad

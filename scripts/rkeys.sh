#!/bin/sh
setxkbmap -model pc104 -layout us,us -variant ,dvorak -option grp:alt_shift_toggle
xmodmap ~/.Xmodmap

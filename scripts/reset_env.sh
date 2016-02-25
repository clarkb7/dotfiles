#!/bin/bash

INT_MON="eDP1"

function ask_mon {
    echo $(xrandr | grep ' connected' | cut -d' ' -f1 | dmenu -p ${1:-"Display"})
}

# Monitor selection
function mon_sel {
    # Get layout type
    MON=$(echo -e 'internal\nexternal\npresent\ntriple' | dmenu)
    [ "$MON" == "" ] && return
    
    if [ "$MON" == "internal" ]; then
        ~/scripts/int_mon.sh
    elif [ "$MON" == "external" ]; then
        # Get external monitor name
        EXT=$(ask_mon)
        [ "$EXT" == "" ] && return
        # Get external monitor position
        POS=$(echo -e '--left-of\n--right-of\n--above\n--below\n--same-as' | dmenu)
        [ "$POS" == "" ] && return
        ~/scripts/ext_mon.sh "$EXT" "$POS"
    elif [ "$MON" == "present" ]; then
        # Get external monitor name
        EXT=$(ask_mon)
        [ "$EXT" == "" ] && return
        # Get shared monitor resolution
        RES=$(xrandr | grep -A999 "$INT_MON" | tail -n+2 | egrep -B100 -m1 '^[^ ]' | head -n-1 | cut -d' ' -f4 | dmenu)
        [ "$RES" == "" ] && return
        ~/scripts/present_mon.sh "$EXT" $RES
    elif [ "$MON" == "triple" ]; then
        # Get monitor names
        LEFT=$(ask_mon "Left")
        [ "$LEFT" == "" ] && return
        MID=$(ask_mon "Mid")
        [ "$MID" == "" ] && return
        RIGHT=$(ask_mon "Right")
        [ "$RIGHT" == "" ] && return
        ~/scripts/trip_mon.sh "$LEFT" "$MID" "$RIGHT"
    fi
}
mon_sel

# Set keyboard layout
~/scripts/rkeys.sh

# Set background
~/.fehbg

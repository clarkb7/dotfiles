#!/bin/bash
# xrandr wrapper for adding an external monitor

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` PORT RESOLUTION"
  exit $E_BADARGS
fi
xrandr --output $1 --primary --left-of eDP1 --mode $2


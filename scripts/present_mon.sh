#!/bin/bash
# xrandr wrapper for adding an external monitor

EXPECTED_ARGS=2
E_BADARGS=65
INT_PORT=eDP1

if [ $# -lt $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` PORT RESOLUTION [INT_PORT]"
  exit $E_BADARGS
fi

xrandr --output ${3:-$INT_PORT} --mode $2 --output $1 --mode $2 --same-as ${3:-$INT_PORT}


#!/bin/bash
# xrandr wrapper for adding an external monitor

EXPECTED_ARGS=1
E_BADARGS=65
INT_PORT=eDP1
DEF_POS=--left-of

if [ $# -lt $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` PORT [POS] [INT_PORT]"
  exit $E_BADARGS
fi

xrandr --output $1 --primary --auto ${2:-$DEF_POS} ${3:-$INT_PORT}


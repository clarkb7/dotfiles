#!/bin/bash
# xrandr wrapper for adding tri monitor

EXPECTED_ARGS=2
E_BADARGS=65

if [ $# -lt $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` PORTL PORTR"
  exit $E_BADARGS
fi

xrandr --output $1 --auto --primary --left-of $2 --output $2 --auto


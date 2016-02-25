#!/bin/bash
# xrandr wrapper for adding tri monitor

EXPECTED_ARGS=3
E_BADARGS=65

if [ $# -lt $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` PORTL PORTM PORTR"
  exit $E_BADARGS
fi

xrandr --output $1 --auto --primary --left-of $2 --output $2 --auto --left-of $3 --output $3 --auto


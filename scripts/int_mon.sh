#!/bin/bash
# xrandr wrapper for removing an external monitor

INT_PORT=eDP1

xrandr --output ${1:-$INT_PORT} --auto --primary
xrandr --output HDMI1 --off --output DP2 --off

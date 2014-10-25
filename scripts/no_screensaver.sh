#!/bin/bash
# xscreensaver is not detecting full-screen applications, so I run this to prevent
#   the screensaver from activating during movies.

while true; do xscreensaver-command -deactivate; sleep 10;done


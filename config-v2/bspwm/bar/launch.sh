#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/bspwm/bar"

# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
#polybar -q bar-border -c "$DIR"/config.ini &
sleep 1
polybar -q main -c "$DIR"/config.ini &

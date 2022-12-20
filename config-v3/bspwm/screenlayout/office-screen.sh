#!/bin/sh


xrandr --output eDP --off --output HDMI-A-0 --mode 1920x1080

sleep 1s
~/.config/bspwm/bar/launch-hdmi.sh &
bspc monitor HDMI-A-0 -d 1 2 3 4 
bspc wm -r 

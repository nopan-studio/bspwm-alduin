#!/bin/sh


xrandr --output eDP --off --output HDMI-A-0 --auto

sleep 1s
~/.config/bspwm/bar/launch-hdmi.sh &
bspc monitor HDMI-A-0 -d 1 2 3 4 
bspc wm -r 

#!/bin/sh



xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --off
sleep 1s
bspc monitor eDP -d 1 2 3 4 5 6  
~/.config/bspwm/bar/launch.sh &
bspc wm -r 

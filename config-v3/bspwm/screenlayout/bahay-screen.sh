#!/bin/sh

xrandr --output eDP --primary --mode 1920x1080 --left-of HDMI-A-0 --rotate normal --output HDMI-A-0 --auto

sleep 1s
~/.config/bspwm/bar/launch.sh &
~/.config/bspwm/bar/launch-hdmi.sh &


bspc monitor eDP  -d 2 4 
bspc monitor HDMI-A-0 -d 1 3

bspc wm -r
sleep 1

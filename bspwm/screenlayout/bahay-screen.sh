#!/bin/sh

xrandr --output eDP --primary --mode 1920x1080 --pos 1440x0 --rotate normal --output HDMI-A-0 --mode 1440x900 --pos 0x90 --rotate normal

sleep 1s
~/.config/bspwm/bar/launch.sh &
~/.config/bspwm/bar/launch-hdmi.sh &


bspc monitor eDP  -d 4 5 6 
bspc monitor HDMI-A-0 -d 1 2 3

bspc wm -r
sleep 1

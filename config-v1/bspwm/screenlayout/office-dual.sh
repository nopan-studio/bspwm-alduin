#!/bin/sh

bspc monitor eDP  -d 1 2 3

sleep 2s
~/.config/bspwm/bar/launch.sh &
~/.config/bspwm/bar/launch-hdmi.sh &


xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 1920x0 --rotate normal

bspc wm -r
sleep 1
bspc monitor HDMI-A-0 -d 4 5 6

#!/bin/sh

xrandr --output eDP --primary --mode 1920x1080 --pos 1440x0 --rotate normal --output HDMI-A-0 --mode 1440x900 --pos 0x90 --rotate normal

sleep 1s
~/.config/bspwm/bar/launch.sh &
~/.config/bspwm/bar/launch-hdmi.sh &


bspc monitor eDP  -d IV V VI 
bspc monitor HDMI-A-0 -d I II III

bspc wm -r
sleep 1

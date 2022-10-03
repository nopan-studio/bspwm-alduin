#!/bin/sh


bspc monitor eDP -d I II III IV V VI 

sleep 2s
~/.config/bspwm/bar/launch.sh &

xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --off

bspc wm -r 

#!/bin/sh

bspc monitor HDMI-A-0 -d I II III IV V VI

sleep 2s
~/.config/bspwm/bar/launch-hdmi.sh &

xrandr --output eDP --off --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal

bspc wm -r 
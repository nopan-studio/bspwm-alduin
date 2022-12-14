#!/bin/bash

# use nitrogen wallpaper.
wallpaper=$(cat ~/.config/nitrogen/bg-saved.cfg | grep file= | sed 's/file=//')
betterlockscreen -u $wallpaper
text="lockscreen is set."
notify-send "$text"

#!/bin/bash

# reload the config for waybar
# (by egnrse)
#
# reloads the config for waybar, or starts waybar if the process can't be found


killall -SIGUSR2 waybar
# test if if was succesfull
if [ $? -eq 0 ]; then
	notify-send -u low "waybar config reloaded" &
else
	hyprctl dispatch exec waybar
	# waybar &	# use this if u dont have hyprctl
	notify-send -u low "waybar started & config reloaded" & 
fi

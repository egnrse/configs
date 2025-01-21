#!/bin/bash

# reload the config for waybar
# (https://github.com/egnrse/configs)
# (by egnrse)
#
# reloads the config for waybar, or starts waybar if the process can't be found

logfile=~/.config/waybar/waybar.log

killall -SIGUSR2 waybar
# test if if was succesfull
if [ $? -eq 0 ]; then
	notify-send -u low "waybar config reloaded" &
else
	hyprctl dispatch exec "uwsm app -- waybar >> ${logfile} 2>&1"
	# waybar &	# use this if u dont have hyprctl
	notify-send -u low "waybar started & config reloaded" & 
fi

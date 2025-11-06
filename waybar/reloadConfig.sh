#!/usr/bin/env bash

# reload the config for waybar
# (https://github.com/egnrse/configs)
# (by egnrse)
#
# reloads the config for waybar, or starts waybar if the process can't be found

logfile=~/.config/waybar/waybar.log

if [ "$1" = "hard" ]; then
	killall waybar
	retVal=1
else
	killall -SIGUSR2 waybar # send waybar the update signal
	retVal=$?
fi

# test if if was succesful
if [ $retVal -eq 0 ]; then
	notify-send -u low "waybar config reloaded" &
else
	hyprctl dispatch exec "waybar >> ${logfile} 2>&1"
	# waybar &	# use this if u dont have hyprctl
	notify-send -u low "waybar started & config reloaded" & 
fi

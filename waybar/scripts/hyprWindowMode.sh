#!/bin/bash

# looks if the active window (in hyprland) is one of the following:
# normal/floating/fullscreen1(maximized)/fullscreen2(fullscreen)/fullscreen3/there is no active window
# (or a combination of them)
# returns the result in a json that works for waybar ([n]/(f)/M/F/F/h)
# 	'[x]': it is a normal window (with x being one of the following: n,h,M,F)
# 	'(x)': it is a floating window (x: f,M,F)
# 
# 	eg. (M) means a floating window that is maximized
# also toggles the floating state of the active window, when $1="toggle"
# 
# Needs:
# 	hyprland
# 	awk
# 	grep
#
#	by egnrse (https://github.com/egnrse/configs)	

# this scripts name (used for notifications)
scriptName="hyprWindowMode.sh"


args1=$1

clientActive=$(hyprctl activewindow -j)

# === toggle ===
if [ "$args1" == "toggle" ]; then
	out=$(echo "$clientActive" | jq ".address")
	if [ "$out" = "null" ]; then
		# no active window found (eg. empty hyperland window)
		notify-send -u low -a ${scriptName} "${scriptName}: nothing to toggle" &
		exit 1
	fi
	hyprctl dispatch togglefloating
	varExit=$?
	if [ $varExit -eq 0 ]; then
		notify-send -u low -a ${scriptName} "${scriptName}: toggle" &
	else
		notify-send -a ${scriptName} "${scriptName}: toggle ERROR?"\
			"'hyprctl dispatch togglefloating' exited with status '$varExit'" &
	fi
	exit 0
fi


# === normal ===
textOutput="h"
tooltip="just hyprland"
if [ $(echo "$clientActive" | jq ".fullscreen") -eq 0 ]; then
	textOutput="n"
	tooltip="normal (f0)"
elif [ $(echo "$clientActive" | jq ".fullscreen") -eq 1 ]; then
	textOutput="M"
	tooltip="maximized (f1)"
elif [ $(echo "$clientActive" | jq ".fullscreen") -eq 2 ]; then
	textOutput="F"
	tooltip="fullscreen (f2)"
elif [ $(echo "$clientActive" | jq ".fullscreen") -eq 3 ]; then
	textOutput="F"
	tooltip="maximized and fullscreen (f3)"
fi

if [ $(echo "$clientActive" | jq ".floating") == "true" ]; then
	if [ "$textOutput" == "n" ]; then
		textOutput="f"
		tooltip="floating"
	else
		tooltip="${tooltip} and floating"
	fi
	textOutput="(${textOutput})"
else
	textOutput="[${textOutput}]"
fi

echo "{\"text\":\"${textOutput}\", \"tooltip\":\"${tooltip}\"}"

# for debugging
#notify-send -u low "{\"text\":\"${textOutput}\", \"tooltip\":\"${tooltip}\"}"

#!/bin/bash

# looks if a window (in hyprland) is one of the following:
# normal/floating/fullscreen1(maximized)/fullscreen2(fullscreen)/fullscreen3
# (or a combination of them)
# returns the result in a json that works for waybar ([n]/(f)/M/F/F)
# 	'[x]': it is a normal window (with x being one of the following: n,M,F)
# 	'(x)': it is a floating window (x: f,M,F)
# 	eg. (M) means a floating window that is maximized
# 
# Needs:
# 	hyprland
# 	awk
# 	grep
#
#	by egnrse (https://github.com/egnrse/configs)	
#

# awk -v RS='': Treats each paragraph as a record.
clientActive=$(hyprctl clients | awk -v RS='' '/focusHistoryID: 0/')

if echo "$clientActive" | grep -q "fullscreen: 0"; then
	textOutput="n"
	tooltip="normal (f0)"
elif echo "$clientActive" | grep -q "fullscreen: 1"; then
	textOutput="M"
	tooltip="maximized (f1)"
elif echo "$clientActive" | grep -q "fullscreen: 2"; then
	textOutput="F"
	tooltip="fullscreen (f2)"
elif echo "$clientActive" | grep -q "fullscreen: 3"; then
	textOutput="F"
	tooltip="maximized and fullscreen (f3)"
fi

if echo "$clientActive" | grep -q "floating: 1"; then
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

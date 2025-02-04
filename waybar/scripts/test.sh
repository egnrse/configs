#!/bin/env bash

# looks if the active window (in hyprland) is one of the following:
# 	normal		: n	(also adds '[]' around the state letter)
# 	floating	: f	(also adds '()' around the state letter)
# 	maximized	: M
# 	fullscreen: F	(also for fullscreen and maximized)
# 	empty WS	: h (hyprland)
# 	pseudo		: P
# 	pinned		: p
# (or a combination of them)
# 	eg. (M) means a floating window that is maximized
# returns the result in a json that works for waybar
# OR toggles the floating state of the active window, when $1="toggle"
# 
# Needs:
# 	hyprland
# 	awk
# 	grep
# 	jq
#
#	by egnrse (https://github.com/egnrse/configs)	

# this scripts name (used for notifications)
scriptName="hyprWindowMode.sh"

# expire time of notifications in ms (see -t in `man notify-send`)
notification_time=1000
# shows hints if 1
show_hints=1
# sleeptime between checks (0 disables looping)
loopTime=0.01


args1=$1


# === toggle ===
# toggle floating state of the active window
if [ "$args1" == "toggle" ]; then
	out=$(echo "$clientActive" | jq ".address")
	if [ "$out" = "null" ]; then
		# no active window found (eg. empty hyperland window)
		notify-send -u low -a ${scriptName} -t ${notification_time} "${scriptName}: nothing to toggle" &
		exit 1
	fi
	hyprctl dispatch togglefloating
	varExit=$?
	if [ $varExit -eq 0 ]; then
		notify-send -u low -a ${scriptName} -t ${notification_time} "${scriptName}: toggle floating" &
		#notify-send -u low -a ${scriptName} -r 1683 "toggle floating" &
	else
		notify-send -a ${scriptName} "${scriptName}: toggle ERROR?"\
			"'hyprctl dispatch togglefloating' exited with status '$varExit'" &
	fi
	exit 0
fi


# === normal ===
# update waybar module (given $clientActive)
update() {
	textOutput="h"
	tooltip="just hyprland"
	if [ $(echo "$clientActive" | jq ".fullscreen") == "0" ]; then
		textOutput="n"
		tooltip="normal (f0)"
	fi
	if [ $(echo "$clientActive" | jq ".fullscreen") == "1" ]; then
		textOutput="M"
		tooltip="maximized (f1)"
	elif [ $(echo "$clientActive" | jq ".fullscreen") == "2" ]; then
		textOutput="F"
		tooltip="fullscreen (f2)"
	elif [ $(echo "$clientActive" | jq ".fullscreen") == "3" ]; then
		textOutput="F"
		tooltip="maximized and fullscreen (f3)"
	elif [ $(echo "$clientActive" | jq ".pinned") == "true" ]; then
		textOutput="p"
		tooltip="pinned"
	fi
	# pseudo
	pseudo=0
	if [ $(echo "$clientActive" | jq ".pseudo") == "true" ]; then
		if [ "$textOutput" = "n" ]; then
			textOutput="P"
		fi
		pseudo=1
	fi

	# floating
	floating=0
	if [ $(echo "$clientActive" | jq ".floating") == "true" ]; then
		floating=1
		case "$textOutput" in
			# normal
			"n"|"P")
				textOutput="f"
				tooltip="floating"
				;;
			# maximized/fullscreen/pinned
			*)
				tooltip="${tooltip} and floating"
				;;
		esac
	fi

	if [ "${pseudo}" -eq 1 ]; then
		tooltip="${tooltip}\n[pseudo]"
	fi
	if [ $show_hints -eq 1 ]; then
		if [ ! "${textOutput}" = "h" ]; then
			tooltip="${tooltip}\n<span font_size='80%'>(toggle floating)</span>"
		fi
	fi


	if [ "${floating}" -eq 1 ]; then
		textOutput="(${textOutput})"
	else
		textOutput="[${textOutput}]"
	fi
	echo "{\"text\":\"${textOutput}\", \"tooltip\":\"${tooltip}\"}"
}

# first run
clientActive=$(hyprctl activewindow -j)
update

# for debugging
#notify-send -u low "{\"text\":\"${textOutput}\", \"tooltip\":\"${tooltip}\"}"

# loop 
looping=true
if [[ ${loopTime} = 0 ]]; then
	looping=false
fi
while $looping; do
	clientActiveOld="${clientActive}"
	clientActive=$(hyprctl activewindow -j)
	if [ ! "$clientActive" = "$clientActiveOld" ]; then
		update
	fi
	sleep $loopTime
done


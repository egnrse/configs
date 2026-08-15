#!/usr/bin/env bash

# control hyrpsunset (returns a json, that works for waybar)
# $1:
#   - toggle: toggles identity
#   - up/down: increases/decreases temperature
#   - reset: reset to profile
#
# Dependencies:
# 	- hyprctl (from hyprland, for the IPC)
#
#	by egnrse (https://github.com/egnrse/configs)


## settings
strikeTemp=1		# strikethrough temperature if identity is enabled
hideGamma=1			# hide the gama text
identityHint=1		# show a text if identity is enabled
show_hints=0		# shows hints


## fetch values
fetchValues() {
	export temp="$(hyprctl hyprsunset temperature)"
	export gamma="$(hyprctl hyprsunset gamma)"

	# as there is no way to query the state of identity directly, we store it in the temperature value
	# temp%2 = 0: identity false; temp%2 = 1: identity true
	export disabled=$(( temp%2 ))
	#hyprctl hyprsunset reset identity
	#disabled="$(hyprctl hyprsunset profile | grep Identity | awk '{print $2}')"
}

fetchValues

## arguments
case "$1" in
	"toggle")
		if [ "$disabled" == "0" ]; then
			hyprctl hyprsunset temperature $((temp+1))
			hyprctl hyprsunset identity

		else
			hyprctl hyprsunset temperature $((temp-1))
		fi
		;;
	"up")
		hyprctl hyprsunset temperature +100
		;;
	"down")
		hyprctl hyprsunset temperature -100
		;;
	"reset")
		hyprctl hyprsunset reset
		;;
	*)
		# bad args
		;;
esac

if [ -n "$1" ]; then
	fetchValues
fi


## output
# echos a waybar json
showTemp="Temp: $temp"
if [ "$disabled" == "0" ]; then
	#text="󰈈"
	text="󰛐"
else
	#text="󰈉"
	text="󰛑"
	[ $strikeTemp -eq 1 ] && showTemp="<s>Temp: $temp</s>"
fi

tooltip="$showTemp"
[ $hideGamma -ne 1 ] && tooltip="${tooltip}\nGamma: $gamma"
[ $identityHint -eq 1 ] && [ "$disabled" == "1" ] && tooltip="${tooltip}\n(disabled)"
if [ $show_hints -eq 1 ]; then
	tooltip="${tooltip}\n<span font_size='60%'>(click to toggle)</span>"
fi
echo "{\"text\":\"${text}\", \"tooltip\":\"${tooltip}\"}"

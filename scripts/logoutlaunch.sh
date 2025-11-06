#!/usr/bin/env bash

# launches wlogout with custom styling, or closes it if it is already running
# in one of two modes (selected with arg $1):
# 	1: 6 options
# 	2: 4 options
#
# Needs:
# 	- wlogout
# 	- hyprctl (from hyprland, to get the screenresolution)
# 	- jq
# 	- and the launched theme files (layout-*/style-*.css)
# 	- (style-*.css needs egnrseTheme.css to work)
#
#	edited by egnrse (https://github.com/egnrse/configs)
#	(maybe original?: https://github.com/prasanthrangan/hyprdots)

# used for notifications
scriptName="logoutlaunch.sh"

# configuration directories
config="$HOME/.config/wlogout"

# Check if wlogout is already running, and terminate if so
if pgrep -x "wlogout" >/dev/null; then
  pkill -x "wlogout"
  exit 0
fi

# test if package ($1) is available (notifies the user if not)
available() {
	package=$1
	if ! pacman -Q "${package}" >>/dev/null 2>&1; then
		echo "${scriptName}: package '${package}' missing"
		notify-send "${scriptName}: package '${package}' missing" &
		return 1
	fi
	return 0
}
available wlogout
available hyprland
available jq


# style selection
[ -z "${1}" ] || style_index="${1}"
layout="${config}/layout-${style_index}"
style="${config}/style-${style_index}.css"

# Fallback if style or layout file is not found
if [ ! -f "${layout}" ] || [ ! -f "${style}" ]; then
	echo "${scriptName}: Config ${style_index} not found (in '${config}/')"
	notify-send -a ${scriptName} "${scriptName}: Config '${style_index}' not found"\
		"(in '${config}/')" &
	style_index=1
	layout="${config}/layout-${style_index}"
	style="${config}/style-${style_index}.css"
fi

# Detect monitor resolution and scaling
screen_width=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
screen_height=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
scale_factor=$(hyprctl -j monitors | jq '.[] | select(.focused == true) | .scale' | sed 's/\.//')

# Scale configuration based on selected layout
case "${style_index}" in
	1)
		button_columns=3
		export x_margin=$((screen_width * 32 / scale_factor))
		export y_margin=$((screen_height * 28 / scale_factor))
		export border_rad=$((screen_height / scale_factor /3))

  		#export hover_margin=$((screen_height * 33 / scale_factor))
  		;;
	2)
		button_columns=2
		export x_margin=$((screen_width * 38 / scale_factor))
		export y_margin=$((screen_height * 28 / scale_factor))
		export border_rad=$((screen_height / scale_factor /3))

		# currently not used
		#export x_hover=$((screen_width * 35 / scale_factor))
		#export y_hover=$((screen_height * 23 / scale_factor))
		;;
esac

# Substitute variables in the style template
style_content=$(envsubst <"$style")

# Launch wlogout with the specified layout and style
wlogout -b "${button_columns}" -c 0 -r 0 -m 0 --layout "${layout}" --css <(echo "${style_content}") --protocol layer-shell


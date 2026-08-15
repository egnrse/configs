#!/usr/bin/env bash

# launches wlogout with custom styling (or closes it, if it's already running)
# in one of two modes (selected with arg $1):
# 	1: 6 options
# 	2: 4 options
#
# Needs:
# 	- wlogout
# 	- hyprctl (from hyprland, to get the screen resolution)
# 	- jq      (json reading)
# 	- bc      (floating point math)
# 	- the launched theme files (layout-*/style-*.css)
# 	- (style-*.css needs egnrseTheme.css to work)
#
#	edited by egnrse (https://github.com/egnrse/configs)
#	(maybe original?: https://github.com/prasanthrangan/hyprdots)

## SETTINGS
# size of the buttons
button_size=270

# configuration directory (should hold the layout/style files)
config="$HOME/.config/wlogout"
# used for notifications
scriptName="logoutlaunch.sh"
# fraction detail (multiply fractions by this and cutoff the remainder)
fractionHelper=100


## MAIN
# terminate wlogout if it's already running
if pgrep -x "wlogout" >/dev/null; then
	pkill -x "wlogout"
	echo "exiting wlogout"
	exit 0
fi

# test if package ($1) is available (notifies the user if not)
available() {
	package=$1
	if ! pacman -Q "${package}" >>/dev/null 2>&1; then
		echo "${scriptName}: package '${package}' is missing"
		notify-send "${scriptName}: package '${package}' is missing" &
		return 1
	fi
	return 0
}
available wlogout
available hyprland
available jq
available bc


# style selection
[ -z "${1}" ] || style_index="${1}"
layout="${config}/layout-${style_index}"
style="${config}/style-${style_index}.css"

# fallback if style or layout file is not found
if [ ! -f "${layout}" ] || [ ! -f "${style}" ]; then
	echo "${scriptName}: Config ${style_index} not found (in '${config}/')"
	notify-send -a ${scriptName} "${scriptName}: Config '${style_index}' not found"\
		"(in '${config}/')" &
	style_index=1
	layout="${config}/layout-${style_index}"
	style="${config}/style-${style_index}.css"
fi

# detect monitor resolution and scaling
screen_width=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
screen_height=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
scale_factor=$(hyprctl -j monitors | jq '.[] | select(.focused == true) | .scale')

# bash does not like fractions (multiply and cutoff number)
scale_factor=$(echo "$scale_factor * $fractionHelper" | bc | sed 's/\..*//')


# scale configuration based on selected layout
case "${style_index}" in
	1)
		button_columns=3
  		;;
	2)
		button_columns=2
		;;
esac

buttons_amount=$(cat $layout | jq -s 'length')	# count the amount of options in the layout
button_rows=$(( (buttons_amount+button_columns-1)/button_columns))

# desktop size / scale - space for buttons = 2 margins (left+right/top+bottom)
export x_margin=$(echo "($fractionHelper*$screen_width/$scale_factor  - $button_size*$button_columns)/2" | bc)
export y_margin=$(echo "($fractionHelper*$screen_height/$scale_factor - $button_size*$button_rows)/2" | bc)
export border_rad=5

# substitute variables in the style template
style_content=$(envsubst <"$style")

# launch wlogout with the specified layout and style
wlogout -b "${button_columns}" -c 0 -r 0 -m 0 --layout "${layout}" --css <(echo "${style_content}") --protocol layer-shell


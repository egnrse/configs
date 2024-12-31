#!/usr/bin/env bash

# launches wlogout with custom styling, or closes it if it is already running
# in one of two modes (selected with args $1):
# 	1: 6 options
# 	2: 4 options
#
# Needs:
# 	- wlogout
# 	- hyprctl (to get the screenresolution)
# 	- and the launched theme files (layout-*/style-*.css)
# 	- (style-*.css needs egnrseTheme.css to work)
#
#	edited by egnrse (https://github.com/egnrse/configs)
#	(maybe original?: https://github.com/sejjy/mechabar/)

# Check if wlogout is already running, and terminate if so
if pgrep -x "wlogout" >/dev/null; then
  pkill -x "wlogout"
  exit 0
fi

# Define configuration directories
config="$HOME/.config/wlogout"

# Style selection
[ -z "${1}" ] || style_index="${1}"
layout="${config}/layout-${style_index}"
style="${config}/style-${style_index}.css"

# Fallback if style or layout file is not found
if [ ! -f "${layout}" ] || [ ! -f "${style}" ]; then
  echo "ERROR: Config ${style_index} not found..."
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

  #export hover_margin=$((screen_height * 33 / scale_factor))
  ;;
2)
  button_columns=2
  export x_margin=$((screen_width * 38 / scale_factor))
  export y_margin=$((screen_height * 28 / scale_factor))

  # currently not used
  #export x_hover=$((screen_width * 35 / scale_factor))
  #export y_hover=$((screen_height * 23 / scale_factor))
  ;;
esac

# Substitute variables in the style template
style_content=$(envsubst <"$style")

# Launch wlogout with the specified layout and style
wlogout -b "${button_columns}" -c 0 -r 0 -m 0 --layout "${layout}" --css <(echo "${style_content}") --protocol layer-shell


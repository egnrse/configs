#!/bin/env bash
# copy part of the screen into the system clipboard
# Needs: grim slurp wl-clipboard
# (by egnrse)

# used for notifications
scriptName="screenshot.sh"

arg1=$1

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
available grim
available slurp


## actually do the screenshot
if [ -z "${arg1}" ]; then
	grim -g "$(slurp)" - | wl-copy
else
	echo "unkown argument '${arg1}', this script does not take any arguments."
fi

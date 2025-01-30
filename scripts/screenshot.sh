#!/bin/env bash
# copy part of the screen into the system clipboard
# Needs: grim slurp wl-clipboard
# (by egnrse)

arg1=$1

if [ -z "${arg1}" ]; then
	grim -g "$(slurp)" - | wl-copy
else
	echo "unkown argument '${arg1}', this script does not take any arguments."
fi

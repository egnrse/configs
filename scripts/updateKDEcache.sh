#!/bin/env bash
# updates the KService desktop-file system configuration cache
# (by egnrse)
#
# (see `man 8 kbuildsycoca6`)

if ! pacman -Q archlinux-xdg-menu >/dev/null 2>&1; then
	echo "'archlinux-xdg-menu' not found this might not work, install it or change the 'XDG_MENU_PREFIX' within this script."
	notify-send "'archlinux-xdg-menu' not found this might not work"\
		"install it or change the 'XDG_MENU_PREFIX' within this script." &
fi
XDG_MENU_PREFIX=arch-
kbuildsycoca6 --noincremental

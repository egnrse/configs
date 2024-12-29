#!/usr/bin/bash

# checks packages for updates (official/pacman, AUR and flatpak packages)
# returns the result in a json, that works for waybar
# helps with updating packages if $1 is "up"/"update"/"upgrade" (runs $sysUpdate_helper)
# Needs:
# 	pacman-contrib (for checkupdates)
# 	[an aur_helper (eg. yay)]
#	[flatpak]
#	[sysUpgrade.sh (a custom script)]
#
#	by egnrse (https://github.com/egnrse/configs)
#	(maybe original?: https://github.com/sejjy/mechabar/)

# ====== SETTINGS ======
# if this script does not know your aur_helper, u can set one here
custom_aur_helper=""

# used for notifications
scriptName="packageUpdates.sh"
# the terminal you want to use for the system update helper
# it is advised to set $TERMINAL as an environment variable (eg. in ~/.bashrc)
sysUpdate_term=$TERMINAL
# the system upgrade helper script
sysUpdate_helper="$HOME/.config/waybar/scripts/sysUpgrade.sh"

# ==== SETTINGS END ====

#set -x	# verbose debugging

# Check release
if [ ! -f /etc/arch-release ]; then
  exit 0
fi

# test if a package is installed
# (with pacman, flatpak or if the command can be found)
# returns 0 if it was found or 1 else
pkg_installed() {
	local pkg=$1
	if pacman -Qi "${pkg}" &>/dev/null; then
		return 0
	elif pacman -Qi "flatpak" &>/dev/null && flatpak info "${pkg}" &>/dev/null; then
		return 0
	elif command -v "${pkg}" &>/dev/null; then
		return 0
	else
		return 1
	fi
}

# test if ${custom_aur_helper}, yay or paru is installed (in this order)
# writes the first one that is found to stdout
# returns 0 on a found aur_helper or 1 else
get_aur_helper() {
	local aur_helper=""
	if pkg_installed "${custom_aur_helper}"; then
		aur_helper="${custom_aur_helper}"
	elif pkg_installed yay; then
		aur_helper="yay"
	elif pkg_installed paru; then
		aur_helper="paru"
	else
		notify-send "${scriptName}: installed aur_helper not found!"\
			"You can set one with custom_aur_helper, a variable within the script." &
		return 1
	fi
	echo ${aur_helper}
	return 0
}


export aur_helper=$(get_aur_helper)

# ====== UPDATE ======
# update packages
# by starting ${sysUpdate_helper} in a new terminal
var1=$1
if [ "$var1" == "up" ] || [ "$var1" == "update" ] || [ "$var1" == "upgrade" ]; then
	if [ -z "$sysUpdate_term" ]; then
		notify-send "${scriptName}: 'terminal_run' not set" \
			"Set 'terminal_run' in this script to use 'update'|'upgrade'."
	else
		$sysUpdate_term --title "System Upgrade" -e ${sysUpdate_helper} ${aur_helper}
	fi
fi


# ====== CHECK ======
# check for Official/Pacman updates
official_updates=0
# test if checkupdates is available
if command -v "checkupdates" >/dev/null 2>&1; then
	official_updates=$(checkupdates | wc -l)
else
	notify-send "${scriptName}: checkupdates not found"\
		"This script will not check for official/pacman updates without it." &
fi

# check for AUR updates
if [ $? -eq 0 ]; then
	aur_updates=$(${aur_helper} -Qua | wc -l)
else
	aur_updates=0
fi

# check for Flatpak updates
pacman -Qs flatpak >/dev/null 2>&1
if [ $? -eq 0 ]; then
	flatpak_updates=$(flatpak remote-ls --updates | wc -l)
else
	flatpak_updates=0
fi


# ====== OUTPUT ======
# module and tooltip (for waybar)
total_updates=$((official_updates + aur_updates + flatpak_updates))
if [ $total_updates -eq 0 ]; then
	text="󰸟"
	tooltip="Packages are up to date"
else
	if [ -z "$aur_helper" ]; then
		aur_helper="not found"
	fi
	tooltip="Official:  $official_updates\nAUR ($aur_helper): $aur_updates\nFlatpak:   $flatpak_updates"
	text="󰞒"
fi

#tooltip="${tooltip}\n(launch system update helper)"

echo "{\"text\":\"${text}\", \"tooltip\":\"${tooltip}\"}"

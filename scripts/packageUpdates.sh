#!/usr/bin/bash

# checks packages for updates (official-/pacman-, AUR- and flatpak-packages)
# returns the result in a json, that works for waybar
# helps with updating packages if '-u' is given or $1 is "up"/"update"/"upgrade" (runs $sysUpgrade_helper)
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

# how many updates must be available to show the update icon
show_when=10
# shows a hint (for the sysupdater) when 1 
show_hints=1

# used for notifications
scriptName="packageUpdates.sh"
# the terminal you want to use for the system update helper
# it is advised to set $TERMINAL as an environment variable (eg. in ~/.bashrc)
sysUpgrade_term=$TERMINAL
# the system upgrade helper script
sysUpgrade_helper="$HOME/.config/scripts/sysUpgrade.sh"

# ==== SETTINGS END ====

#set -x	# verbose debugging


# ==== handle args ====
# legacy handling
args1=$1
if [ "$args1" == "up" ] || [ "$args1" == "update" ] || [ "$args1" == "upgrade" ]; then
	notify-send -a ${scriptName} "${scriptName}: using deprecated args"\
		"usage: ${scriptName} [-u|-?]\nYou should use -u to launch the sysUpgrade_helper."
	upgrade="true"
else
	upgrade="false"
fi
while getopts "u?" opt; do
	case $opt in
		u) 
			# launch upgrade
			upgrade="true"
			;;
		?) 
			# print usage
			echo "checks packages for updates (official-/pacman-, AUR- and flatpak-packages)"
			echo "returns the result in a json, that works for waybar"
			echo "  -u: helps with updating packages (launches sysUpgrade_helper)"
			echo "  -?: shows this text"
			echo "usage: ${scriptName} [-u|-?]"
			exit 0
			;;
		\?)
			# invalid syntax: print usage
			echo "usage: ${scriptName} [-u|-?]: setting -u launches the sysUpgrade_helper"
			exit 2
			;;
	esac
done

# Check release
if [ ! -f /etc/arch-release ]; then
  exit 1
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
# by starting ${sysUpgrade_helper} in a new terminal
if [ "$upgrade" == "true" ]; then
	if [ -z "$sysUpgrade_term" ]; then
		# the value is empty
		notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_term' not set" \
			"Set 'sysUpgrade_term' in this script to use 'update'|'upgrade'." &
	elif ! command -v $sysUpgrade_term >/dev/null 2>&1; then
		# 'command' does not find sysUpgrade_term
		notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_term' not valid" \
			"Did not find '${sysUpgrade_term}' as a valid command. Set it in this script to use 'update'|'upgrade'." &
	elif ! command -v $sysUpgrade_helper >/dev/null 2>&1; then
		# the sysUpgrade_helper does not exist
		notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_helper' not found" \
			"Did not find '${sysUpgrade_helper}' as a valid command. Set it in this script to use 'update'|'upgrade'." &
	else
		# save the output of the next command
		output=$(
			## CHANGE ME
			# this might need to change for different terminals	
			#$sysUpgrade_term --title "System Upgrade" -e ${sysUpgrade_helper} ${aur_helper}
			$sysUpgrade_term --title "System Upgrade" -e ${sysUpgrade_helper} ${aur_helper} \
		2>&1 )

		returnVal=$?
		# test for errors
		if [ $returnVal -ne 0 ]; then
			echo "'sysUpgrade_helper' might have failed to start"
			notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_helper' might have failed to start" \
				"Try looking into '## CHANGE ME' in ${scriptName}.\nThe command exited with status: ${returnVal}\nThe ouput:\n$output" &
		fi
	fi

	exit 0
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
	tooltip="Packages are up to date"
else
	if [ -z "$aur_helper" ]; then
		aur_helper="not found"
	fi
	tooltip="Official:  $official_updates\nAUR ($aur_helper): $aur_updates\nFlatpak:   $flatpak_updates"
	if [ $show_hints -eq 1 ]; then
		tooltip="${tooltip}\n<span font_size='80%'>(click to upgrade)</span>"
	fi
fi
if [ $total_updates -ge $show_when ]; then
	text="󰞒"
else
	text="󰸟"
fi

#tooltip="${tooltip}\n(launch system update helper)"

echo "{\"text\":\"${text}\", \"tooltip\":\"${tooltip}\"}"

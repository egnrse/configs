#!/usr/bin/env bash

# checks packages for updates (official-/pacman-, AUR- and flatpak-packages)
# returns the result in a json, that works for waybar
# helps with updating packages if '-u' is given or $1 is "up"/"update"/"upgrade" (runs $sysUpgrade_helper)
#
# Custom Signals:
# 	USR1: check for updates now
# 	USR2: reread the managementFile
#
# Dependencies:
# 	pacman-contrib (for checkupdates)
# 	sed (for file parsing)
# 	[xdg-terminal-exec (from AUR)]
# 	[an aur_helper (eg. yay)]
#	[flatpak]
#	[sysUpgrade.sh (a custom script)]
#
#	by egnrse (https://github.com/egnrse/configs)

# ====== SETTINGS ======
# time between checks (in sec)
sleepTime="3600"

# how many updates must be available to show the update icon
show_when=10
# shows a hint (for the sysupdater) in the wayubar tooltip when set to 1 
show_hints=1
# if set to 1 will not show deprecated warnings
ignore_deprecated=0

# what to show when searching for updates (needs to be an escaped json)
searchingJson="{\"text\":\"?\", \"tooltip\":\"Searching for updates\"}"

# minimal wait time between two checks (in sec)
minimalWaitTime="4"

# if this script does not find your aur_helper, u can set one here
custom_aur_helper=""

# the terminal you want to use to launch the system upgrade helper
# if not set will try to use 'xdg-terminal-exec' falling back to $TERMINAL
# it is advised to set $TERMINAL as an environment variable (eg. in ~/.bashrc)
sysUpgrade_term=	#$TERMINAL
# the system upgrade helper script
sysUpgrade_helper="$HOME/.local/share/bin/scripts/sysUpgrade.sh"

# used for notifications
scriptName="packageUpdates.sh"

# management file for multiple instances (head node PID,date of last check,output json,children PIDs)
managementFile="/tmp/${scriptName}-managementFile"

# ==== SETTINGS END ====

#set -x	# verbose debugging


# ==== handle args ====
# legacy handling
args1=$1
if [ "$args1" == "up" ] || [ "$args1" == "update" ] || [ "$args1" == "upgrade" ]; then
	if [ $ignore_deprecated -ne 1 ]; then
		echo -e "${scriptName}: using deprecated args\n usage: ${scriptName} [-u|-?]\n You should use -u to launch the sysUpgrade_helper."
		notify-send -a ${scriptName} "${scriptName}: using deprecated args"\
			"usage: ${scriptName} [-u|-?]\nYou should use -u to launch the sysUpgrade_helper."
	fi
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
	notify-send "${scriptName}: '/etc/arch-release' not found, exiting." &
	echo "${scriptName}: '/etc/arch-release' not found, exiting."
	exit 1
fi


# ==== some functions ====

# test if a package is installed
# (with pacman, flatpak or if the command can be found)
# returns 0 if it was found or 1 else
pkg_installed() {
	local pkg=$1
	if pacman -Q "${pkg}" &>/dev/null; then
		return 0
	elif pacman -Q "flatpak" &>/dev/null && flatpak info "${pkg}" &>/dev/null; then
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

# (over-)write a line in a file
# usage: writeLine <text to write> <line number> <target file>
writeLine() {
	local text=$1
	local line=$2
	local file=$3

	# make sure the file exists
	if ! [ -f "$file" ]; then
		echo "" >> $file
	fi
	# append empty lines until the file is long enough
	while [ $(wc -l < "$file") -lt "$line" ]; do
		echo "" >> ${file}
	done
	# replace the specified line (make the string save first)
	escaped_text=$(printf '%s\n' "$text" | sed 's/[&/\]/\\&/g')
	sed -i "${line}s/.*/${escaped_text}/" ${file}
}

# test which terminal to use to launch the system upgrade helper (only used for '-u'/'upgrade')
# show error messages if it fails
# returns 0: xdg-terminal-exec, 1: sysUpgrade_term, 2: error
which_term() {
	# check for xdg-terminal-exec
	if command -v xdg-terminal-exec >/dev/null 2>&1 && [ -z "$sysUpgrade_term" ]; then
		# use xdg-terminal-exec if it exist and there is no custom terminal set
		#echo "xdg-terminal-exec"
		return 0
	# set sysUpgrade_term to $TERMINAL
	elif [ -z "$sysUpgrade_term" ] && [ -n "$TERMINAL" ]; then
		echo -e "${scriptName}: trying to start with '\$TERMINAL -e'\n 'sysUpgrade_term' not set or empty"
		notify-send -a ${scriptName} "${scriptName}: trying to start with '\$TERMINAL -e'"\
			"'sysUpgrade_term' not set or empty, "
		sysUpgrade_term=$TERMINAL
	fi
	# test sysUpgrade_term
	if [ -z "$sysUpgrade_term" ]; then
		# the value is empty
		echo -e "${scriptName}: 'sysUpgrade_term' not set\nInstall 'xdg-terminal-exec' or set 'sysUpgrade_term' in this script to use 'update'|'upgrade'."
		notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_term' not set" \
			"Install 'xdg-terminal-exec' or set 'sysUpgrade_term' in this script to use 'update'|'upgrade'." &
	elif ! command -v $sysUpgrade_term >/dev/null 2>&1; then
		# 'command' does not find sysUpgrade_term
		echo -e "${scriptName}: 'sysUpgrade_term' not valid\nDid not find '${sysUpgrade_term}' as a valid command. Set it in this script to use 'update'|'upgrade'.\n You can also install 'xdg-terminal-exec' and set '\$sysUpgrade_term' to and empty value."
		notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_term' not valid" \
			"Did not find '${sysUpgrade_term}' as a valid command. Set it in this script to use 'update'|'upgrade'.\n You can also install 'xdg-terminal-exec' and set '\$sysUpgrade_term' to and empty value." &
	elif ! command -v $sysUpgrade_helper >/dev/null 2>&1; then
		# the sysUpgrade_helper does not exist
		echo -e "${scriptName}: 'sysUpgrade_helper' not found\nDid not find '${sysUpgrade_helper}' as a valid command. Set it in this script to use 'update'|'upgrade'." &
		notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_helper' not found" \
			"Did not find '${sysUpgrade_helper}' as a valid command. Set it in this script to use 'update'|'upgrade'." &
	else
		#echo "${sysUpgrade_term} -e"
		return 1
	fi
	# return an error
	return 2
}


export aur_helper=$(get_aur_helper)

# ====== UPGRADE ======
# upgrade packages
# by starting ${sysUpgrade_helper} in a new terminal
if [ "$upgrade" == "true" ]; then
	# test how to execute the upgrade helper
	which_term		# returns 0,1 or 2
	term=$?
	case $term in
		0)
		# use xdg-terminal-exec
			# save the output of the next command and show it in case of an error
			output=$(
				xdg-terminal-exec ${sysUpgrade_helper} ${aur_helper} \
			2>&1 )
			returnVal=$?
			;;
		1)	
		# use $sysUpgrade_term -e
			# save the output of the next command
			output=$(
				## CHANGE ME
				# this might need to change for different terminals	
				#$sysUpgrade_term --title "System Upgrade" -e ${sysUpgrade_helper} ${aur_helper}
				$sysUpgrade_term -e ${sysUpgrade_helper} ${aur_helper} \
			2>&1 )
			returnVal=$?
			;;
		2)
		# error (eg. no command found)
			echo "${scriptName}: exiting as no valid terminal was found. (install xdg-terminal-exec or set '\$sysUpgrade_term')"
			exit 1
			;;
		*)
			echo "Invalid return value from 'which_term()' in ${scriptName}."
			exit 1
			;;
	esac
	# test for errors
	if [ $returnVal -ne 0 ]; then
		echo "'sysUpgrade_helper' might have failed to start"
		notify-send -a ${scriptName} "${scriptName}: 'sysUpgrade_helper' might have failed to start" \
			"Try looking into '## CHANGE ME' in ${scriptName}.\nThe command exited with status: ${returnVal}\nThe ouput:\n$output" &
	fi
	exit 0
fi


# ====== CHECK FOR UPDATES ======
# check for updates (echos a waybar json)
checkUpdates() {
	## CHECK
	# check for Official/Pacman updates
	official_updates=0
	# test if checkupdates is available
	if command -v "checkupdates" >/dev/null 2>&1; then
		official_updates=$(checkupdates | wc -l)
	else
		echo -e "${scriptName}: checkupdates not found\n This script will not check for official/pacman updates without it."
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

	## OUTPUT
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

	echo "{\"text\":\"${text}\", \"tooltip\":\"${tooltip}\"}"

}

# check $managementFile for head nodes PID
checkHead() {
	headNode=0	# if we are the head node (0:no, 1:yes)
	if [ -f "$managementFile" ]; then
		local headPID="$(head -n1 ${managementFile})"
		if [ "$headPID" = "$$" ]; then
			headNode=1
		# check if the head nodes PID is up to date
		elif ! kill -0 "$headPID" 2>/dev/null; then
			sed -i "1s/.*/$$/" ${managementFile}
			headNode=1
		fi
	else
		writeLine "$$" 1 ${managementFile}
		headNode=1
	fi	
	if [ "$headNode" -eq 1 ]; then
		trap 'checkUpdatesTest signal' USR1	# search for new updates
		trap 'rm -f "$managementFile"' EXIT
	fi
	# sadly inverted return values
	return $headNode
}

# add selfs PID to the managementFile as a child node
addChildPID() {
	while [ $(wc -l < "$managementFile") -lt "4" ]; do
		echo "" >> ${managementFile}
	done
	# append PID of self to children list
	PID="$$"
	sed -i "4s/$/ $PID/" "${managementFile}"
}

# send USR2 to all children (updates the childrens PID list in the managementFile)
updateChildren() {
	children=$(sed -n '4p' "$managementFile")

	for child in $children; do
		# check if they still exists
		if kill -0 "$child" 2>/dev/null; then
			kill -USR2 $child
		else
			# delete the PID and remove leftover spaces
			sed -i "4s/\b$child\b//g;4s/  */ /g;4s/^ *//;4s/ *$//" "${managementFile}"
		fi
	done
}

# read data in managementFile and update self acordingly
readManagementFile() {
	if [ "$headNode" -eq 1 ]; then
		# check for a faulty failover
		if checkHead; then
			addChildPID
		fi
	fi
	updatesJson=$(sed -n '3p' "$managementFile")
	echo "$updatesJson"
}

# check if we should check for updates 
checkUpdatesTest() {
	lastUpdateTime=$(sed -n '2p' "$managementFile")
	lastUpdateTime=${lastUpdateTime:-0}
	nowTime=$(date +%s)
	diffTime=$(( nowTime - lastUpdateTime ))
	#echo $diffTime
	
	if [ "$diffTime" -gt $minimalWaitTime ]; then
		writeLine "$(date +%s)" 2 ${managementFile}
		
		# only show the question mark
		if [[ "$1" = "signal" || "$1" = "started" ]]; then
			writeLine "$searchingJson" 3 ${managementFile}
			updateChildren
			echo $searchingJson
		fi

		updatesJson="$(checkUpdates)"
		writeLine "$updatesJson" 3 ${managementFile}
		updateChildren
		echo "$updatesJson"
	fi
}

# ====== startup ======
headNode=0	# if we are the head node (0:no, 1:yes)

checkHead
if [ "$headNode" -eq 0 ]; then
	addChildPID
	readManagementFile
else
	checkUpdatesTest started
fi

trap 'readManagementFile' USR2	# look for updates in the managementFile


while true; do
	if [ "$headNode" -eq 1 ]; then
		checkUpdatesTest
	fi
	if checkHead; then
		# look if we are in the file
		if ! grep -qw "$$" "${managementFile}"; then
			addChildPID
		fi
	fi
	sleep $sleepTime &
	wait $!
done


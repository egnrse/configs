#!/usr/bin/bash

# helps with upgrading packages (for official-/pacman-, AUR- and flatpak-packages)
# also helps with some system maintenance:
# 	- resolve configs (pacdiff)
# 	- pacman cache cleaning (paccache)
# args: $1=aur_helper
# Needs:
# 	pacman-contrib (for pacdiff, paccache)
# 	sudo
# 	[an aur_helper (eg. yay)]
#	[flatpak]
# 
# 	(this script is used by the packageUpdates.sh script)
#	by egnrse (https://github.com/egnrse/configs)

# u can give an aur_helper for this script to use with $1 (the first argument)
# OR set one here (with custom_aur_helper)
custom_aur_helper=""

# used for notifications
scriptName="sysUpgrade.sh"
#notify-send -a ${scriptName} "${scriptName}: installed aur_helper not set!"\
#	"Set it in the script OR give it as the first argument to this script." &

#set -x	# verbose debugging

# visual variables
underline="---------------------------------------------"
normal="\033[0m"
bold="\033[1m"

# pauses and waits for the user in different ways
# $1: ""|"pause"(or not given):pause until any button is pressed; "skip":asks to continue or skip
# $2: set a custom message
# returns: 0: success, 1: negative answer, 2: (usage) error
pause() {
	case "$1" in
		""|"pause")
			# continue with any button
			local var2=$2
			if [ -z "$2" ]; then
				var2=" press any button to continue..."
			fi
			echo "$var2"
			read -n 1 -s;
			return 0;
			;;
		"skip"|"skipY" )
			# for yes or empty (return 0) / no (return 1) questions
			local var2="$2"
			if [ -z "$2" ]; then
				var2=" continue [y] or skip [n]"
			fi
			read -p "$var2 (Y/n): " pause_answer
			case $pause_answer in
				[Yy]*|"")
					return 0;
					;;
				[Nn]*)
					return 1;
					;;
			esac
			;;
		"skipN")
			# for yes(return 0) / no or empty (return 1) questions
			local var2="$2"
			if [ -z "$2" ]; then
				var2=" continue [y] or skip [n]"
			fi
			read -p "$var2 (y/N): " pause_answer
			case $pause_answer in
				[Yy]*)
					return 0;
					;;
				[Nn]*|"")
					return 1;
					;;
			esac
			;;
		*)
			echo " ERROR (${scriptName}): faulty pause usage! bad args given to pause()"
			return 2;
			;;
	esac
}


#
# ====== START ======
#
echo "$underline"
echo -e "Welcome to ${bold}sysUpgrade${normal} a system update helper!"
echo "$underline"
echo ""

# get aur_helper
if [ -n "$custom_aur_helper" ]; then
	aur_helper=$custom_aur_helper
	if [ -n "$1" ]; then
		echo "WARNING: Using a custom aur_helper ($aur_helper), but an aur_helper was also given over \$1 ($1)."
		echo ""
	fi
elif [ -n "$1" ]; then
	aur_helper=$1
else
	echo "WARNING: The installed aur_helper was not set!"
	echo " Set it in the script OR give it as the first argument to this script."
	echo ""
fi

#
# ====== UPDATE PACKAGES ======
# 
# official + AUR
if [ -n "$aur_helper" ]; then
	# ${aur_helper} -Syu
	echo -e "starting ${bold}official/AUR${normal} updates with ${bold}${aur_helper}${normal}"
	pause skip
	if [ $? -eq 0 ]; then
		${aur_helper} -Syu
	fi
else
	# pacman -Syu
	echo -e "starting ${bold}official${normal} updates with ${bold}pacman${normal}"
	pause skip
	if [ $? -eq 0 ]; then
		sudo pacman -Syu
	fi
fi
echo "$underline"
echo ""

# flatpak
# test if the command exists
if command -v "flatpak" &>/dev/null; then
	echo -e "starting ${bold}flatpak${normal} updates"
	pause skip
	if [ $? -eq 0 ]; then
		flatpak update
	fi
	echo "$underline"
else
	echo "INFO: flatpak not installed"
fi
echo ""


#
# ====== SYSTEM MAINTENACE ======
#
echo -e "Do you want to do some ${bold}System Maintenance${normal} tasks?"
pause skipN
skip=$?
echo "$underline"
if [ $skip -eq 0 ]; then
	# deal with new configuration files
	echo "deal with new configuration files (pacdiff)"
	pause skip
	if [ $? -eq 0 ]; then
		pacdiff --sudo --backup
	fi
	# maybe also try p3wm 
	echo "$underline"
	#echo ""

	# cleaning the pacman cache (keeping 2 old versions)
	echo "cleaning pacman cache (paccache)"
	#echo " keeping 2 older versions of packages"
	pause skip
	if [ $? -eq 0 ]; then
		paccache --remove --keep 2
	fi

	echo "$underline"
fi
echo ""

#
# ====== END ======
#
echo -e "${bold}All done! Your packages are up to date${normal}"
echo " maybe restart your device"
echo ""
# keep the terminal open
exec bash

#!/usr/bin/bash

# helps with upgrading packages (for official/pacman, AUR and flatpak packages)
# and helps with possible problems from the installations:
# 	- resolve configs (pacdiff)
# args: $1=aur_helper
# Needs:
# 	pacman-contrib (for pacdiff)
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
#notify-send "${scriptName}: installed aur_helper not set!"\
#	"Set it in the script OR give it as the first argument to this script." &

#set -x	# verbose debugging

# pause until any button is pressed
pause() {
	echo ' press any button to continue...'
	read -n 1 -s;
}


# ====== START ======
echo -e "Welcome to \033[1msysUpgrade\033[0m a system update helper!"
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

# official + AUR
if [ -n "$aur_helper" ]; then
	# ${aur_helper} -Syu
	echo -e "starting \033[1m${aur_helper}\033[0m updates"
	pause
	${aur_helper} -Syu
else
	# pacman -Syu
	echo -e "starting \033[1mpacman\033[0m updates"
	pause
	sudo pacman -Syu
fi
echo ""

# flatpak
# test if the command exists
if command -v "flatpak" &>/dev/null; then
	echo -e "starting \033[1mflatpak\033[0m updates"
	pause
	flatpak update
else
	echo "INFO: flatpak not installed"
fi
echo ""

# deal with new configuration files
echo "deal with new configuration files (pacdiff)"
pause
pacdiff
# maybe also try p3wm 
echo ""

echo -e "\033[1mAll done! Your packages are up to date\033[0m"
echo " maybe restart your device"

# keep the terminal open
exec bash

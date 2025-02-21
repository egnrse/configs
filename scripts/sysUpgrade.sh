#!/bin/env bash

# helps with upgrading packages (for official-/pacman-, AUR- and flatpak-packages)
# also helps with some system maintenance:
# 	- remove orphaned packages
# 	- resolve config changes (pacdiff)
# 	- pacman cache cleaning (paccache)
# 	- AUR cache cleaning (paccache, only tested with yay)
# 	- update zinit (zsh pluginmanager)
# 	- update lazy (nvim pluginmanager)
# args: $1=aur_helper
# Needs:
# 	pacman-contrib (for pacdiff, paccache)
# 	sudo
# 	[an aur_helper (tested with yay)]
#	[flatpak]
#	[zsh] (and zinit (a zsh plugin manager))
#	[nvim] (and lazy (a nvim pluginmanager))
# 
# 	(this script is used by the packageUpdates.sh script)
#	by egnrse (https://github.com/egnrse/configs)

# u can give an aur_helper for this script to use with $1 (the first argument)
# OR set one here (with custom_aur_helper)
custom_aur_helper=""

# used for notifications (and resource names, eg. pipes)
scriptName="sysUpgrade.sh"
#notify-send -a ${scriptName} "${scriptName}: installed aur_helper not set!"\
#	"Set it in the script OR give it as the first argument to this script." &

#set -x	# verbose debugging

# visual variables
underline="---------------------------------------------"
normal="\033[0m"
bold="\033[1m"

# pauses and waits for the user in different ways
# $1: ""|"pause"(pause or not given):pause until any button is pressed; "skip"|"skipY":asks to continue or skip (continue by default), "skipN": same as 'skip', but skipping by default
# $2: set a custom message (when eg. skip is given to $1, will show as "$2 (Y/n)")
# returns: 0: success, 1: negative answer, 2: (usage) error
pause() {
	case "$1" in
		""|"pause")
			# continue with any button
			local var2=$2
			if [ -z "$2" ]; then
				var2="> press any button to continue..."
			fi
			echo "$var2"
			read -n 1 -s;
			return 0;
			;;
		"skip"|"skipY" )
			# for yes or empty (return 0) / no (return 1) questions
			local var2="$2"
			if [ -z "$2" ]; then
				var2="> continue [y] or skip [n]"
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
			# for yes (return 0) / no or empty (return 1) questions
			local var2="$2"
			if [ -z "$2" ]; then
				var2="> continue [y] or skip [n]"
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

## get aur_helper
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

## == prepare ==
# run commands that might take a while and dont need user input while waiting for IO (in the background)
# using (fifo) pipes to communicate with this proccess

## flatpak
if command -v "flatpak" &>/dev/null; then
	flatpakUpdatePrep_pipe="/tmp/${scriptName}_flatpakUpdateCheck_pipe"
	rm -f $flatpakUpdatePrep_pipe
	mkfifo $flatpakUpdatePrep_pipe
	trap "rm -f $flatpakUpdatePrep_pipe" EXIT

	# test for updates (backgrounded)
	flatpak remote-ls --updates | wc -l > "$flatpakUpdatePrep_pipe" &
fi


## == update ==

## official + AUR
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

## flatpak
# test if the command exists
if command -v "flatpak" &>/dev/null; then
	# look into '== prepare ==' of the 'update packages' section for the preparation steps
	# read from pipe (flatpak updates)
	read flatpakUpdatePrep_return < "$flatpakUpdatePrep_pipe"
	rm -f $flatpakUpdatePrep_pipe
	
	if [ "$flatpakUpdatePrep_return" -ge 1 ]; then
		echo -e "starting ${bold}flatpak${normal} updates"
		pause skip
		if [ $? -eq 0 ]; then
			flatpak update
		fi
	else
		echo -e "INFO: flatpak packages are up to date"
	fi
	echo "$underline"
else
	echo "INFO: flatpak not installed"
fi
echo ""


#
# ====== SYSTEM MAINTENACE ======
#

## == prepare ==
# run commands that might take a while and dont need user input while waiting for IO (in the background)
# using (fifo) pipes to communicate with this proccess

## cleaning the pacman/AUR cache
cachePrep_pipe="/tmp/${scriptName}_cacheClean_pipe"
rm -f $cachePrep_pipe
mkfifo $cachePrep_pipe
trap "rm -f $cachePrep_pipe" EXIT

# pacman cache location
pacmanCache=/var/cache/pacman/pkg
# AUR cache location	
if [ -n "$XDG_CACHE_HOME" ]; then
	aurCacheDir="$XDG_CACHE_HOME/${aur_helper}"
else
	aurCacheDir="$HOME/.cache/${aur_helper}"
fi

# background part
cachePrepare() {
	# list all AUR package directories (with a '-c' prefix, ignore errors)
	aurCaches=$(find ${aurCacheDir} -mindepth 1 -maxdepth 1 -type d -exec echo -c {} \; 2>/dev/null)

	# write color and bold escape sequences to the string (for comparisons)
	returnNothingTodo=$(echo -e '\E[1m\E[32m==>\E(B\E[m\E[1m no candidate packages found for pruning\E(B\E[m')

	# test if there is stuff to do
	returnCacheInstall=$(paccache --dryrun --keep 2 --min-mtime "30 days ago" -c $pacmanCache $aurCaches)
	if [ "$returnCacheInstall" = "$returnNothingTodo" ]; then
		# only search for more stuff if nothing was found
		returnCacheUn=$(paccache --dryrun --uninstalled --keep 0 --min-atime "90 days ago" -c $pacmanCache $aurCaches)
	fi

	if [ "$returnCacheUn" != "$returnNothingTodo" ] || [ "$returnCacheInstall" != "$returnNothingTodo" ]; then
		echo 0 >"$cachePrep_pipe"
	else
		echo 1 >"$cachePrep_pipe"
	fi
}
cachePrepare &


## == maintain ==

echo -e "Do you want to do some ${bold}System Maintenance${normal} tasks?"
pause skipN
skipMaintenance=$?
echo "$underline"
if [ $skipMaintenance -eq 0 ]; then
	# counts how many task where automatically skipped, because there was nothing to do
	skippedCount=0

	## test for needed packages
	if pacman -Q "pacman-contrib" &>/dev/null; then
		:
	else
		echo -e "${bold}WARNING:${normal} package 'pacman-contrib' is missing, pacdiff/paccache will not work (${scriptName})"
		echo "$underline"
	fi


	## remove unused/orphaned packages (Qdt lists orphaned packages)
	orphanList=$(pacman -Qdtq)
	if [ -n "${orphanList}" ]; then
		echo "remove the following orphaned packages:"
		echo ${orphanList} | sed 's/^/ /'	# preppend each line with a space
		pause skip && sudo pacman -Rns --noconfirm $(pacman -Qdtq)
		echo "$underline"
	else
		((skippedCount++))
	fi

	
	## deal with new configuration files
	echo "deal with new configuration files (pacdiff)"
	pause skip && pacdiff --sudo --backup
	# maybe also try p3wm 
	echo "$underline"


	## cleaning the pacman/AUR cache
	# look into '== prepare ==' of the 'system maintainance' section for the preparation steps

	# read from the prepared pipe
	read cachePrep_return < "${cachePrep_pipe}"
	rm -f $cachePrep_pipe

	if [ ${cachePrep_return} -eq 0 ]; then
		# something to do
		echo "cleaning pacman cache (paccache)"
		pause skip
		if [ $? -eq 0 ]; then
			echo ""
			# remove caches from uninstalled pkgs, older than 90 days (access time)
			echo "Uninstalled packages:"
			returnCacheUninstallRun=$(paccache --remove --uninstalled --keep 0 --min-atime "90 days ago" -c $pacmanCache $aurCaches)
			echo $returnCacheUninstallRun
			
			# remove caches from installed pkgs, keep at least 2, keep all from the last 30 days (update time)
			echo "Installed packages:"
			returnCacheInstallRun=$(paccache --remove --keep 2 --min-mtime "30 days ago" -c $pacmanCache $aurCaches)
			echo $returnCacheInstallRun
		fi
		echo "$underline"
	else
		# nothings to do
		((skippedCount++))
	fi
	

	## removing AUR directories without build packages inside
	# Needs: $aurCacheDir from 'cleaning the pacman/AUR cache'
	# search for '*.pkg.tar.zst' within directories in ${aurCacheDir}
	aurDeleteDir=$(find ${aurCacheDir} -mindepth 1 -maxdepth 1 -type d -exec bash -c "compgen -G {}/*.pkg.tar.zst > /dev/null || echo {}" \;)
	if [ -n "${aurCacheDir}" ] && [ -n "${aurDeleteDir}" ]; then
		echo "remove AUR directories without build packages:"
		echo ${aurDeleteDir} | sed 's/ /\n/g' | sed 's/^/ /'	# display a nice list
		pause skip && find ${aurCacheDir} -mindepth 1 -maxdepth 1 -type d -exec bash -c "compgen -G {}/*.pkg.tar.zst > /dev/null || rm -r {}" \;
		echo "$underline"
	else
		((skippedCount++))
	fi


	## zinit updates (zsh pluginmanager)
	# check if zinit is installed
	checkZinitInstall() {
		# we need to source ~.zshrc to load zinit (because it is not an interactive zsh session)
		zsh -c 'source ~/.zshrc && command -v zinit > /dev/null'
		echo $?
	}
	# check of zsh and zinit are installed and '~/.zshrc' exists
	if [ $(command -v zsh) > /dev/null ] && [ -f ~/.zshrc ] && [ $(checkZinitInstall) -eq 0 ]; then
		# found zsh and zinit
		echo "update zinit and zinit plugins (zsh pluginmanager)"
		pause skip
		if [ $? -eq 0 ]; then
			echo ""
			# we need to source ~.zshrc to load zinit
			zsh  -c '
			source ~/.zshrc
			zinit self-update
			zinit update --parallel
			#zinit delete --clean
			' #| sed -r "s/\x1B\[[0-9;]*[mK]//g" # remove all colors from the output
			echo ""
			echo -e "delete unused plugins by running 'zinit delete --clean' \n in an interactive zsh session"
		fi
	else
		# zsh or zinit are not installed
		echo "zsh, zinit or '~/.zshrc' are missing: skipping zinit updates"
	fi
	echo "$underline"


	## Lazy updates (nvim pluginmanager)
	# check if nvim is installed and accepts the command 'Lazy!'
	if [ $(command -v nvim) > /dev/null ] && [ -z "$(nvim --headless '+Lazy!' +qa)" ]; then
		echo "update Lazy and Lazy plugins (nvim pluginmanager)"
		pause skip
		if [ $? -eq 0 ]; then
			echo ""
			# start nvim headless, sync plugins, exit nvim when done
			nvim --headless "+Lazy! sync" +qa
		fi
		echo "$underline"
	fi
	

	## how many task where automatically skipped, because there was nothing to do
	if [ ${skippedCount} -ge 1 ]; then
		echo "hidden Tasks (nothing to do): ${skippedCount}"
	fi
else
	## no system maintainance
	# some cleanup
	rm -f $cachePrep_pipe
fi
echo ""


#
# ====== END ======
#
echo -e "${bold}All done! Your packages are up to date${normal}"
echo " maybe restart your device"
echo ""
# keep the terminal open (with the system shell)
exec $SHELL

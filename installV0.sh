 #!/bin/env bash

# [WIP] be carful with this script !
# install links from $origin to $config for *all* things in this git (and move the old files to  $backup)
# most things are symbolic links, exceptions: mimeapps.list
#
# after accepting, will move/link files to different parts on your pc too. (mostly hardlinks)
# 
# [WARNING:] (security risk)
#	Moves files to root locations without changing their ownership to root.
#	To migitage this risk chown them to 'root:root' or similar.
#	(eg. sshd/sddm/pacman-hook)
#
# (https://github.com/egnrse/configs)
# (by egnrse)

set -x

## CONSTANTS
origin="$(pwd)/"
config="$HOME/.config/"
backup="${config}.bak/"

## FUNCTIONS

skip() {
	var1=$1
	if [ -z "$1" ]; then
		var1=" continue [y] or skip [n]"
	fi
	read -p "$var1 (Y/n): " pause_answer
	case $pause_answer in
		[Yy]*|"")
			return 0;
			;;
		[Nn]*)
			return 1;
			;;
	esac
}

# links $1 from $origin to $config
# backing up old files to $backup (files in $backup might get deleted)
linkTo() {
# cp -r --update : copy recursively, overwrite older files
# ln -s -i : link symbolic, interactively (ask if unsure)
	linkName=$1
	if [ -d "${config}${linkName}" ]; then
		# directory
		rm -r ${backup}$linkName
		mv -f --update ${config}$linkName ${backup}
	elif [ -f "${config}${linkName}" ]; then
		cp --update ${config}$linkName ${backup}
	fi
	ln -s ${origin}$linkName ${config}
}

# ask for each input and call linkTo() if yes was selected
askForLink() {
	for link in "$@"; do
		skip "link $link" && linkTo $link
	done
}

## MOVE/CP FILES

mkdir -p ${backup}

# link folders to $config
askForLink alacritty bash bottom dunst environment.d hypr hyprswitch io.github.zefr0x.ianny nvim nwg-drawer pipewire rofi shell tofi waybar wlogout zsh

# scripts
chmod +x ${origin}scripts/*
#ln -s -i ${origin}scripts ${config}		# deprecated
skip "link ${HOME}/.local/share/bin/scripts" && ln -s -i ${origin}scripts ${HOME}/.local/share/bin/

# files
askForLink egnrseTheme.css egnrseTheme.css egnrseTheme.conf xdg-terminals.list
# egnrseTheme.sh ?

# hardlink mimeapps.list!
if [ $(skip "hardlink mimeapps.list") ]; then
	cp -r --update ${config}mimeapps.list ${backup}
	ln ${origin}mimeapps.list ${config}
fi

echo ""

## DIFFERENT LOCATIONS
# create hardlinks
echo "cp and move files to other locations too?"
echo "press enter to continue (Ctr+C to exit)"
read
# sddm
sudo cp -l -i ${origin}other/sddm.conf /etc/sddm.conf.d/

# v-editor
sudo cp -l -i ${origin}other/v-editor /usr/local/bin/v && sudo chmod +x /usr/local/bin/v
echo "dont forget to execute 'sudo visudo' and add 'Defaults env_keep += EDITOR'"

# dolphin
mkdir -p ~/.local/share/kio/servicemenus
cp -l -i ${origin}other/servicemenus/* ~/.local/share/kio/servicemenus/
chmod +x ${origin}other/servicemenus/*

sudo mkdir -p /etc/pacman.d/hooks
sudo cp -l -i ${origin}other/updateKDEcache.hook /etc/pacman.d/hooks/
if pacman -Q archlinux-xdg-menu >/dev/null 2>&1; then
	:
else
	echo "install the 'archlinux-xdg-menu' packages, for some dolphin stuff to work"
fi

# wvkbd-laptop
sudo cp -i ${origin}other/wvkbd-laptop /usr/local/bin/ 
sudo +x /usr/local/share/bin/wvkbd-laptop
sudo mkdir -p /usr/local/share/applications/
sudo cp -l -i ${origin}other/wvkbd-laptop.desktop /usr/local/share/applications/

# screenshot
ln -s -i ${origin}other/screenshot.desktop ${HOME}/.local/share/applications/

# sshd
sudo ln -s -i ${origin}other/50-custom-sshd.conf /etc/ssh/sshd_config.d/50-custom-sshd.conf

# vim
ln -s -i ${origin}other/.vimrc ${HOME}/

# git
ln -s -i ${origin}other/.gitignore_global ${HOME}/
echo "add '.gitignore_global' with 'git config --global core.excludesfile ~/.gitignore_global'"

# link roots nvim to ours?
#read -p "do you want to link the nvim configs to root? [y/N]: " answer
#case $answer in
#	[Yy]*)
#		sudo mv ${rootConf}nvim ${rootBackup}
#		sudo ln -s -i ${origin}nvim ${rootConf}
#		;;
#	[Nn]*|"")
#		;;
#esac

echo "All done."

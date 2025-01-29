#!/bin/bash

# [WIP] be carful with this script !
# install links from $origin to $config for *all* things in this git (and move the old files to  $backup)
# most things are symbolic links, exceptions: mimeapps.list
#
# after accepting, will move/link files to different parts on your pc too.
# (https://github.com/egnrse/configs)
# (by egnrse)

set -x

origin="$(pwd)/"
config="$HOME/.config/"
backup="${config}.bak/"

mkdir -p ${backup}
mv ${config}alacritty ${backup}
ln -s -i ${origin}alacritty ${config}
mv ${config}bash ${backup}
ln -s -i ${origin}bash ${config}
mv ${config}dunst ${backup}
ln -s -i ${origin}dunst ${config}
mv ${config}environment.d ${backup}
ln -s -i ${origin}environment.d ${config}
mv ${config}hypr ${backup}
ln -s -i ${origin}hypr ${config}
mv ${config}nvim ${backup}
ln -s -i ${origin}nvim ${config}
mv ${config}nwg-drawer ${backup}
ln -s -i ${origin}nwg-drawer ${config}
mv ${config}rofi ${backup}
ln -s -i ${origin}rofi ${config}
mv ${config}tofi ${backup}
ln -s -i ${origin}tofi ${config}
mv ${config}waybar ${backup}
ln -s -i ${origin}waybar ${config} && chmod +x ${origin}waybar/scripts/*
mv ${config}wlogout ${backup}
ln -s -i ${origin}wlogout ${config}


mv ${config}scripts ${backup}
chmod +x ${origin}scripts/*

ln -s -i ${origin}scripts ${config}		# deprecated
ln -s -i ${origin}scripts ${HOME}/.local/share/bin/


# files
mv ${config}egnrseTheme.css ${backup}
ln -s -i ${origin}egnrseTheme.css ${config}
mv ${config}egnrseTheme.conf ${backup}
ln -s -i ${origin}egnrseTheme.conf ${config}
# egnrseTheme.sh ?
# hardlink mimeapps.list!
mv ${config}mimeapps.list ${backup}
ln -i ${origin}mimeapps.list ${config}
mv ${config}xdg-terminals.list ${backup}
ln -s -i ${origin}xdg-terminals.list ${config}


## DIFFERENT LOCATIONS
# hard link files
echo "cp and move files to other locations too?"
echo "press enter to continue (Ctr+C to exit)"
read
sudo cp -l -i ${origin}other/sddm.conf /etc/sddm.conf.d/
sudo cp -l -i ${origin}other/v-editor /usr/local/bin/v && sudo chmod +x /usr/local/bin/v
echo "dont forget to execute 'sudo visudo' and add 'Defaults env_keep += EDITOR'"
# dolphin
mkdir -p ~/.local/share/kio/servicemenus
cp -l -i ${origin}other/servicemenus/* ~/.local/share/kio/servicemenus/
chmod +x ${origin}other/servicemenus/*
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

 !/bin/env bash

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

# cp -r --update : copy recursively, overwrite older files
# ln -s -i : link symbolic, interactively (ask if unsure)
mkdir -p ${backup}
cp -r --update ${config}alacritty ${backup}
ln -s -i ${origin}alacritty ${config}
cp -r --update ${config}bash ${backup}
ln -s -i ${origin}bash ${config}
cp -r --update ${config}dunst ${backup}
ln -s -i ${origin}dunst ${config}
cp -r --update ${config}environment.d ${backup}
ln -s -i ${origin}environment.d ${config}
cp -r --update ${config}hypr ${backup}
ln -s -i ${origin}hypr ${config}
cp -r --update ${config}hyprswitch ${backup}
ln -s -i ${origin}hyprswitch ${config}
cp -r --update ${config}io.github.zefr0x.ianny ${backup}
ln -s -i ${origin}io.github.zefr0x.ianny ${config}
cp -r --update ${config}nvim ${backup}
ln -s -i ${origin}nvim ${config}
cp -r --update ${config}nwg-drawer ${backup}
ln -s -i ${origin}nwg-drawer ${config}
cp -r --update ${config}rofi ${backup}
ln -s -i ${origin}rofi ${config}
cp -r --update ${config}tofi ${backup}
ln -s -i ${origin}tofi ${config}
cp -r --update ${config}waybar ${backup}
ln -s -i ${origin}waybar ${config} && chmod +x ${origin}waybar/scripts/*
cp -r --update ${config}wlogout ${backup}
ln -s -i ${origin}wlogout ${config}
cp -r --update ${config}zsh ${backup}
ln -s -i ${origin}zsh ${config}


cp -r --update ${config}scripts ${backup}
chmod +x ${origin}scripts/*

#ln -s -i ${origin}scripts ${config}		# deprecated
ln -s -i ${origin}scripts ${HOME}/.local/share/bin/


# files
cp -r --update ${config}egnrseTheme.css ${backup}
ln -s -i ${origin}egnrseTheme.css ${config}
cp -r --update ${config}egnrseTheme.conf ${backup}
ln -s -i ${origin}egnrseTheme.conf ${config}
# egnrseTheme.sh ?
# hardlink mimeapps.list!
cp -r --update ${config}mimeapps.list ${backup}
ln -i ${origin}mimeapps.list ${config}
cp -r --update ${config}xdg-terminals.list ${backup}
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

# screenshot
ln -s -i ${origin}other/screenshot.desktop ${HOME}/.local/share/applications/

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

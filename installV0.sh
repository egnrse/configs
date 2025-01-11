#!/bin/bash

# [WIP] be carful with this script !
# install links from $origin to $config for *all* things in this git (and move the old files to  $backup)
# (by egnrse)

set -x

origin="$HOME/Documents/configs/"
config="$HOME/.config/"
backup="${config}.bac/"

mkdir ${backup}
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
mv ${config}scripts ${backup}
ln -s -i ${origin}scripts ${config}
mv ${config}tofi ${backup}
ln -s -i ${origin}tofi ${config}
mv ${config}waybar ${backup}
ln -s -i ${origin}waybar ${config}
mv ${config}wlogout ${backup}
ln -s -i ${origin}wlogout ${config}

# files
mv ${config}egnrseTheme.css ${backup}
ln -s -i ${origin}egnrseTheme.css ${config}
mv ${config}mimeapps.list ${backup}
ln -s -i ${origin}mimeapps.list ${config}


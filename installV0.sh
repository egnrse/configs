 #!/bin/env bash

# [WIP] be careful with this script !
# install links from $origin to $config for *all* things in this git (and move the old files to  $backup)
# most things are symbolic links, exceptions: mimeapps.list
#
# after accepting, will move/link files to different parts on your pc too. (some hardlinks)
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

## install packages
pkgs="base-devel neovim vim git sudo grub openssh efibootmgr man-db man-pages" # basics
pkgs+=" ntfs-3g exfat-utils btrfs-progs grub-btrfs" # filesystem
pkgs+=" networkmanager blueman waypipe" # network
pkgs+=" flatpak wget pacman-contrib devtools" # package management
pkgs+=" pipewire pipewire-docs wireplumber wireplumber-docs" # audio
pkgs+=" wl-clipboard zsh zoxide fzf fastfetch rclone zerotier-one ttf-dejavu-nerd ctags" # cli
pkgs+=" syncthing zip unzip"

pkgs_gui="plasma-meta hyprland sddm wayland-protocols wayland-utils uwsm xdg-desktop-portal-hyprland xdg-desktop-portal-gtk" # gui meta
pkgs_gui+=" waybar dunst rofi-wayland nwg-drawer hypridle hyprlock helvum polkit-kde-agent firefox alacritty konsole dolphin" # gui
pkgs_gui+=" kio-admin ark dolphin-plugins archlinux-xdg-menu kdegraphics-thumbnailers libappimage" # dolpin stuff
pkgs_gui+=" libreoffice-fresh prismlauncher mission-center kdeconnect strawberry vlc kalgebra kcalc godot-mono blender cuda" # more gui
pkgs_gui+=" hunspell-en_US speech-dispatcher" # waterfox/firefox

pkgs_aur="xdg-terminal-exec-git hyprswitch ianny v-editor-git" # hyprswitch > hyprshell
pkgs_aur+=" pwvucontrol wlogout tofi trash-d"
pkgs_aur+=" beeper-v4-bin anki-bin waterfox-bin pa-notify syncthingtray-qt6" # gui

pkgs_flatpak+="com.github.tchx84.Flatseal dev.vencord.Vesktop com.obsproject.Studio io.github.dimtpap.coppwr net.cozic.joplin_desktop net.veloren.airshipper org.gimp.GIMP org.keepassxc.KeePassXC org.musescore.MuseScore org.torproject.torbrowser-launcher"
# yay
if skip "install some packages"; then
	sudo pacman -Syu --needed $pkgs
	skip "install gui packages" && sudo pacman -Syu --needed $pkgs_gui
	if skip "install AUR packages"; then
		if ! command -v yay; then
			sudo pacman -S --needed git base-devel
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si
		fi
		yay -S --needed $pkgs_aur
	fi
	if skip "install flatpak packages"; then
		flatpak install -y --noninteractive flathub $pkgs_flatpak
	fi
fi
exit 1 #dev


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

# create/link log folder
mkdir ${origin}/log
askForLink log

echo ""


## DIFFERENT LOCATIONS
# ssh
sshConfigFile="${HOME}/.ssh/config"
if skip "link ~/.ssh/ssh_config"; then
	ln -s -i ${origin}other/ssh_config ${HOME}/.ssh/ssh_config
	if grep "Include ~/.ssh/ssh_config" ${sshConfigFile} >/dev/null; then
		echo " Skipping: already sourced in ${sshConfigFile}"
	else
		skip " source the custom ssh config in ${sshConfigFile}" && echo "Include ~/.ssh/ssh_config" >> ${sshConfigFile}
	fi
fi

# vim
skip "link ~/.vimrc" && ln -s -i ${origin}other/.vimrc ${HOME}/

# git
gitConfigFile="${HOME}/.gitconfig"
if skip "link ~/.gitconfig_custom and ~/.gitignore_global"; then
	ln -s -i ${origin}other/.gitconfig_custom ${HOME}/
	ln -s -i ${origin}other/.gitignore_global ${HOME}/
	if cat "${gitConfigFile}" >/dev/null 2>&1 && grep "path = ~/.gitconfig_custom" "${gitConfigFile}" >/dev/null; then
		echo " Skipping: already sourced in ${gitConfigFile}"
	else
		if skip "source .gitconfig_custom in ${gitConfigFile}"; then
			tmpFile='/tmp/install.sh-gitconfig'
			{
				printf '[include]\n'
				printf '	path = ~/.gitconfig_custom\n'
				cat "${gitConfigFile}" 2>/dev/null
			} > ${tmpFile} && mv ${tmpFile} "${gitConfigFile}"
		else
			echo "Add the following to your ~/.gitconfig to source the files manually:"
			printf '[include]\n'
			printf '	path = ~/.gitconfig_custom\n'
			echo ""
			echo "Or only add '.gitignore_global' with 'git config --global core.excludesfile ~/.gitignore_global'"
		fi
	fi
fi

echo ""


## NOT ASKED AGAIN
echo "cp and move files to other locations too?"
echo "press enter to continue (Ctr+C to exit)"
echo " You will not be asked again!"
read


# sddm
sudo cp -l -i ${origin}other/sddm.conf /etc/sddm.conf.d/

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

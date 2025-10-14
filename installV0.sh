 #!/bin/env bash

# [WIP] be careful with this script !
# this script does:
# - install packages (from pacman/AUR/flatpak)
# - install stuff from $origin to $config (and move the previous files to $backup)
# - install stuff from $origin to other places
# - source/include some files
#
# you will be asked before most actions
# most things are symbolic links
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

bold="\e[1m"
normal="\e[0m"
green="\e[32m"
purple="\e[95m"

## FUNCTIONS

skip() {
	var1="$1"
	if [ -z "$1" ]; then
		var1=" continue [y] or skip [n]"
	fi
	#read -p "$var1 (Y/n): " pause_answer
	read -p "$(printf "%b" "$var1 ${purple}${bold}(Y/n): "${normal})" pause_answer
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

## INSTALL PACKAGES ##################################
pkgs="base-devel neovim vi vim git sudo grub openssh efibootmgr man-db man-pages" # basics
pkgs+=" ntfs-3g exfat-utils btrfs-progs grub-btrfs" # filesystem
pkgs+=" networkmanager blueman waypipe" # network
pkgs+=" flatpak wget pacman-contrib devtools" # package management
pkgs+=" pipewire pipewire-docs wireplumber wireplumber-docs" # audio
pkgs+=" wl-clipboard zsh zoxide fzf fastfetch rclone zerotier-one ttf-dejavu-nerd ctags" # cli
pkgs+=" syncthing zip unzip"

pkgs_gui="plasma-meta hyprland sddm wayland-protocols wayland-utils uwsm xdg-desktop-portal-hyprland xdg-desktop-portal-gtk" # gui meta
pkgs_gui+=" waybar dunst rofi-wayland nwg-drawer hypridle hyprlock hyprsunset helvum polkit-kde-agent firefox alacritty konsole dolphin" # gui
pkgs_gui+=" kio-admin ark dolphin-plugins archlinux-xdg-menu kdegraphics-thumbnailers libappimage" # dolpin stuff
pkgs_gui+=" libreoffice-fresh prismlauncher mission-center kdeconnect strawberry vlc kalgebra kcalc godot-mono blender cuda" # more gui
pkgs_gui+=" hunspell-en_US speech-dispatcher" # waterfox/firefox

pkgs_aur="xdg-terminal-exec-git hyprswitch ianny v-editor-git" # hyprswitch > hyprshell
pkgs_aur+=" pwvucontrol wlogout tofi trash-d"
pkgs_aur+=" beeper-v4-bin anki-bin waterfox-bin pa-notify syncthingtray-qt6" # gui

pkgs_flatpak+="com.github.tchx84.Flatseal dev.vencord.Vesktop com.obsproject.Studio io.github.dimtpap.coppwr net.cozic.joplin_desktop net.veloren.airshipper org.gimp.GIMP org.keepassxc.KeePassXC org.musescore.MuseScore org.torproject.torbrowser-launcher"

if skip "install some packages"; then
	sudo pacman -Syu --needed $pkgs
	skip "install gui packages" && sudo pacman -Syu --needed $pkgs_gui
	if skip "install AUR packages"; then
		if ! command -v yay; then
			sudo pacman -S --needed git base-devel
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si
			cd ..
			skip "remove yay install dir" && rm -rf ./yay
		fi
		yay -S --needed $pkgs_aur
	fi
	if skip "install flatpak packages"; then
		flatpak install -y flathub $pkgs_flatpak
	fi
fi


## MOVE/CP FILES ##################################
if skip "link/copy ~/.config stuff"; then
	mkdir -p ${backup}
	
	# link folders to $config
	askForLink alacritty bash bottom dunst environment.d hypr hyprswitch io.github.zefr0x.ianny nvim nwg-drawer pipewire rofi shell tofi waybar wlogout zsh
	
	# scripts
	chmod +x ${origin}scripts/*
	#ln -s -i ${origin}scripts ${config}		# deprecated
	if skip "link ${HOME}/.local/share/bin/scripts"; then
		mkdir -p ${HOME}/.local/share/bin/
		ln -s -i ${origin}scripts ${HOME}/.local/share/bin/
	if
	
	# files
	askForLink egnrseTheme.css egnrseTheme.css egnrseTheme.conf xdg-terminals.list
	# egnrseTheme.sh ?
	
	# cp mimeapps.list
	if [ $(skip "copy mimeapps.list") ]; then
		cp -r --update ${config}mimeapps.list ${backup}
		cp ${origin}mimeapps.list ${config}
	fi

	# create/link log folder
	#mkdir ${origin}/log
	#askForLink log
fi

echo ""


## DIFFERENT LOCATIONS ##################################
# ssh
sshConfigFile="${HOME}/.ssh/config"
if skip "link ~/.ssh/ssh_config"; then
	mkdir -p ${HOME}/.ssh/
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
			touch ${gitConfigFile}
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

# sddm
if skip "link sddm config"; then
	sudo chown root:root ${origin}other/sddm.conf
	sudo mkdir -p /etc/sddm.conf.d/
	sudo ln -s -i ${origin}other/sddm.conf /etc/sddm.conf.d/
fi

# dolphin
if skip "link dolphin servicemenus"; then
	mkdir -p ~/.local/share/kio/servicemenus
	ln -s -i ${origin}other/servicemenus/* ~/.local/share/kio/servicemenus/
	chmod +x ${origin}other/servicemenus/*
fi
if skip "create pacman hooks for dolphin "; then
	sudo chown root:root ${origin}other/updateKDEcache.hook
	sudo mkdir -p /etc/pacman.d/hooks
	sudo ln -s -i ${origin}other/updateKDEcache.hook /etc/pacman.d/hooks/
	if pacman -Q archlinux-xdg-menu >/dev/null 2>&1; then
		:
	else
		echo "install the 'archlinux-xdg-menu' packages, for some dolphin stuff to work"
	fi
fi

# screenshot
if skip "link screenshot.desktop"; then
	mkdir -p ${HOME}/.local/share/applications/
	ln -s -i ${origin}other/screenshot.desktop ${HOME}/.local/share/applications/
fi

# sshd
if skip "link sshd config"; then
	sudo chown root:root ${origin}other/50-custom-sshd.conf
	sudo ln -s -i ${origin}other/50-custom-sshd.conf /etc/ssh/sshd_config.d/50-custom-sshd.conf
fi

echo ""


## SOURCE/CHANGE STUFF ##################################
if skip "source bash in ~/.bashrc"; then
	if grep "source \$customBashConfig_path" ${HOME}/.bashrc >/dev/null; then
		echo " Skipping: already sourced"
	else
		cat <<EOF >> ${HOME}/.bashrc
# fetches the config file for bash (if it exists)
# $customBashConfig_path is the path to the custom config file
customBashConfig_path="$HOME/.config/bash/custom.bashrc"
if [ -f "\$customBashConfig_path" ]; then
	source \$customBashConfig_path
else
	echo "path to config not found (\$customBashConfig_path)"
fi
EOF
	fi
fi

if skip "source zsh in ~/.zshrc"; then
	if grep "source \$customZshConfig_path" ${HOME}/.zshrc >/dev/null; then
		echo " Skipped: already sourced"
	else
		cat <<EOF >> ${HOME}/.zshrc
# fetch the custom config file for zsh (if it exists)
# customZshConfig_path is the path to the config file
customZshConfig_path="$HOME/.config/zsh/custom.zshrc"
if [ -f "\$customZshConfig_path" ]; then
	source \$customZshConfig_path
else
	echo ".zshrc: path to config not found (\$customZshConfig_path)"
fi
EOF
	fi
fi

if skip "make zsh your standart shell"; then
	zshPath=$(which zsh)
	chsh -s ${zshPath}
fi

skip "activate system unit: sddm" && sudo systemctl enable sddm
skip "activate system unit: bluetooth" && sudo systemctl enable bluetooth

echo ""


## NOT ASKED AGAIN ##################################
#echo "cp and move files to other locations too?"
#echo "press enter to continue (Ctr+C to exit)"
#echo " You will not be asked again!"
#read



# link roots nvim to ours? (just a bad idea)
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

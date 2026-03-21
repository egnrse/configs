 #!/bin/env bash

# [WIP] be careful with this script !
# install (symbolic) links from $origin to $config (and $HOME) for *all* things in this git
# 
# (https://github.com/egnrse/configs)
# (by egnrse)

#set -x

## CONSTANTS
origin="$(pwd)/"
config="$HOME/.config/"

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
linkTo() {
	linkName=$1
	ln -s -i ${origin}$linkName ${config}
}

# ask for each input and call linkTo() if yes was selected
askForLink() {
	for link in "$@"; do
		skip "link $link" && linkTo $link
	done
}

# test if $1 is available as a command
# $2: what config $1 is needed for (eg. 'zsh')
# $3: set if $1 is optional for $2
testInstalled() {
	if [ -z "$(command -v $1)" ]; then
		if [ -z "$2" ]; then
			echo $1 not installed
		elif [ -z "$3" ]; then
			echo "$1 not installed (needed for $2)"
		else
			echo "$1 not installed (optional for $2)"
		fi
	fi
}

## TEST FOR INSTALLED SOFTWARE
# TODO
testInstalled bash
testInstalled nvim
testInstalled ssh-agent ssh
testInstalled vim
testInstalled curl vim
testInstalled zsh
testInstalled fzf zsh opt
testInstalled zoxide zsh opt


## MOVE/CP FILES
mkdir -p ${config}

# link folders to $config
askForLink bash nvim shell zsh

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
			} > ${tmpFile} && mv ${tmpFile} ${gitConfigFile}
		else
			echo "Add the following to your ~/.gitconfig to source the files manually:"
			printf '[include]\n'
			printf '	path = ~/.gitconfig_custom\n'
			echo ""
			echo "Or only add '.gitignore_global' with 'git config --global core.excludesfile ~/.gitignore_global'"
		fi
	fi
fi

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

## SOURCE/CHANGE STUFF
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
echo "All done."

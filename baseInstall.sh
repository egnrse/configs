 #!/bin/env bash

# [WIP] be carful with this script !
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
	if grep "path = ~/.gitconfig_custom" ${gitConfigFile} >/dev/null; then
		echo " Skipping: already sourced in ${gitConfigFile}"
	else
		if skip "source .gitconfig_custom in ${gitConfigFile}"; then
			tmpFile='/tmp/install.sh-gitconfig'
			{
				printf '[include]\n'
				printf '	path = ~/.gitconfig_custom\n'
				cat ${gitConfigFile}
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
if skip "link ~/.ssh/ssh_config"; then
	ln -s -i ${origin}other/ssh_config ${HOME}/.ssh/ssh_config
	echo "add the following to ~/.ssh/config: 'Include ~/.ssh/ssh_config'"
fi

## SOURCE/CHANGE STUFF
if skip "source bash in ~/.bashrc"; then
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

if skip "source zsh in ~/.zshrc"; then
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

if skip "make zsh your standart shell"; then
	zshPath=$(which zsh)
	chsh -s ${zshPath}
fi
echo "All done."

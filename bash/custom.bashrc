#!/bin/bash
#
# a custom .bashrc file extension
#
################################################
########## put this into your .bashrc ##########

# fetches the config file for bash (if it exists)
# $customBashConfig_path is the path to the (this) config file
# customBashConfig_path="$HOME/.config/bash/custom.bashrc"
# if [ -f "$customBashConfig_path" ]; then
# 	source $customBashConfig_path
# else
# 	echo "path to config not found ($customBashConfig_path)"
# fi

########## put this into your .bashrc ##########
################################################


# if running interactively
if [[ $- = *i* ]] then
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	PS1='[\u@\h \W]\$ '
fi

## CUSTOM ENVIRONMENT VARIABLES
################################
#
# those can be accessed with "$varName"
# (in strings) the " (double qotes) are needed for command expansion (in '$varName' commands are not expanded)
export EDITOR=nvim				# your prefered editor (eg. vim, nano)
export TERMINAL=alacritty		# your prefered terminal (used in some scripts)
export TERM_RUN="alacritty -e"	# run a command in a new shell

# make variables usable in cd calls
shopt -s cdable_vars
# custom paths (that can be used in cd calls because of the line above)
export data='/mnt/data/'
export d="$data"
export dDoc="${data}/Documents#2/"
export dDocs="${data}/Documents#2/"
export dTU="${data}/Documents#2/TU/"

# show that wayland is the Display-Server-Protocol (some apps rely on that)
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export GDK_BACKEND=wayland

# fetch the aliases file (if the file exists)
currentDir="$(dirname ${BASH_SOURCE[0]})"
customBashAliases_path="${currentDir}/aliases.bashrc"
if [ -f $customBashAliases_path ]; then
	source $customBashAliases_path
else
	echo "custom.bashrc: aliases.bashrc not found ($customBashAliases_path)"
fi
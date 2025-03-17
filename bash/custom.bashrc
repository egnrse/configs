# custom.bashrc
#
# a custom config file for bash (extends .bashrc)
# (https://github.com/egnrse/configs)
# (by egnrse)
#
# custom.bashrc:	general settings are here
# ../shell/aliases.shrc:	shell aliases 
# 
## ENVIRONMENT VARIABLES
# since using uwsm, many apps will not see env-variables exported from .bashrc
# (see `https://github.com/Vladimir-csp/uwsm` 4-environments-and-shell-profile)
# put them into a file read by systemd (see `man 5 environment.d`)
# for user specific env-vars you can use `~/.config/environment.d/*.conf`
#
# tl;dr:
# 	don't put environment-variables here
# 	(except only bash shells need them)
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
if [[ $- = *i* ]]; then
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	PS1='[\u@\h \W]\$ '
fi

# command (c) and file (f) completion after a command
complete -c man command which
complete -cf sudo exec

# remove all but the last identical command from the bash history
export HISTCONTROL=erasedups

## COLORS
################################
# fix colors on windows drives (all files have 777 as permission)
# just changes the color of 777 files in general for the ls command
export LS_COLORS="ow=01;31:$LS_COLORS"

# make variables usable in cd calls (eg. `cd data`)
shopt -s cdable_vars
# custom paths (that can be used in cd calls because of the line above)
# u might want to change some or add your own
# I added my device specific ones to `~/.bashrc`
# 
# an example:
#export data='/mnt/data/'
#export d="$data"
#export dDoc="${data}/Documents#2/"
#export dDocs="${data}/Documents#2/"
#export dTU="${data}/Documents#2/TU/"




## ALIASES
################################
# fetch the aliases file (if the file exists)
customBashAliases_path=~/.config/shell/aliases.shrc
if [ -f $customBashAliases_path ]; then
	source $customBashAliases_path
else
	echo "custom.bashrc: aliases.shrc not found ($customBashAliases_path)"
fi


## CUSTOM ENVIRONMENT VARIABLES
################################
# fetch the env file (if the file exists)
customBashEnv_path=~/.config/shell/env.shrc
if [ -f $customBashEnv_path ]; then
	source $customBashEnv_path
else
	echo "custom.bashrc: env.shrc not found ($customBashEnv_path)"
fi



# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# add custom alias definitions (from ~/.config/.bash_aliases, if the file exists)
# you may want to put all your additions into a separate file
if [ -f ~/.config/.bash_aliases ]; then
	. ~/.config/.bash_aliases
fi

# make variables usable in cd calls
shopt -s cdable_vars
# set some custom paths
export cDocs=/mnt/c
export dTU=/mnt/d
export dDocs=/mnt/d/Dokumente2

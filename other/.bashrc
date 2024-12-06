# starting for a .bashrc

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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.config/.bash_aliases ]; then
	. ~/.config/.bash_aliases
fi

# make variables usable in cd calls
shopt -s cdable_vars
# set some custom paths
export cDocs=/mnt/
export dTU=/mnt/
export dDocs=/mnt/

# some more custom paths
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
export PATH="$PATH:/opt/nvim-linux64/bin"

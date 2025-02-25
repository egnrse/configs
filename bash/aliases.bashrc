# aliases.bashrc
#
# a custom config file for bash (extends .bashrc)
# (https://github.com/egnrse/configs)
# (by egnrse)
# 

# uncomment if u want the base functionality of `v-editor`, without doing it properly
#alias v=$EDITOR

# general commands
alias lsa='ls -a'
alias lsA='ls -all'
alias cd..='cd ..'
alias cls='clear'
alias clsa='clear && lsa'
alias clsA='clear && lsA'

# git
alias gits='git status'
alias gitlg='git log --oneline'
alias gitlog='git log'
alias gitlogg='git log --stat'
alias gitbr='git branch'

# trash/delete
alias rm='rm -I'
# if trash-d is installed use it and not rm
if [ -n "$(command -v trash)" ]; then
	alias rm='trash'
	alias trash='trash -I'
fi

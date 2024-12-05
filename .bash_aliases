# alias file
# 
# put this in your ~/.bashrc :
# if [ -f ~/.config/.bash_aliases ]; then
# 	. ~/.config/.bash_aliases
# fi


export TERMINAL=alacritty
export TERM_RUN="alacritty -e"	# run a command in a new shell
export EDITOR=nvim

alias v=$EDITOR

# commands
alias lsa='ls -a'
alias lsA='ls -all'
alias cd..='cd ..'
alias cls='clear'
alias clsa='clear && lsa'
alias clsA='clear && lsA'

# git
alias gits='git status'
alias gitlg='git log --stat'
alias gitlog='git log'
alias gitbr='git branch'

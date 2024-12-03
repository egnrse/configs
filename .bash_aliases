# alias file
# 
# put this in your ~/.bashrc :
# if [ -f ~/.config/.bash_aliases ]; then
# 	. ~/.config/.bash_aliases
# fi
export TERMINAL=alacritty
export EDITOR=nvim

alias v=$EDITOR

# commands
alias lsa='ls -a'
alias lsA='ls -all'
alias cd..='cd ..'
alias cls='clear'
alias clsa='clear && lsa'
alias clsA='clear && lsA'

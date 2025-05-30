# maps.zshrc
#
# a custom keymappings file for zsh (extends .zshrc)
# (https://github.com/egnrse/configs)
# (by egnrse)

# -r unbinds the key
bindkey -e
bindkey -r '^[[2~' 			 		# Insert key
bindkey '^[[3~' delete-char 		# Delete key
bindkey '^[[H' beginning-of-line	# Home/Pos1 key
bindkey '^[[F' end-of-line		 	# End key

bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
bindkey '^Z' undo
bindkey '^R' redo

# Ctrl+Arrow keys: Jump Words
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

## plugin keybinds
bindkey '^e' autosuggest-clear
# autosuggest-accept autosuggest-execute

# ^I will be overwritten by fzf-tab (is changed again in 'atload', see custom.zshrc)
bindkey -r '^I'
bindkey '^I' expand-or-complete		# Tab (normal autocomplete)
bindkey '^[[Z' fzf-tab-complete		# Shift+Tab



# custom.zshrc
#
# a custom config file for zsh (extends .zshrc)
# (https://github.com/egnrse/configs)
# (by egnrse)
#
# custom.zshrc:		general settings are here (needs to be sourced)
# maps.zshrc:		keymappings (sourced by this file)
# ../shell/aliases.shrc:		shell aliases (sourced by this file)

## PLUGIN MANAGER
################################
# setup the zinit plugin manager (in $XDG_DATA_HOME/zinit/)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d $ZINIT_HOME ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

## load plugins
# zsh-syntax-highlighting
zinit light zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_MAXLENGTH=512

# zsh-users/zsh-completions
zinit light zsh-users/zsh-completions

# zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)	# first search in the history, then in the completion engine
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *|v *|nvim *|vim *|trash *|rm *" # ignore matches from this regex
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Aloxaf/fzf-tab
zinit light Aloxaf/fzf-tab			# needs fzf

zinit snippet OMZP::sudo			# press 'Esc' twice to preface a command with sudo

# to slow for me:
#zinit snippet OMZP::command-not-found	# recommend packages if a command is not found (needs 'pkgfile', pkgfile -u)



## GENERAL ZSH SETTINGS
################################
setopt extendedglob nomatch			# pattern matching (nomatch: return error on no results)
unsetopt beep						# disable beep on error
setopt glob_dots 					# include hidden files in the completion
setopt prompt_subst					# enable substitution in prompts

autoload -Uz compinit && compinit	# load completions
autoload -Uz vcs_info				# version-control support

# updates zinit plugins
zinit cdreplay -q

## style
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# version-control style
zstyle ':vcs_info:*' enable git hg			# active for: git mercurial
zstyle ':vcs_info:git:*' check-for-changes true	# activate %u %c
zstyle ':vcs_info:git:*' use-simple true	# faster but less accurate
zstyle ':vcs_info:git:*' stagedstr '+'  	# indicator for staged changes (%c)
zstyle ':vcs_info:git:*' unstagedstr '*'	# indicator for unstaged changes (%u)
zstyle ':vcs_info:git:*' formats "%F{#555}(%b%c)%u%{$reset_color%}" 		# (branch staged)unstaged
zstyle ':vcs_info:git:*' actionformats "%F{#555}[%a](%b%c)%u%{$reset_color%}" # [action](branch staged)unstaged 

## runs before each command
precmd() {
	# change window title
	print -Pn "\e]0;%n@%m:%~\a"  #Title: username@hostname: currentDirectory
	# get version-control info
	vcs_info
}



## KEYBINDINGS
################################
# fetch the map file (if the file exists)
customZshMappings_path=~/.config/zsh/maps.zshrc
if [ -f $customZshMappings_path ]; then
	source $customZshMappings_path
else
	echo "custom.zshrc: map.zshrc not found ($customZshMappings_path)"
fi

## LOOKS && COLORS
################################
# fix colors on windows drives (all files have 777 as permission)
# just changes the color of 777 files in general for the ls command
export LS_COLORS="ow=01;31:$LS_COLORS"

# add color
alias ls='ls --color=auto'
alias grep='grep --color=auto'

## prompt
PROMPT='[%F{green}%n%f'			# '[username@host '
PROMPT+='@%m '					# '@host '
PROMPT+='%F{green}%1~%f'		# current folder name (in green)
PROMPT+=']%# '					# ']%' or ']#' if superuser 

RPROMPT="%(?..%F{red}[%?]%f)"	# show exit status of previous command if it is not 0 (in red)
RPROMPT+='${vcs_info_msg_0_}'	# version-control

## plugins
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=#00B39C,underline'
#ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,normal'
ZSH_HIGHLIGHT_STYLES[default]='none'


## HISTORY
################################
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history
# history file interactions
setopt appendhistory
setopt sharehistory
# manage duplicates
HISTDUP=erase
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


## ALIASES
################################
# fetch the aliases file (if the file exists) from ~/.config/shell/
customZshAliases_path=~/.config/shell/aliases.shrc
if [ -f $customZshAliases_path ]; then
	source $customZshAliases_path
else
	echo "custom.zshrc: aliases.shrc not found ($customZshAliases_path)"
fi


# SHELL INTEGRATION
################################
eval "$(zoxide init --cmd cd zsh)"	# fuzzy finding for cd (needs zoxide)

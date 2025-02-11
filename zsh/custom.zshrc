# custom.zshrc
#
# a custom config file for zsh (extends .zshrc)
# (https://github.com/egnrse/configs)
# (by egnrse)
#
# custom.zshrc:		general settings are here
# aliases.shrc:		shell aliases

## PLUGIN MANAGER
################################
# setup the zinit plugin manager (in $XDG_DATA_HOME/zinit/)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d $ZINIT_HOME ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# load plugins
zinit light zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_MAXLENGTH=512

zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)	# first search in the history, then in the completion engine
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *|v *|nvim *|vim *" # ignore matches from this regex
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

#zinit light Aloxaf/fzf-tab			# needs fzf
# works well for big lists (not sure how to enable it only there)


zinit snippet OMZP::command-not-found	# recommend packages if a command is not found (needs 'pkgfile', pkgfile -u)
zinit snippet OMZP::sudo		# press 'Esc' twice to preface a command with sudo

# style
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

## GENERAL ZSH SETTINGS
################################
setopt extendedglob nomatch
unsetopt beep

# load completions
autoload -Uz compinit && compinit

# updates zinit plugins
zinit cdreplay -q


## KEYBINDINGS
################################
bindkey -v
bindkey '^e' autosuggest-clear
# autosuggest-accept autosuggest-execute


## LOOKS && COLORS
################################
# fix colors on windows drives (all files have 777 as permission)
# just changes the color of 777 files in general for the ls command
export LS_COLORS="ow=01;31:$LS_COLORS"

# add color
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# prompt
PROMPT='[%n@%m '			# '[username@host '
PROMPT+='%F{green}%1~%f'		# current folder name (in green)
PROMPT+=']%# '				# ']%' or ']#' if superuser 

RPROMPT="%(?..%F{red}[%?]%f)"	# show exit status of previous command if it is not 0 (in red)

# runs before each command
precmd() {
	# change window title
	print -Pn "\e]0;%n@%m:%~\a"  #Title: username@hostname: currentDirectory
}


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
# fetch the aliases file (if the file exists)
# currentDir gets the directory *this* file is in
currentDir="${0:A:h}"
customBashAliases_path="${currentDir}/aliases.shrc"
if [ -f $customBashAliases_path ]; then
	source $customBashAliases_path
else
	echo "custom.bashrc: aliases.shrc not found ($customBashAliases_path)"
fi


# shell integration
eval "$(zoxide init --cmd cd zsh)"	# fuzzy finding for cd (needs zoxide)

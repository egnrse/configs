# deprecated: env.bashrc
#
# a custom config file for bash (extends .bashrc)
# (https://github.com/egnrse/configs)
# (by egnrse)

# moved to `~/.config/environment.d/80-env.conf`
# 
## about ENVIRONMENT VARIABLES (with uwsm)
# since using uwsm, many apps will not see env-variables exported from .bashrc
# (see `https://github.com/Vladimir-csp/uwsm` 4-environments-and-shell-profile)
# put them into a file read by systemd (see `man 5 environment.d`)
# for user specific env-vars you can use `~/.config/environment.d/*.conf`
#
# tl;dr: don't put environment-variables here

## CUSTOM ENVIRONMENT VARIABLES
################################
#
# those can be accessed with "$varName"
# (in strings) the " (double qotes) are needed for command expansion (in '$varName' commands are not expanded)
#export EDITOR=nvim				# your prefered editor (eg. vim, nano)
#export TERMINAL=alacritty		# your prefered terminal (used in some scripts)
#export TERM_RUN="alacritty -e"	# run a command in a new shell



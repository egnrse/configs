#!/bin/env bash

# restart hyprswitch (the daemon)
# (https://github.com/egnrse/configs)
# (by egnrse)

logfile=~/.config/hyprswitch/hyprswitch.log

killall hyprswitch
sleep 0.5
hyprctl dispatch exec "uwsm app -- hyprswitch init --show-title --size-factor 6 --workspaces-per-row 3 --custom-css $HOME/.config/hyprswitch/style.css >> ${logfile} 2>&1"
# hyprswitch init  &	# use this if u dont have hyprctl
notify-send -u low "hyprswitch (daemon) restarted" & 

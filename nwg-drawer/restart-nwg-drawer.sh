#!/bin/env bash

# restart nwg-drawer
# by egnrse (https://github.com/egnrse/configs)
#
# in the background (-r), with some custom arguments
# -nofs:no file search, -c:amount of columns
# -fm: filemanager, -term: terminal, -wm: window manager

logfile=~/.config/nwg-drawer/nwg-drawer.log
# set TERMINAL as an environment variable with your favorite terminal (eg 'alacritty')
args="-r -c 8 -spacing 10 -fm dolpin -term $TERMINAL -wm 'hyprland' -nofs"
#args="-r -c 8 -spacing 10 -fm dolpin -term $TERMINAL -wm 'hyprland'"

killall nwg-drawer
sleep 0.5
# start in the background
#hyprctl dispatch exec -- nwg-drawer -r
#hyprctl dispatch exec -- nwg-drawer -r -c 8 -spacing 10 -wm 'hyprland'
hyprctl dispatch exec "uwsm app -- nwg-drawer ${args} >> ${logfile} 2>&1"

notify-send -u low "nwg-drawer (maybe) started in the background" "look into '${logfile}' for more information"&

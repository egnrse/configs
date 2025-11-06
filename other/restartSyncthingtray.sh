#!/usr/bin/env bash

# restart syncthingtray
# (https://github.com/egnrse/configs)
# (by egnrse)

logfile=~/.config/log/syncthingtray.log
program="syncthingtray-qt6"
flags="--replace"

killall $program
sleep 0.5
hyprctl dispatch exec "uwsm app -- $program $flags >> ${logfile} 2>&1"
# hyprswitch init  &	# use this if u dont have hyprctl
notify-send -u low "$program restarted" & 

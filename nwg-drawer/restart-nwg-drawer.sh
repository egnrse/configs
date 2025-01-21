#/bin/bash

# restart nwg-drawer
# by egnrse (https://github.com/egnrse/configs)
#
# in the background (-r), with some custom arguments
# -nofs:no file search, -c:amount of columns

logfile=~/.config/nwg-drawer/nwg-drawer.log

killall nwg-drawer
sleep 0.5
# start in the background
#hyprctl dispatch exec -- nwg-drawer -r
#hyprctl dispatch exec -- nwg-drawer -r -c 8 -spacing 10 -wm 'hyprland'
hyprctl dispatch exec "uwsm app -- nwg-drawer -r -c 8 -spacing 10 -wm 'hyprland' -nofs >> ${logfile} 2>&1"

notify-send -u low "nwg-drawer (maybe) started in the background" "look into '${logfile}' for more information"&

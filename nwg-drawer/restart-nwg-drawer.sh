#/bin/bash

# restart nwg-drawer
# by egnrse (https://github.com/egnrse/configs)
#
# in the background (-r), with some custom arguments

killall nwg-drawer
sleep 0.5
# start in the background
#hyprctl dispatch exec -- nwg-drawer -r
#hyprctl dispatch exec -- nwg-drawer -r -c 8 -spacing 10 -wm 'hyprland'
hyprctl dispatch exec -- nwg-drawer -r -c 8 -spacing 10 -wm 'hyprland' -nofs


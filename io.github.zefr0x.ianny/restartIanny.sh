#!/bin/env bash

# restart ianny
# (https://github.com/egnrse/configs)
# (by egnrse)

logfile=~/.config/io.github.zefr0x.ianny/ianny.log

killall ianny
sleep 0.5
hyprctl dispatch exec "ianny >> ${logfile} 2>&1"
# ianny  &	# use this if u dont have hyprctl
notify-send -u low "ianny restarted" & 

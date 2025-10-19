#!/bin/env bash

# restart ianny
# (https://github.com/egnrse/configs)
# (by egnrse)

logfile=~/.config/io.github.zefr0x.ianny/ianny.log

systemService="app-io.github.zefr0x.ianny@autostart.service"
if systemctl show -p ActiveState --value --user ${systemService} >/dev/null || systemctl show -p SubState --value --user ${systemService} >/dev/null; then
	echo "ianny is managed with the systemd user-service '${systemService}'"
	exit 0
fi

killall ianny
sleep 0.5
hyprctl dispatch exec "ianny >> ${logfile} 2>&1"
# ianny  &	# use this if u dont have hyprctl
notify-send -u low "ianny restarted" & 

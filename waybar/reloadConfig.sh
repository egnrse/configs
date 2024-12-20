#!/bin/bash
# reloads the config for waybar


killall -SIGUSR2 waybar
notify-send "waybar restarted"

#!/bin/bash

# sync the local DB folder with the DB folder from google drive
# by egnrse

rclone sync ~/Documents/DB/ gdrive-nit:/DB
if [ $? -eq 0 ]; then
	notify-send "uploadDB successful"
else
	notify-send "uploadDB probably failed"
fi
#rclone copy gdrive-nit:/DB ~/Documents/DB/

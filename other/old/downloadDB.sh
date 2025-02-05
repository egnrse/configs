#!/bin/bash

# sync the DB folder from google drive with the local DB folder
# by egnrse

rclone sync gdrive-nit:/DB ~/Documents/DB/
if [ $? -eq 0 ]; then
	notify-send "downloadDB successful"
else
	notify-send "downloadDB probably failed"
fi
#rclone copy gdrive-nit:/DB ~/Documents/DB/

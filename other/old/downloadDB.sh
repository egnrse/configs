#!/bin/env bash

# copy the DB folder from google drive into the local DB folder ($localPath)
# by egnrse

localPath=~/Documents/DB/

echo "syncing gdrive-nit:/DB with ${localPath}"
rclone copy gdrive-nit:/DB ${localPath}
if [ $? -eq 0 ]; then
	notify-send "downloadDB successful" "syncing 'gdrive-nit:/DB' with '${localPath}'"
else
	notify-send -u critical "downloadDB probably failed" "syncing 'gdrive-nit:/DB' with '${localPath}'"
fi
#rclone sync gdrive-nit:/DB ~/Documents/DB/

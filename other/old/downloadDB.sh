#!/bin/env bash

# sync the DB folder from google drive with the local DB folder ($localPath)
# by egnrse

localPath=~/Documents/DB/

echo "syncing gdrive-nit:/DB with ${localPath}"
rclone sync gdrive-nit:/DB ${localPath}
if [ $? -eq 0 ]; then
	notify-send "downloadDB successful" "syncing 'gdrive-nit:/DB' with '${localPath}'"
else
	notify-send "downloadDB probably failed" "syncing 'gdrive-nit:/DB' with '${localPath}'"
fi
#rclone copy gdrive-nit:/DB ~/Documents/DB/

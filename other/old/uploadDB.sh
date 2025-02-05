#!/bin/env bash

# sync the local DB folder ($localPath) with the DB folder from google drive
# by egnrse

localPath=~/Documents/DB/

echo "syncing '${localPath}' with 'gdrive-nit:/DB'"
rclone sync ${localPath} gdrive-nit:/DB
if [ $? -eq 0 ]; then
	notify-send "uploadDB successful" "syncing '${localPath}' with 'gdrive-nit:/DB'"
else
	notify-send "uploadDB probably failed" "syncing '${localPath}' with 'gdrive-nit:/DB'"
fi
#rclone copy gdrive-nit:/DB ~/Documents/DB/

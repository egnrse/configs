#!/bin/env bash

# copy the local DB folder ($localPath) with the DB folder from google drive 
# (ONLY copies 'KeePassElia2023_06.kbdx')
# by egnrse

localPath=~/Documents/DB/

echo "syncing '${localPath}' with 'gdrive-nit:/DB'"
rclone copy ${localPath} gdrive-nit:/DB --include "KeePassElia2023_06.kdbx"
if [ $? -eq 0 ]; then
	notify-send "uploadDB successful" "syncing '${localPath}' with 'gdrive-nit:/DB'"
else
	notify-send  -u critical "uploadDB probably failed" "syncing '${localPath}' with 'gdrive-nit:/DB'"
fi
#rclone sync gdrive-nit:/DB ~/Documents/DB/

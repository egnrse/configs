#!/bin/env bash

# copy the DB folder from google drive into the local DB folder ($localPath)
# by egnrse

localPath=~/Documents/DB/
fileName=KeePassElia2023_06.kdbx

echo "syncing gdrive-nit:/DB with ${localPath}"

# backup before download
cp ${localPath}/${fileName} ${localPath}/old/$(date +"%Y%m%d-%H%M%S")_${fileName}.bak


rclone copy gdrive-nit:/DB ${localPath}
if [ $? -eq 0 ]; then
	notify-send "downloadDB successful" "syncing 'gdrive-nit:/DB' with '${localPath}'"
else
	notify-send -u critical "downloadDB probably failed" "syncing 'gdrive-nit:/DB' with '${localPath}'"
	
	# test if we are in an interactive shell
	if [ -t 0 ]; then
		echo ""
		tokenText="If the token has expired, try refreshing it" # with: 'rclone config reconnect gdrive-nit:'
		read -p "$tokenText (y/N): " answer
		case $answer in
			[Yy]*)
				rclone config reconnect gdrive-nit:
				;;
			[Nn]*|"")
				;;
		esac
	fi
fi
#rclone sync gdrive-nit:/DB ~/Documents/DB/

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

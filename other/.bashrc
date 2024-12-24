# ~/.bashrc: executed by bash(1) for non-login shells.


# fetch the custom config file for bash (if it exists)
# $customBashConfig_path is the path to the config file
customBashConfig_path="$HOME/.config/bash/custom.bashrc"
if [ -f "$customBashConfig_path" ]; then
	source $customBashConfig_path
else
	echo ".bashrc: path to config not found ($customBashConfig_path)"
fi

## CUSTOM LOCATIONS
export data='/mnt/data/'
export d="$data"
export dDoc="${data}/Documents#2/"
export dDocs="${data}/Documents#2/"
export dTU="${data}/Documents#2/TU/"

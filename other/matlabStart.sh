#!/bin/bash

# a custom script to start matlab with custom flags using Xwayland
# 
# I used the installer for linux from: `https://de.mathworks.com/downloads/`
# some Fixes:
# 	remove the following file (or move it to (.*).bak): `{PathToMatlab}/sys/os/glnxa64/libstdc++.so.6`
# 		(matlab ships with their own libraries, removing them forces matlab the use your systems libraries)
# 		( I think u need to have a `gcc` dependency installed, for this to work )
# 	create a new file: `matlab_R2024b/bin/glnxa64/java.opts: -Djogl.disable.openglarbcontext=1`
# 		(see `https://wiki.archlinux.org/title/MATLAB` in chapter 4)
# 	matlab still uses the old version of a package: `libxcrypt-compat`
# 	some more fixes u can find in the arch wiki (link above)
# 	your can find a list of matlab dependencies here: `https://aur.archlinux.org/packages/matlab`
#
# (by egnrse)

# absolute path to the folder with matlab (eg. `/usr/local/src/matlab_R2024b/`)
matlabPath="/usr/local/src/matlab_R2024b/"

# flags to start matlab with (use `matlab -h` to get all possible arguments)
flags="-desktop -useStartupFolderPref $@"

QT_QPA_PLATFORM=xcb		# set X11 for QT apps
echo "opening '${matlabPath}bin/matlab' with '${flags}' on ${QT_QPA_PLATFORM}"
${matlabPath}bin/matlab ${flags}

# some of my configs [WIP]
THIS IS STILL DEVELOPING! PR/issues are very welcome.  

This config is for my arch/[hyprland](https://hyprland.org/) setup. Some of those configs I use on my windows machine too.

Make sure to install the packages needed for this config. (some dependencies are listed in each section, for a *fuller* list look into the [Appendix](#Appendix) under [packages](#packages))  

This config uses the [Universal Wayland Session Manager (uwsm)](https://github.com/Vladimir-csp/uwsm) some parts will break without this dependency.  

For most configs, sparse-clone this git OR copy the files you want into the `~/.config/*/` folder. (with \* being the name of the program)  
TODO: change this to a link based system (using `stow`?)

I use sparse-checkout and exlude to only get specific files with git. Sadly, the README.md file always gets cloned.  
Except for files in the `other` folder all files should already be at the right place after cloning this repo. 

## set up some config syncing
*(If u fork this first, u can sync and save your own configs)*  
Go into one of the following paths:  
unix: `~/.config/`  
win:  `C:\Users\<USERNAME>\AppData\Local\`
```
git init
git remote add origin https://github.com/egnrse/configs
git config core.sparseCheckoutCone true
```
Choose the folders that u want:
```
git sparse-checkout set alacritty bash dunst environment.d hypr nvim nwg-drawer scripts tofi waybar wlogout
```
(many of the configs rely on scripts and environment.d (or on each other) taking only a few might break things)  

Finish the setup:
```
git pull origin main
git branch --set-upstream-to=origin/main main
```

#### setup git exlude
`./.git/info/exlude`  
Is a file to exclude local files/folders from git.
Copy the content (that u need) of the file `/other/exclude` to `./.git/info/exclude`     

## Synced configs:
*({program name}: ({path in this git}))*
- [alacritty](#alacritty): (/alacritty/)
- [bash](#bash):      (/bash/)
- [dunst](#dunst):     (/dunst/)
- [git](#git):    (/other/.gitconfig)
- [hyprland](#hyprland):  (/hypr/)  
- [neovim](#nvim): (/nvim/)  
- [nwg-drawer](#nwg-drawer):    (/nwg-drawer/)
- [scripts](#scripts):  (/scripts/)  
- [tofi](#tofi):     (/tofi/)
- [v-editor](#v)       (/other/v-editor)  
- [vim](#vim):    (/other/.vimrc)  
- [waybar](#waybar):    (/waybar/)
- [wlogout](#wlogout):  (/wlogout/)  
- [general Theme](#general-theme): (egnrseTheme.css)
- [misc](#misc):  (/other/*)

wanting to add:
- rofi?
- sddm
- a doc with common fixes

### [alacritty](https://alacritty.org/config-alacritty.html)
*(/alacritty/) (Linux)*  
in win10 add: (does **NOT** work yet)  
```
[general]
import = ["../../Local/alacritty/alacritty.toml"]
```
to `%APPDATA%\alacritty\alacritty.toml`  

This file has some visual changes to make alacritty more beautiful.  

### bash
*(/bash/) (Linux)*  
My config is split into two/three parts:  
- custom.bashrc (general settings)  
- aliases.bashrc (aliases for commands)  
- [~/.bashrc (for device specific settings, not fully in this git)]  

add this to your `~/.bashrc` (or similar) to source the files:
```
# fetches the config file for bash (if it exists)
# $customBashConfig_path is the path to the custom config file
customBashConfig_path="$HOME/.config/bash/custom.bashrc"
if [ -f "$customBashConfig_path" ]; then
	source $customBashConfig_path
else
	echo "path to config not found ($customBashConfig_path)"
fi
```
Some more infos are in the files.  
(be careful when settings environment variables)  

I use `trash-d`<sup>AUR</sup> as a drop in replacement for `rm` (TODO: look into autotrash<sup>AUR</sup>)

### [dunst](https://dunst-project.org/)
*(/dunst/) (Linux)*  
A notification (service) deamon, after cloning this git all files should already be in the right place (some explanations for the options are in the file)  
Some settings only work on X11! (those should be marked)  
There is a custom script `restartDunst.sh` that restarts dunst and sends some notifications, to easily test changes in dunstrc.  

### git
*(/other/.gitconfig)*  
Copy the parts that u like into `~/.gitconfig`. It has some useful aliases.  
Replace the placeholders if needed (eg {email}, {computerName}).  
(fully replacing your old config-file is **not** recommended)  

### [hyprland](https://hyprland.org/)
*(/hypr/) (Linux)*  
A wayland native (tiling/hybrid) window manager.  
This config is split into 4 parts:  
- hyperland.conf (the main config file)  
- look-feel.conf (animations, borders, gaps, ...)
- window-rules.conf (rules on how windows/layers/workspaces/apps behave)  
- maps.conf      (key mappings)
- plugins.conf	 (plugins, including plugin keymappings)
Many explanations are in the config files.  

This config uses the [Universal Wayland Session Manager (uwsm)](https://github.com/Vladimir-csp/uwsm)  and some parts will not work with out this dependency.  
See `https://wiki.hyprland.org/Useful-Utilities/Systemd-start/`  

#### Keymappings
`SUPER+CTR+L`   : close/exit/logout-menu (wlogout)  
`SUPER+Q`       : opens $terminal (alacritty)  
`SUPER+E`       : opens File Browser (dolphin)  
`SUPER+D`       : program drawer (nwg-drawer)  
`SUPER+C`       : close active window  
  
`SUPER+[1-0]`   : go to workspace [1-10]  
`SUPER+S`       : go to special workspace  
`SUPER+SHIFT+[1-0]` : move current window to workspace [1-10]  
`SUPER+CTRL+[1-0]` : move current window to workspace (silently) [1-10]  
`SUPER+SIFT+S`  : move current window to special workspace  
  
`SUPER+V`       : toggle floating (for the active window)  
`SUPER+P`       : pin the active windows (to stay visible on all workspaces)  
`SUPER+O`       : toggle split Orientation (how the (old) window was split)    
`SUPER+I`       : switch split side  
`SUPER+M`       : maximize active window (keep borders/bars)  
`F11`           : make active window fullscreen  

`SUPER+R`       : simple program launcher (tofi)  
*(for more look into /hypr/maps.conf or /hypr/plugins.conf)*  

Move windows with `SUPER+LeftMouse`/`SUPER+Space`, resize them with`SUPER+RightMouse`/`SUPER+ALT+Space` (use `SHIFT` to keep the aspect ratio) or right-clicking on the edges and dragging.  

#### Plugins  
- [Hyprspace](https://github.com/KZDKM/Hyprspace): window overview (`SUPER+Tab`)(not used anymore)
- hypergrass: better touch screen support (swipe bottom to left for [wvkbd-latop](#onscreen-keyboard) keyboard)  

### [nvim](https://neovim.io/)
*(/nvim/) (Win10/Linux)*  
Some explanations of the settings are in the files. The setup Leader-Key is Space. (meaning: some shortcuts start with the Space-Key)  
- Main setup in `init.lua`  
- Custom keymapings in `./lua/maps.lua`  
- Lazy Plugin Manager in `./lua/config/lazy.lua` (no extra setup needed)  
  Settings for the plugins are in their files (`./lua/plugins/*`)  
  - bufferline (top bar with *file* tabs)  
  - cmp (autocompletion)  
  - colorscheme (tokyodark)  
  - lualine (status line)  
  - lush (color schemecreator, not used yet)  
  - nvim-autopairs (autocomplete brackes and more)  
  - [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) (file explorer) {Leader+E}  
  - misc (eg. nvim-colorizer)  

### scripts
*(/scripts/) (Linux)*  
Some of my custom scripts used by other configs (eg. waybar, hyprland).  
A better place to put custom scripts (than in the .config folder) is in `$HOME/.local/share/bin`. I linked `$HOME/.local/share/bin/scripts` to `$HOME/.config/scripts/` (where the files will land if u just clone this git).  
You can do this with:  
```
ln -s $HOME/.config/scripts/ $HOME/.local/share/bin/scripts
```
Make sure the path ($HOME/.local/share/bin) exists (else the command fails).

Some scripts have settings/dependencies that are written in the top of the scripts. Some of the scripts will warn about and handle missing dependencies gracefully. (sadly not all of them yet)  

General Needs (for some of the scripts):
- wayland
- [hyprland](#hyprland)
- a notification deamon (eg. [dunst](#dunst))
- pacman-contrib


### [tofi](https://github.com/philj56/tofi)
*(/tofi/) (Linux)*  
A (very fast) wayland app launcher, with two themes. Select which one is active in `config`. `oldConf` has more explaining comments.  

### v
*(/other/v-editor) (Linux)*  
Use `v` in a console or script to launch the prefered editor (stored in *$EDITOR*).  
Copy the file to `/usr/bin/`, rename it to `v` and make it executable. More explanations are in the file.  
U can also use the alias in `bash/aliases.bashrc` for a simpler setup, with similar functionality.  
TODO: make this a proper package (in AUR?)  

### vim
*(/other/.vimrc) (Win10/Linux)*  
This is a very simple setup that I use, when I can't use nvim.  
Copy the file to `~/`, some infos are in the file. I use Plug as a Plugin Manager, it should autoinstall itself. Should work on Win10 and Linux.  

### [waybar](https://github.com/Alexays/Waybar)
*(/waybar/) (Linux)*  
A wayland statusbar, with some custom scripts for extra functionallity. U can right/left-click or scroll on many modules.  
There is a custom script `reloadConfig.sh` that reloads the configuration, to easily test changes for waybar.
There is also a custom wifimenu, a custom package update helper and many other features.  

The config is split into multiple parts:
- config.jsonc (main config)
- modules.jsonc (settings for most modules)
- modules/*  (settings for all other modules)
- style.css (styling)
- theme.css (colors used by style.css, imports `egnrseTheme.css`)
- scripts  (some scripts for extra functionality)

Needs:
- `.config/scripts/` (some scripts from this git)
- egnrseTheme.css (in this git)  
- [wlogout](#wlogout) (custom powermenu)
- wayland
- hyprlctl (included in hyprland)
- a notification service (eg. [dunst](#dunst))
- rofi-wayland (for the custom wifi-menu, u can also mostly use rofi)
- networkmanager
- blueman-manager (bluetooth gui)
- wireplumber (audio-server, config has to be changed for it to work with ALSA only)
- pwvucontrol<sub>AUR</sub> helvum (audio-management gui)

### wlogout
*(/wlogout/) (Linux)*  
A wayland PowerMenu (to logout/shutdown/...). theme-1 is longer (6 items), theme-2 only 4 has options. Both themes have a layout-\* file and a styles-\*.css.  
U can use `/scripts/logoutlaunch.sh` (with args $1= 1 or 2) to launch those themes. They (should) scale automatically with display size and the scaling parameter.
Needs:  
- egnrseTheme.css (in this git)
- hyprland


### general Theme
*(egnrseTheme.css) (Linux)*  
still a work in progress  
The Idea is to have one file where I can change all colors for all apps/packages I use.  
Already works for all that use \*.css files. (eg. waybar, wlogout), in all other configs the colors are hardcoded.  

### misc
Other things that might I use...
TODO: get a list of all dependencies (eg<sub>AUR</sub>)

#### onScreen Keyboard
(/other/wvkbd*)  
Put the binary `wvkbd-laptop` in a directory on the path (eg. `/usr/local/bin/`) to use it system-wide (hyprland/sddm/the desktop-entry expect that)  
Put the desktop-entry in eg. `~/.local/share/applications/` (or follow the instructions in the file).  
Swipe with one finger from the bottom up (on a touch screen) to toggle the keyboards visibility. (within [hyprland](#hyprland) with the hyprgrass plugin)

#### [Nerd-Font](https://www.nerdfonts.com)
(/other/DejaVuSansMono.zip)  
The font used by many/some of the configs in this git.  
Download it or install it over pacman: `ttf-dejavu-nerd`

#### cool/usefull Packages
zerotier-one
joplin-desktop<sup>AUR</sup>
beeper-latest-bin<sup>AUR</sup>

## Appendix
### FIXES?
#### Electron Apps
If apps are blurry (on wayland) it might be using xWayland, you can fix this by adding the following to the launch-command of the app:  
(the launch command prob. is in `/usr/bin/{APP}`)  
`--enable-features=UseOzonePlatform --ozone-platform=wayland`

### other useful (git) commands:
`git config core.sparseCheckout true` : can also add single files to the sparsity list (not only directories)  
`git config --global core.editor "nvim"`  
`git config status.showUntrackedFiles no`  
`git sparse-checkout list`  
`git read-tree -mu HEAD` : reload current files from tree
`git remote set-url origin github:egnrse/configs.git` : setup your `~/.ssh/config` for github first  
`git reset --hard origin/main` : reset current branch to origin/main (will discard all local changes)

### ssh
use `~/.ssh/config`  
`ssh -T github` : test github connection  

### packages
not all AUR packages are marked yet (example<sub>AUR</sub>)  

plasma-meta hyprland sddm uwsm		(window/login/session manager)  
neovim vim git sudo grub openssh 	(some basics)  
man-db man-pages  
ntfs exfat-utils 			(filesystem types)  
yay flatpak wget pacman-contrib 	(package manager+)  
networkmanager	bluez-utils blueman	(internet/networking/bluetooth)  
pipewire pipewire-docs wireplumber wireplumber-docs helvum pwvucontrol<sup>AUR</sup> (audio)  
waybar dunst tofi<sup>AUR</sup> rofi-wayland wlogout	(statusbar, notifications, {app} browser)  
zerotier-one firefox alacritty  
appimagelauncher ttf-dejavu-nerd dolphin  
qt5-wayland polkit-kde-agent  
obs-studio libreoffice-fresh  
joplin-desktop<sup>AUR</sup> beeper-latest-bin<sup>AUR</sup>  

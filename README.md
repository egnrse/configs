# some of my configs
THIS IS STILL DEVELOPING!  

In this repo are only configs not their programs, those u must have installed previously.  

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
git sparse-checkout set nvim alacritty hypr waybar
```
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
- vim:    (/other/.vimrc)  
- neovim: (/nvim/)  
- v       (/other/v-editor)  
- alacritty: (/alacritty/)  
- dunst:     (/dunst/)  
- hyprland:  (/hypr/)  
- waybar:    (/waybar/)  
- bash:      (/bash/)  
- general Theme: (egnrseTheme.css)
- git:    (/other/.gitconfig)
- Nerd-Font: (/other/DejaVuSansMono.zip)

wanting to add:
- rofi?
- wofi
- wlogout
- sddm
- a doc with common fixes

### vim
*(/other/.vimrc) (Win10/Linux)*  
Copy the file to `~/`, some infos are in the file. I use Plug as a Plugin Manager, it should autoinstall itself. Should work on Win10 and Linux.  

### nvim
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
  - nvim-tree (file explorer) {Leader+E}  
  - other (misc plugins)  

### v
*(/other/v-editor) (Linux)*  
Use `v` in a console or script to launch the prefered editor (stored in *$EDITOR*).  
Copy the file to `/usr/bin/`, rename it to `v` and make it executable. More explanations are in the file.

### alacritty
*(/alacritty/) (Linux)*  
in win10 add: (does not work yet)  
```
[general]
import = ["../../Local/alacritty/alacritty.toml"]
```
to `%APPDATA%\alacritty\alacritty.toml`  

### dunst
*(/dunst/) (Linux)*
a notification service, after cloning this git all files should already be in the right place (some explanations for the options are in the file)  

### hyprland
*(/hypr/) (Linux)*  
might not (fully) work without some other (not yet here) stuff (eg. wofi, waybar, someScripts, dunst, dolphin)  

a wayland native (tiling) window manager  
This config is split into 3 parts:  
- hyperland.conf (the main config file)  
- look-feel.conf (animations, borders, gaps, ...)  
- maps.conf      (key mappings)  
#### keymapings
*(for more look into /hypr/maps.conf)*  
`SUPER+CTR+L`   : close/exit/logout (wlogout)  
`SUPER+Q`       : opens $terminal (alacritty)  
`SUPER+E`       : opens File Browser (dolphin)  
`SUPER`         : program launcher (wofi)  
`SUPER+C`       : close active window  
  
`SUPER+[1-0]`   : go to workspace [1-10]  
`SUPER+S`       : go to special workspace  
`SUPER+SHIFT+[1-0]` : move current window to workspace [1-10]  
`SUPER+SIFT+S`  : move current window to special workspace  
  
`SUPER+V`       : toggle floating (for the active window)  
`SUPER+P`       : pin the active windows (to stay visible on all workspaces)  
`SUPER+I`       : toggle how the (old) window was split (when inserting a new window)  
`SUPER+O`       : switch split side  
`SUPER+M`       : maximize active window (keep borders/bars)  
`F11`           : make active window fullscreen  

Move windows with `SUPER+LeftMouse`, resize them with`SUPER+RightMouse` or right-clicking on the edges and dragging.



### waybar
*(/waybar/) (Linux)*
**! some scripts used by this config are not in this git yet!**  
a wayland statusbar, with some custom scripts for extra functionallity.  
Needs:  
- wayland  
- wlogout (custom powermenu)  
- networkmanager  
- wofi (custom wifi-menu)  
- notification service (eg dunst)  

### bash
*(/bash/) (Linux)*  
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
Some more info is in the files.  

### general Theme
*(egnrseTheme.css) (Linux)*  
still a work in progress  
The Idea is to have one file where I can change all colors for all apps/packages I use.

### git
*(/other/.gitconfig)*  
copy parts of the file into `~/.gitconfig`. It has some useful aliases (replacing your old config-file is not adviced)  

### [Nerd-Font](https://www.nerdfonts.com)
(/other/DejaVuSansMono.zip)  
or install it over pacman: `ttf-dejavu-nerd`

## Appendix
### other useful (git) commands:
`git config core.sparseCheckout true` : can also add single files to the sparsity list (not only directories)  
`git config --global core.editor "nvim"`  
`git config status.showUntrackedFiles no`  
`git sparse-checkout list`  
`git remote set-url origin github:egnrse/configs.git` : setup your `~/.ssh/config` for github first  

### ssh
use `~/.ssh/config`  
`ssh -T github` : test github connection  

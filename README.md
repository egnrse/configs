# some of my configs [WIP]
THIS IS STILL DEVELOPING and always will! PR/issues are very welcome.  

This config is for my arch/[hyprland](https://hyprland.org/) setup. It is made for a Laptop and a PC (in a multimonitor setup, with (sadly) a nvidia graphicscard). Some of those configs I use on my (dualbooted-)windows pc too. (eg. nvim/alacritty)  

Make sure to install the packages needed for this config. (some dependencies are listed in each section, for a *fuller* list look into [#packages](#packages) in the [#Appendix](#appendix))  

This config uses the [Universal Wayland Session Manager (uwsm)](https://github.com/Vladimir-csp/uwsm) many (hyprland) parts will break without this dependency.  

I use an install script `./installV*.sh` to (sym-)link my local git with the config folders (mostly in `~/.config/`) and move some files around. (Look at the security warning in the file!) [WIP]

![Preview](other/rice_pics/rice2025-01.png)


## set up some config syncing
*(If u fork this first, u can sync and save your own configs)*  

### install script (sym linking) [WIP]
Clone the repo into a folder of your choosing and run the install script `./installV0.sh`.  
(!! the script is very fragile, change the variables in the script and look what it does !!)  
(most old files that the script will find it will move to ~/.config/.bak/)  
Currently some files still need to be moved manually. Most of them are files outside of `~/.config/`.  
TODO: make it more interactive (with an -a option?)  

[the old method can be found here](#old-setup-method-git-config)

## Synced configs:
<details>
  <summary>Overview</summary>

- [alacritty](#alacritty): (/alacritty/)
- [bash](#bash):      (/bash/)
- [bottom](#bottom): (/bottom/)
- [dunst](#dunst):     (/dunst/)
- [git](#git):    (/other/.git\*)
- [hypridle](#hypridle):  (/hypr/)
- [hyprland](#hyprland):  (/hypr/)  
- [hyprlock](#hyprlock):  (/hypr/)
- [neovim](#nvim): (/nvim/)  
- [nwg-drawer](#nwg-drawer):    (/nwg-drawer/)
- [rofi](#rofi):    (/rofi/)
- [scripts](#scripts):  (/scripts/)  
- [sddm](#sddm): (/other/sddm.conf)
- [ssh](#ssh):  (/other/ssh_config)
- [systemd](#systemd)    (/environment.d/))
- [tofi](#tofi):     (/tofi/)
- [vim](#vim):    (/other/.vimrc)  
- [waybar](#waybar):    (/waybar/)
- [wlogout](#wlogout):  (/wlogout/)  
- [zsh](#zsh): (/zsh/)
- [general Theme](#general-theme): (egnrseTheme.\*)
- [misc](#misc):  (/other/\*)

{program name}: ({path in this git})

- [Appendix](#appendix)
	- [some Fixes](#some-fixes--useful-extensions-for-used-packages)
	- [Packages](#packages)

</details>

wanting to add:
- nothing rn


### [alacritty](https://alacritty.org/config-alacritty.html)
*(/alacritty/)*  
This file has some visual changes to make alacritty more beautiful.  

<details><summary>Deprecated Win10 support</summary>

in win10 add: (does **NOT** work yet)  
```
[general]
import = ["../../Local/alacritty/alacritty.toml"]
```
to `%APPDATA%\alacritty\alacritty.toml`  
</details>


### bash
*(/bash/ /shell/\*)*  
My config is split into multiple parts:  
- custom.bashrc (general settings)  
- maps.inputrc (custom key mappings)
- ../shell/\* (settings used by all shells)  
- [~/.bashrc (for device specific settings, not fully in this git)]  

<details><summary>More Info</summary>

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
(be careful when setting environment variables)  

I use `trash-d`<sup>AUR</sup> as a drop in replacement for `rm` (TODO: look into autotrash<sup>AUR</sup>)
</details>

### [bottom](https://github.com/ClementTsang/bottom)
*(/bottom/)*  
Config for a graphical process/system monitor for the terminal. You can launch it by running `btm` or (within this config) by pressing `Ctr+Shift+Esc`.  

<details><summary>Details</summary>
#### Keymappings
`?`     : open help menu  
`e`     : focus/fullscreen current selection  
`q`     : close  
`Esc`   : unfullscreen / close dialogs, search  
`+-=`   : zoom in/out/reset  
in Processes:  
`/`      : search  
`dd`     : send a signal to the selected process  
</details>


### [dunst](https://dunst-project.org/)
*(/dunst/)*  
A notification (service) daemon, after cloning and installing this git, all files should already be linked correctly (some explanations for the options are in the file)  
Some settings only work on X11! (those are be marked)  
There is a custom script `restartDunst.sh` that restarts dunst and sends some notifications (if any `$1` is given), to easily test changes in dunstrc.  


### git
*(/other/.gitconfig, /other/.gitignore_global, /other/.gitconfig_custom)*  
Source `.gitconfig_custom` in your `~/.gitconfig`:
```
[include]
	path = ~/.gitconfig_custom
```
It has useful aliases, a global .gitignore and other misc settings.

A example `~/.gitconfig` is in `/other/.gitconfig`. Replace the placeholders if needed (eg. {email}, {computerName}).  
(fully replacing your old config-file is **not** recommended)  


### hypridle
*(/hypr/hypridle.conf)*  
An idle deamon. To start it automatically on system startup (with systemd) run:  
`systemctl --user enable --now hypridle.service`  
Needs: [hyprland](#hyprland) [hyprlock](#hyprlock)  

### [hyprland](https://hyprland.org/)
*(/hypr/)*  
A wayland native (tiling/hybrid) window manager.  
This config is split into 4(+) parts:  
- hyperland.conf (the main config file)  
- look-feel.conf (animations, borders, gaps, ...)
- window-rules.conf (rules on how windows/layers/workspaces/apps behave)  
- maps.conf      (key mappings)
- plugins.conf	 (plugins, including plugin keymappings) (non are used currently)  
Many explanations are in the config files.  

This config uses the [Universal Wayland Session Manager (uwsm)](https://github.com/Vladimir-csp/uwsm)  and many parts will not work with out this dependency.  
See `https://wiki.hyprland.org/Useful-Utilities/Systemd-start/`  
! This config DISABLES touch devices !  

<details> <summary>Keymappings:</summary>

#### Keymappings
`SUPER+CTR+L`   : close/exit/logout-menu (wlogout)  
`SUPER+Q`       : opens $terminal (alacritty)  
`SUPER+E`       : opens File Browser (dolphin)  
`SUPER+R`       : run a program (tofi)  
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

`SUPER+D`       : program drawer (nwg-drawer)  
*(for more keymappings look into /hypr/maps.conf or /hypr/plugins.conf)*  

Move windows with `SUPER+LeftMouse`/`SUPER+Space`, resize them with`SUPER+RightMouse`/`SUPER+ALT+Space` (use `SHIFT` to keep the aspect ratio) or right-clicking on the edges and dragging.  
</details>

<details><summary>Plugins/Extensions:</summary>

#### [Hyprswitch](https://github.com/H3rmt/hyprswitch)
*(/hyprswitch/)*  
CLI/GUI to switch between window in hyprland (`hyprswitch`<sup>AUR</sup>)  
The daemon should get started with hyprland. There is also a custom script `restartHyprswitch.sh` to (re-)start the hyprswitch daemon.
Needs: egnrseTheme.css hyprswitch<sup>AUR</sup>  

#### not used anymore:
- [Hyprspace](https://github.com/KZDKM/Hyprspace)
window overview (`SUPER+Tab`)(not used anymore)
- [hypergrass](https://github.com/horriblename/hyprgrass)
better touch-screen support (not used anymore)

</details>

Hyprland needs: uwsm<sup>AUR</sup> alacritty tofi<sup>AUR</sup> waybar xdg-terminal-exec<sup>AUR</sup> wlogout<sup>AUR</sup> dunst dolphin nwg-drawer bottom pa-notify<sup>AUR</sup>  
Works nicely with: hypridle hyprlock xdg-desktop-portal-hyprland  


### hyprlock
*(/hypr/hyprlock.conf)*  
A screen lock config. It needs `egnrseTheme.conf` for the colors.  

### [ianny](https://github.com/zefr0x/ianny)
*(/io.github.zefr0x.ianny/)*  
Utility that periodically informs the user to take breaks. Change the reminder periods in `./io.github.zefr0x.ianny/config.toml`.  
Should get started with hyprland. There is also a custom script `restartIanny.sh` to (re-)start Ianny.  

### [nvim](https://neovim.io/)
*(/nvim/)*  
Some explanations of the settings are in the files. The setup Leader-Key is Space. (meaning: some shortcuts start with the Space-Key)  
- Main setup in `init.lua`  
- Custom keymapings in `lua/maps.lua`  
- Lazy Plugin Manager in `lua/config/lazy.lua` (type `:Lazy` within nvim for the plugin menu)  
  Settings for the plugins are in their files (`lua/plugins/*.lua`)  
  - bufferline (top bar with *file* tabs)
  - cmp (autocompletion)
  - colorscheme (tokyodark)
  - lualine (status line)
  - lush (color schemecreator, not used yet)
  - markdown (some inline rendering)
  - nvim-autopairs (autocomplete brackes and more)
  - nvim-lint (linting (eg. marking wrong code) WIP)
  - [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) (file explorer) {Leader+E}
  - misc (eg. nvim-colorizer)

Linting is still a WIP. You might need a bash-language-server.  

### [nwg-drawer](https://github.com/nwg-piotr/nwg-drawer)
*(/nwg-drawer/)*  
A program drawer with math / filesearch (currently disabled for performace reasons) support. Same usage as tofi, but slower and more graphical (eg. program icons/categories)  
Is silently started with some custom options when hyprland starts. You can also find those options in the `restart-nwg-drawer.sh` script.  
Use the math function by searching for eg. `8*4`. The answer will be shown in a popup when pressing `ENTER`.  
Needs: egnrseTheme.css  

### [rofi](https://github.com/lbonn/rofi)
*(/rofi/)*  
Similar to tofi, used for the custom wifimenu (of waybar). For wayland use the `rofi-wayland` package (and NOT `rofi`).  

### scripts
*(/scripts/)*  
Some of my custom scripts used by other configs (eg. waybar, hyprland).  
This config expects to find them in `$HOME/.local/share/bin/scripts`.  

Some scripts have settings/dependencies that are written in the top of the scripts. Some of the scripts will warn about and handle missing dependencies gracefully. (sadly not all of them yet)  

General Needs (for some of the scripts):
- wayland
- [hyprland](#hyprland)
- a notification daemon (eg. [dunst](#dunst))
- pacman-contrib

### [sddm](https://github.com/sddm/sddm)
*(/other/sddm.conf)*  
A display manager for X11 and Wayland sessions. I use it to login into accounts and select which compositer I want to use. It also allows me to select which compositor to login into, in the bottom left corner. (I also have KDE-Plasma installed (from the `plasma-meta` package))  
U can also select hyprland with and without uwsm, this config expects to be started *managed by uwsm*.  
Copy the config to `/etc/sddm.conf.d/sddm.conf`. If there are other config files already there, make sure sddm will read it last (see `man 5 sddm.conf`).  
A easy way to style sddm is with the KDE-System-Settings.  
(TODO: look into QtQuick for theme design, fix onscreen-keyboard env? kde_wayland?)  
Needs: breeze (the theme used)  

### ssh
*(/other/ssh_config)*  
Some custom ssh settings. Needs to be included in `~/.ssh/config` (after copying the file).
```
Include ~/.ssh/ssh_config
```

### systemd
*(/environment.d/)*  
Some environment variables for systemd. Prob. not well done currently. (!! is setting wayland variables !!)

### [tofi](https://github.com/philj56/tofi)
*(/tofi/)*  
A (very fast) wayland app launcher, with two themes. Select which one is active in `config`. `oldConf` has more explaining comments.  
Needs: `/usr/share/fonts/TTF/DejaVuSansMNerdFont-Regular.ttf` (look into [Nerd-Font](#nerd-font))

### vim
*(/other/.vimrc)*  
This is a ~~very simple~~ setup that I use, when I can't use nvim. The Leader-Key is Space. (meaning: some shortcuts start with the Space-Key)    
Copy the file to `~/`, some infos are in the file. I use Plug as a Plugin Manager, it should autoinstall itself. This configs should work on Win10 and Linux.  

<details><summary>some Settings/usage Help</summary>
	
Currently, all settings are in one file (`~/.vimrc`)  
Plugins:
- [lightline](https://github.com/itchyny/lightline.vim) (statusline)
- vim-markdown
- [NERDTree](https://github.com/preservim/nerdtree) (file explorer) {Leader+E}
- [vim-autotag](https://github.com/craigemery/vim-autotag) (update [ctags](#ctags) on file save)

For how to use [ctags](https://github.com/universal-ctags/ctags) look into [#ctags](#ctags) under [Misc](#misc).  

The config file explains it the best, but...  
Some key mappings: (remember <leader> = Space)  
`Ctr-s`         : save file (buffer)  
`<leader>tn`    : new tab (functions like tabs in eg. vscode)  
`<leader><Tab>` : switch to next tab (functions like tabs in eg. vscode)  
`<leader>td`    : close tab (tab delete)  
`<leader>tD`    : force close tab (tab delete!)  
`<leader>bn`    : switch to next buffer(= open file) (in the current tab) (buffer next)  
`<leader>bd`    : close current buffer (buffer delete)  
`<leader>bD`    : force close current buffer (buffer delete!)  
`Ctr- hjkl`     : move to the buffer window in this direction (like `Ctr-W hjl`)  
`<leader>|`     : split window vertically (`Ctr-W v`)  
`<leader>-`     : split window horizontally (`Ctr-W s`)  
`<leader>wm`    : maximize window   
`C-Arrows`      : resize current window  
`<leader>th`    : open a terminal in a new horizontal split (terminal horizontal)  
`<leader>tv`    : open a terminal in a new vertical split  
`<Esc><Esc>`    : exit terminal mode, close popups  
`<leader>}`     : open definition in a preview window (`Ctr-W }`)  
`C-e`           : toggle filemanager  
`:Q`            : close all (qa)  

`/pattern`      : search for `pattern`  
`*`             : search for focused word  
`n/N`           : next/previous search result  
`:noh`          : disables search highlighting (no highlight)  
`Ctr-N`         : (cycle/show) autocompletion  
`Ctr-P`         : cycle/show autocompletion from the back  
`%`             : go to matching bracket  
`gd/gD`         : go to declaration (local/global)  
`Ctr-]`         : jump to tag (eg. function/variable definition)  
`Ctr-T`         : jump back (from tags)  
`50G`           : jump to line 50  
`gg/G`          : jump to start/end of file  
`Ctr-o`         : jump the jumplist back  
`Ctr-i`         : jump the jumplist forward  
`Ctr-W }`       : open definition in a preview window (close it with `Ctr-W z`)  
`Ctr-W ]`       : open definition in a new window (switch window)  
`Ctr-W n`       : open a new empty window  
`Ctr-W c`       : close current window  
`Ctr-W o`       : close (all) other windows  
`Ctr-W r`       : rotate all windows  
`Ctr-W :`       : same as typeing `:` (also works in the command line)  
`[i`            : shows first mention in file in command line (show identifier)  
`[I`            : shows ALL mentions in a file in the command line  
`Ctr-R =`       : in INSERT mode, calculate the next thing u type and inserts it  
`:%s/pat/rep/gc`: search and replace all instances of `pat` with `rep` (g: globally, c: ask before each (choice))  
`K`             : open man/help page of focused command  
`:ls/:tabs`     : list open buffer/tabs  

</details>

### [waybar](https://github.com/Alexays/Waybar)
*(/waybar/)*  
A wayland statusbar, with some custom scripts for extra functionality. U can right/left-click or scroll on many modules.  
There is a custom script `reloadConfig.sh` that reloads the configuration, to easily test changes for waybar.
There is also a custom wifimenu, a custom package update helper and many other features.  

The config is split into multiple parts:
- config.jsonc (main config)
- modules.jsonc (settings for most modules)
- modules/*  (settings for all other modules)
- style.css (styling)
- theme.css (colors used by style.css, imports `egnrseTheme.css`)
- scripts  (some scripts for extra functionality)

<details> <summary>Needs:</summary>
	
- uwsm<sup>AUR</sup> (for some app starts)
- `scripts/` (some scripts from this gits scripts folder)
- egnrseTheme.css (in this git)  
- [wlogout](#wlogout) (custom powermenu)
- wayland
- hyprctl (included in hyprland)
- a notification service (eg. [dunst](#dunst))
- rofi-wayland (for the custom wifi-menu, u can also mostly use rofi)
- networkmanager
- blueman-manager (bluetooth gui)
- wireplumber (audio-server, config has to be changed for it to work with ALSA only)
- pwvucontrol<sup>AUR</sup> helvum coppwr(flatpak) (audio-management gui)
Others: jq playerctl  

</details>

### wlogout
*(/wlogout/)*  
A wayland PowerMenu (to logout/shutdown/...). theme-1 is longer (6 items), theme-2 only 4 has options. Both themes have a layout-\* file and a styles-\*.css.  
U can use `/scripts/logoutlaunch.sh` (with args $1 being 1 or 2) to launch those themes. They (should) scale automatically with display size and scaling.  
Needs: egnrseTheme.css hyprland uwsm hyprlock  

### zsh
*(/zsh/)*  
My config is split into multiple parts:  
- custom.zshrc (general settings)
- maps.shrc (custom key mappings)
- completions/\* (custom completion functions)
- ../shell/\* (settings used by all shells)  
- [~/.zshrc (for device specific settings)]

some Features:  
- `Shift+Tab`: fzf search completion
- `jd dir`: jump directory (similar to cd) with [zoxide](https://github.com/ajeetdsouza/zoxide) (remembers folders, so that u can directly go to them)
- `jdi`: interactive jump directory
- press Esc twice to prepend `sudo` to a command

<details><summary>More Info</summary>
add this to your `~/.zshrc` (or similar) to source the files:

```
# fetch the custom config file for zsh (if it exists)
# customZshConfig_path is the path to the config file
customZshConfig_path="$HOME/.config/zsh/custom.zshrc"
if [ -f "$customZshConfig_path" ]; then
	source $customZshConfig_path
else
	echo ".zshrc: path to config not found ($customZshConfig_path)"
fi
```

Change the standart terminal to zsh with:  
`chsh -s /bin/zsh elia` (with `elia` being your username)  
Be sure to have `zsh` installed! (and u are using the correct location)  
</details>

I use `trash-d`<sup>AUR</sup> as a drop in replacement for `rm`.  
Infos about the settings used are in the files.  
Needs: zoxide fzf  


### general Theme
*(egnrseTheme.\*)*  
still a work in progress  
The Idea is to have one file where I can change all colors for all apps/packages I use. Currently, I use 3: egnrseTheme.css/\*.conf/\*.sh . In many configs the colors are still hardcoded. (eg. dunst, tofi, rofi, some waybar modules)  


### Misc
<details><summary>Other things that might be useful (mostly in the other folder).  </summary>

#### onScreen Keyboard
*(/other/wvkbd-laptop\*)*  
Put the binary `wvkbd-laptop` in a directory on the path (eg. `/usr/local/bin/`) to use it system-wide (hyprland/sddm/the desktop-entry expect that)  
Put the desktop-entry `wvkbd-laptop.desktop` in eg. `~/.local/share/applications/` (or follow the instructions in the file).  
Swipe with one finger from the bottom to the left edge (on a touch screen) to toggle the keyboards visibility. (within [hyprland](#hyprland) with the hyprgrass plugin)  

#### xdg-terminal-exec
*(/xdg-terminals.list)*  
Set your standart terminal for `xdg-terminal-exec`<sup>AUR</sup> in the file `xdg-terminals.list` (is not in the xdg standart yet). Also look into [#set Standart Terminal Emulator](set-standart-terminal-emulator).  
Needs: xdg-terminal-exec<sup>AUR</sup>

#### mimeapps.list
*(/mimeapps.list)*  
Set your default applications here (for different filetypes). You can also do this with the KDE-System-Settings or  
an easer way to do this is using a filemanager like `Nemo`:  
`Right Click a file > select *Open With* > *Other Application...* > ` select the application u like and press *Set as default*  
This will also change the mimeapps.list file.  
u can find the mime-type of a file using `xdg-mime query filetype {FILE}`.
Also look into [#set Standart Terminal Emulator](set-standart-terminal-emulator).  
Sadly, some application (eg KDE stuff) breakes the hardlink (between this config and the actual file), so you might have to update the file in `~/.config/mimeapps.list`.  

#### Dolphin
*(/other/servicemenus/\*)*  
Some files in the `other` folder are for Dolphin (KDE). To use them look into the files or look at [Dolphin](#dolphin-filemanager) under [Fixes](#some-fixes--useful-extensions-for-used-packages)  

#### screenshot utility
*(/scripts/screenshot.sh, /other/screenshot.desktop)*  
Desktop entry (called `Snip Screen`) to trigger a screen shot with `grim` and `slurp`.  
TODO: more possible modes?

#### ssd daemon (sshd)
*(/other/50-custom-sshd.conf)*  
A secure'ish sshd config, put the config-file into `/etc/ssh/sshd_config.d/`. You might need to run `ssh-keygen -A` to generate the keys needed for the daemon.
You will need to change the allowed users if you want to connect with a different account than 'elia'. Only connections from localhost (127.0.0.1) and from a localnetwork ip address are allowed. I have a private [zerotier-one](https://www.zerotier.com/) network that I allow connections from too.  
To setup your first connection, disalbe `PasswordAuthentication no` and `AuthenticationMethods publickey` as they only allow signing in with a publickey.  
I used [ssh-audit](https://github.com/jtesta/ssh-audit) to try to make my system more secure.  

#### [ctags](https://github.com/universal-ctags/ctags)
*(none currently)*  
A way to eg. jump to definitions in vim/nvim. Needs an implementation of `ctags` installed to work.  
If u want to use it in a project, run the following in the root project folder:  
```
ctags --extras=+q -R -f .tags .

```
This genereates a `.tags` file, which is used by eg. vim. (-R: index subfolder recursively, +q: index class members)  
(Also look at [its man page](https://man.archlinux.org/man/ctags.1.en))  

#### 'old' folder
*(/other/old/\*)*  
Everything in here is not in active use anymore with no idea if I will need it for sth. later on.  

#### [Nerd-Font](https://www.nerdfonts.com)
*(/other/DejaVuSansMono.zip)*  
The font used by some of the configs in this git.  
Download it or install it over pacman: `ttf-dejavu-nerd`  

</details>

# Appendix

### some fixes / useful extensions (for used packages)

<details> <summary>Expand?</summary>

#### Electron Apps
If apps are blurry (on wayland) it might be using Xwayland, you can fix this by adding the following to the launch-command of the app:  
(the launch command prob. is in `/usr/bin/{APP}`)  
`--enable-features=UseOzonePlatform --ozone-platform=wayland`  

#### set Standart Terminal Emulator
There sadly currently isn't a standardized way of doing that.  
Things that (kinda) work though:  
- Set the environment variable $TERMINAL (eg. in `~/.bashrc` with `TERMINAL=alacritty`)
- Use the mime-type for terminals (u can add them in `~/.config/mimeapps.list`). It is `x-scheme-handler/terminal=Alacritty.desktop`.  
- Use `xdg-terminal-exec`<sup>AUR</sup> to launch terminal applications ([Docs here](https://github.com/Vladimir-csp/xdg-terminal-exec)). Look into the file [xdg-terminals.list](./xdg-terminals.list) for how to configure and more information. ([rust implementation](https://codeberg.org/mkhl/xdg-terminal-exec))  
- For gnome (applications) use the xdg-terminal-exec method AND look at the [Nemo](#nemo-filemanager)  
- For KDE (applications) look at [Dolphin](#dolphin-filemanager).

#### Waterfox
When using the `waterfox-bin` package, I had some organization policies set. You can change them in `/opt/waterfox/distribution/policies.json`.  
To let the `KeepassXC-Browser` Plugin find KeepassXC u can copy the `native-messaging-hosts/` folder from `~/.mozilla` to `~/.waterfox` (given you have firefox installed, and the browser support (for firefox?) in KeepassXC enabled)  
Activate **Hardware video acceleration** on nvidia with `libva-nvidia-driver` (We need the VA-API). Test if it worked with 'vainfo' from `libva-utils` (see [Wiki](https://wiki.archlinux.org/title/Hardware_video_acceleration#Verification)). Set in `about:config` in waterfox `media.ffmpeg.vaapi.enabled` to `true` (see [here](https://wiki.archlinux.org/title/Firefox#Hardware_video_acceleration)).  
Disable `Ctr+Q` for close: `about:config` > `browser.quitShortcut.disabled`= `true`  

#### [Thorium](https://thorium.rocks/)
thorium-browser-bin<sup>AUR</sup>
To active native wayland use `--ozone-platform-hint=auto` as a startup flag or set `Preferred Ozone platform` to auto within the `chrome://flags/` menu (put the previous thing into the URL field of thorioum).  


#### Dolphin (filemanager)
Set the standart terminal for dolphin in `~/.config/kdeglobals` with:
```
[General]
TerminalApplication=alacritty
TerminalService=Alacritty.desktop
```
First row the command, second row the desktop-entry.  

To build/update the KDE **desktop-entry cache** (that Dolphin needs to find programs):
- have the `archlinux-xdg-menu` package installed
- run: `XDG_MENU_PREFIX=arch- kbuildsycoca6 --noincremental`
(kbuildsycoca6 is part of the kservice package, which is a dependency of dolphin)  

This fixes dolphin not finding programs. **This function is in the rightclick menu of dolphin** (if u put the files from `/other/servicemenus` in the correct place).  
There is also a pacman-hook (`/other/updateKDEcache.hook`) to speed up this process.  

**Extensions**
- `kio-admin` (sudo for dolphin)  
- `ark` (zip/tar support)  
- `dolphin-plugins` (git/mercurial/dropbox support, needs to be activated within the *Context Menu* Settings)  

(see more in the [AchWiki Article](https://wiki.archlinux.org/title/Dolphin))

To launch Dolphin (from the terminal) in the current directory use: `dolphin .`


#### Nemo (filemanager)
change the standart terminal to alacritty:  
`gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty`  
fix running shell-scripts with alacritty (needs the option -e):  
`gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg e`  
more in the [ArchWiki-Nemo](https://wiki.archlinux.org/title/Nemo)  


#### Pacman / Steam
In `/etc/pacman.conf` I enable `ParallelDownloads = 5` and the `multilib` library (multilib is required for the `steam` package).  
Other nice options: Color
(just remove the `#` before the lines)  
I used `rankmirrors` to rank the mirrors I chose in `/etc/pacman.d/mirrorlist`.

#### VLC Media Player
If the environment variable $DISPLAY is set, VLC will use X11 to display itself. (Because it is a bit buggy)  
To force VLC to use wayland, you can change the line with `Exec=` in `/usr/share/applications/vlc.desktop` to:  
`Exec=env -u DISPLAY /usr/bin/vlc --started-from-file %U`  
This will preserve the environment variable globally while unsetting it for VLC.  

#### Flatpak
Install software from flathub with `discover` (kde software), manage flatpak permissions graphically with Flatseal(flatpak).  
Bellow some maybe useful flatpak commands:  
```
flatpak list
flatpak run APP-ID
flatpak run --command=COMMAND APP-ID ARGS
flatpak install NAME

```

#### Sunshine
The Flatpak doesn't have the right permission.  
Follow the Arch Linux install in: `https://docs.lizardbyte.dev/projects/sunshine/latest/about/setup.html`  
Then do: `sudo setcap -r $(readlink -f $(which sunshine))`  
Install all dependencies that sunshine needs. Symlink all libs that have the wrong version to the installed one. (in `/usr/lib`: sudo ln -s ./lib\*.so ./lib\*.so.1.83.0)

#### [Mailvelope](https://github.com/mailvelope/mailvelope) (browser extension)
Connect to the local `gpgme` install:  
- create one of the following files ([see also here](https://github.com/mailvelope/mailvelope/wiki/Creating-the-app-manifest-file-on-macOS-and-Linux)):

```
~/.mozilla/native-messaging-hosts/gpgmejson.json
~/.waterfox/native-messaging-hosts/gpgmejson.json
~/.config/google-chrome/NativeMessagingHosts/gpgmejson.json

```
with the following content (for firefox based):
```
{
    "name": "gpgmejson",
    "description": "JavaScript binding for GnuPG",
    "path": "/usr/bin/gpgme-json",
    "type": "stdio",
    "allowed_extensions": ["jid1-AQqSMBYb0a8ADg@jetpack"]
}
```
- reload the mailvelope extension
- select under `Options > General > OpenPGP Preferences` GnuPG 
- now you should see your keys under `Key Management` (if you select `GnuPG` and not `Main Keyring`)


#### xdg-desktop-portal
Set you prefered portal in `/usr/share/xdg-desktop-portal/DESKTOP-portals.conf`, where `DESKTOP` is the name of the used compositor. (eg. `hyprland-portals.conf`)  
You can set multiple ones. The first (listed) portal which implements an interface is used for that interface. The file should look like:
```
[preferred]
default=hyprland;gtk;kde
```
You can see all installed portals in `/usr/share/xdg-desktop-portal/portals`. [more in the ArchWiki](https://wiki.archlinux.org/title/XDG_Desktop_Portal)  
[Hyprland issue](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/252)

#### Matlab (deprecated)
Look into the file [/other/matlabStart.sh](./other/matlabStart.sh) and look into [ArchWiki-Matlab](https://wiki.archlinux.org/title/MATLAB).  
I used the installer for linux from: [mathworks-download](https://de.mathworks.com/downloads/).


</details>

---

### cool/useful Packages
zerotier-one  
joplin-desktop<sup>AUR</sup>  
beeper-latest-bin<sup>AUR</sup>  
[coppwr](https://dimtpap.ovh/coppwr) (flathub)  
[sonusmix<sup>AUR</sup>](https://codeberg.org/sonusmix/sonusmix)  
[xdg-terminal-exec-mkhl<sup>AUR</sup>](https://codeberg.org/mkhl/xdg-terminal-exec) (feels slower than xdg-terminal-exec though)  
[ssh-audit](https://github.com/jtesta/ssh-audit)  

---
	
### Packages
<details> <summary>Some of the packages I use:</summary>

#### basics
base-devel neovim vim git sudo grub openssh efibootmgr  
man-db man-pages						(man pages)  
ntfs-3g exfat-utils 					(filesystem types)  
networkmanager blueman waypipe	    (internet/networking/bluetooth)  
flatpak wget pacman-contrib devtools yay<sup>AUR</sup>		(package managing)  
pipewire pipewire-docs wireplumber wireplumber-docs helvum pwvucontrol<sup>AUR</sup> (audio)  
waybar dunst rofi-wayland nwg-drawer hypridle hyprlock wlogout<sup>AUR</sup> tofi<sup>AUR</sup> (statusbar, notifications, app-launcher, lock screen)  
polkit-kde-agent wl-clipboard trash-d<sup>AUR</sup> zsh zoxide fzf (utilities)  
firefox alacritty konsole dolphin  
ttf-dejavu-nerd fastfetch rclone zerotier-one  

#### window manager
plasma-meta hyprland sddm (kde, tiling WM, login)  
wayland-protocols wayland-utils uwsm<sup>AUR</sup> (managing wayland-WM)  
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk (set them in /usr/share/xdg-desktop-portal/hyprland-portals.conf)  

#### misc
bash-language-server ctags (lsp)  
kio-admin ark dolphin-plugins archlinux-xdg-menu kdegraphics-thumbnailers libappimage (dolphin stuff)  
hunspell-en_US speech-dispatcher (waterfox)  
unzip zip  
libreoffice-fresh prismlauncher appimagelauncher nheko mission-center kdeconnect  
strawberry vlc kalgebra kcalc godot-mono blender cuda  
syncthing
#### from AUR
xdg-terminal-exec ttf-ms-win10-auto hyprswitch ianny v-editor-git (default terminal, win fonts)   
spotify vesktop beeper-latest-bin anki-bin (discord client, msg client)   
waterfox-bin thorium-browser-bin  pa-notify (browser, notification on loudness change)   
syncthingtray
#### from Flatpak
(replace '\_' with spaces)  
keepassXC joplin bottles OBS_Studio moonlight coppwr tor_browser_launcher flatseal gimp  
#### from somewhere else
sunshine matlab  

</details>

---

### other useful (git) commands:
`git config core.sparseCheckout true` : can also add single files to the sparsity list (not only directories)  
`git config --global core.editor "nvim"`  
`git config status.showUntrackedFiles no`  
`git sparse-checkout list`  
`git read-tree -mu HEAD` : reload current files from tree
`git remote set-url origin github.com:egnrse/configs.git` : setup your `~/.ssh/config` for github first  
`git reset --hard origin/main` : reset current branch to origin/main (will discard all local changes)

use `~/.ssh/config`  
`ssh -T github` : test github connection  

#### [gpg and git](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work):
create/show gpg keypair, print public key, add key to git:  
```
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long
gpg --armor --export <id>
git config --global user.signingkey <id>
```
to unlock pw-protected keys this must exist: `export GPG_TTY=$(tty)`  
`git commit -S` : commit a signed commit  
`git config --local commit.gpgsign true` : activate automatical signing of commits   
`git log --show-signature -1` : show signiture of the last commit  
`git tag -s v1.5 -m 'my signed 1.5 tag'` : sign a tag (did not try)  

<details> <summary>
	
### old setup method (git ~/.config)
</summary>
I used to use sparse-checkout and exlude to only get specific files with git. Except for files in the `other` folder all files should be at the right place after cloning this repo. 

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

</details>

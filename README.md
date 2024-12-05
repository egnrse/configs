# some of my configs
THIS IS STILL DEVELOPING!  

In this repo are only configs not their programs, those u must already have installed.  

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
- alacritty: (/alacritty/)  
- hyprland: (/hypr/)  
- partially bash:  (.bash_aliases)  
- general Theme: (egnrseTheme.css)
- git:    (/other/.gitconfig)
- Nerd-Font: (/other/DejaVuSansMono.zip)

wanting to add:
- waybar
- rofi
- wofi
- wlogout

### vim
*(/other/.vimrc) (Win10/Linux)*  
Copy the file to `~/`, some infos are in the file. I use Plug as a Plugin Manager, it should autoinstall itself. Should work on Win10 and Linux.  

### nvim
*(/nvim/) (Win10/Linux)*    
Some explanations of the settings are in the files. The setup Leader-Key is Space. (some shortcuts start with the Space-Key)  
- Main setup in `init.lua`  
- Custom keymapings in `./lua/maps.lua`  
- Lazy Plugin Manager in `./lua/config/lazy.lua` (just works)  
  Settings for the plugins are in their files (`./lua/plugins/*`)  
  - bufferline (top bar with *file* tabs)
  - cmp (autocompletion)
  - colorscheme
  - lualine (status line)
  - nvim-autopairs (autocomplete brackes and more)
  - nvim-tree (file explorer) {Leader+E}
  - other (misc plugins)

### alacritty
*(/alacritty/) (Linux)*  
in win10 add: (does not work yet)  
```
[general]
import = ["../../Local/alacritty/alacritty.toml"]
```
to `%APPDATA%\alacritty\alacritty.toml`  

### hyprland
*(/hypr/) (Linux)*  
might not (fully) work without some other (not yet here) stuff (eg. wofi, waybar, someScripts, dunst, nautilus)  
`SUPER+M` : close/exit/logout  
`SUPER+Q` : terminal (alacritty)  
`SUPER+R` : start a program (wofi)  

### bash
*(.bash_aliases) (Linux)*  
add this to your `~/.bashrc` (or similar):  
```
if [ -f ~/.config/.bash_aliases ]; then
 	. ~/.config/.bash_aliases
fi
```
Some info in the file.

### general Theme
*(egnrseTheme.css) (Linux)*  
still a work in progress

### git
*(/other/.gitconfig)*  
copy the file to `~/.gitconfig`. It has some usefull aliases  

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

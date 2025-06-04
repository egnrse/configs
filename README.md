# The base of my configs
Meant for a simple install in a shell environment (eg. for ssh usage).

Get it with the steps bellow:
```sh
git clone --single-branch --branch base https://github.com/egnrse/configs
cd config
./baseInstall.sh
```

THIS IS STILL DEVELOPING and always will! PR/issues are very welcome.  

## set up some config syncing
*(If u fork this first, u can sync and save your own configs)*  

## Synced configs:
<details>
  <summary>Overview</summary>

- [bash](#bash):      (/bash/)
- [git](#git):    (/other/.git\*)
- [neovim](#nvim): (/nvim/)  
- [vim](#vim):    (/other/.vimrc)  
- [zsh](#zsh): (/zsh/)

{program name}: ({path in this git})

- [Appendix](#appendix)

</details>

### bash
*(/bash/)*  
My config is split into two/three parts:  
- custom.bashrc (general settings)  
- aliases.bashrc (aliases for commands)  
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

### git
*(/other/.gitconfig, /other/.gitignore_global)*  
Copy the parts of `.gitconfig` that u like into `~/.gitconfig`. It has some useful aliases.  
Replace the placeholders if needed (eg. {email}, {computerName}).  
(fully replacing your old config-file is **not** recommended)  

There is also a global `.gitignore` with explanations how to use/activate in the file.  

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

### zsh
*(/zsh/)*  
My config is split into two/three parts:  
- custom.zshrc (general settings)
- aliases.shrc (aliases for commands)
- [~/.zshrc (for device specific settings)]

some Features:  
- `Shift+Tab`: fzf search completion
- `jd dir`: jump directory (similar to cd) with [zoxide](https://github.com/ajeetdsouza/zoxide) (remembers folders, so that u can directly go to them)
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


### Misc
#### [ctags](https://github.com/universal-ctags/ctags)
*(none currently)*  
A way to eg. jump to definitions in vim/nvim. Needs an implementation of `ctags` installed to work.  
If u want to use it in a project, run the following in the root project folder:  
```
ctags --extras=+q -R -f .tags .

```
This genereates a `.tags` file, which is used by eg. vim. (-R: index subfolder recursively, +q: index class members)  
(Also look at [its man page](https://man.archlinux.org/man/ctags.1.en))  


# Appendix

### cool/useful Packages
zerotier-one  
joplin-desktop<sup>AUR</sup>  
beeper-latest-bin<sup>AUR</sup>  
[coppwr](https://dimtpap.ovh/coppwr) (flathub)  
[sonusmix<sup>AUR</sup>](https://codeberg.org/sonusmix/sonusmix)  
[xdg-terminal-exec-mkhl<sup>AUR</sup>](https://codeberg.org/mkhl/xdg-terminal-exec) (feels slower than xdg-terminal-exec though)  
[ssh-audit](https://github.com/jtesta/ssh-audit)  

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


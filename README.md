## set up nvim
unix: ~/.config  
win:  C:\Users\\\<USERNAME>\AppData\Local
```
git init
git remote add origin https://github.com/egnrse/configs
git config core.sparseCheckoutCone true
git sparse-checkout set nvim
git pull origin main
git branch --set-upstream-to=origin/main main
```


#### .git/info/exlude:
all files and folders, except /nvim/
```
*
/*/
!/nvim/
```
### other useful (git) commands:
`git config core.core.sparseCheckoutCone true` : can also add single files to the sparsity (not only directories)  
`git config --global core.editor "nvim"`  
`git config status.showUntrackedFiles no`  
`git sparse-checkout list` 

`git remote set-url origin git@github.com:egnrse/configs` : needs *.git maybe  

### ssh
use 'ssh-add ~/path/to/key' or ~/.ssh/config  
`ssh -T git@github.com` : test github connection  

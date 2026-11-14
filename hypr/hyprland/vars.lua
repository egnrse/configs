
---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local vars = {}

-- Modifiers
vars.mainMod = "SUPER"
vars.logPath = os.getenv("HOME") .. "/.config" -- path for log files

-- Set programs that you use
--local terminal = alacritty
vars.terminalClean = "alacritty"
vars.terminal = "uwsm app -- " .. vars.terminalClean
vars.fileManager = "uwsm app -- dolphin"             -- alternative: nautilus -w
vars.menu = "tofi-drun"                              -- app launcher
vars.menuClose = "pkill tofi"                        -- close app launcher
vars.drawer = "nwg-drawer"
vars.drawerClose = 'test -n "$(hyprctl layers | grep nwg-drawer)" && nwg-drawer -close'

vars.powerMenu = os.getenv("HOME") .. "/.local/share/bin/scripts/logoutlaunch.sh 2" -- 2: theme; 1: another theme
vars.sysMonitor = "xdg-terminal-exec btm"            -- monitor system resources
vars.onScreenKeyboard = "uwsm app -- wvkbd-laptop"
vars.onScreenKeyboardClose = "pkill wvkbd"

-- GUI window switcher
vars.windowSwitchRun = "hyprswitch gui --mod-key " .. vars.mainMod .. " --key TAB --max-switch-offset 0 --include-special-workspaces --switch-type workspace"

return vars

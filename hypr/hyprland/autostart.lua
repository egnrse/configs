
-------------------
---- AUTOSTART ----
-------------------



local vars = require("hyprland.vars")
local logPath = vars.logPath

hl.on("hyprland.start", function ()
	-- uwsm can take the environment-variables from hypr now
	hl.exec_cmd("uwsm finalize GBM_BACKEND __GLX_VENDOR_LIBRARY_NAME __GL_GSYNC_ALLOWED __GL_VRR_ALLOWED")
	-- Notification daemon
	--hl.exec_cmd("uwsm app -- dunst >> " .. logPath .. "/dunst/dunst.log 2>&1")
	hl.exec_cmd("uwsm app -- dunst >> ~/.config/dunst/dunst.log 2>&1")

	-- Authentication Manager
	hl.exec_cmd("uwsm app -- /usr/lib/polkit-kde-authentication-agent-1")

	-- Statusbar
	hl.exec_cmd("waybar >> " .. logPath .. "/waybar/waybar.log 2>&1")

	-- Audio volume notifications
	hl.exec_cmd("uwsm app -- pa-notify")

	-- Blue light filter
	hl.exec_cmd("uwsm app -- hyprsunset")

	-- GUI Window Switcher daemon
	hl.exec_cmd(vars.windowSwitchInit)

	-- Background instance of nwg-drawer
	hl.exec_cmd("uwsm app -- nwg-drawer -r -c 8 -spacing 10 -fm dolphin -term " .. vars.terminalClean .. " -wm 'hyprland' -nofs >> " .. logPath .. "/nwg-drawer/nwg-drawer.log 2>&1")

	-- Syncthing Tray
	hl.exec_cmd("uwsm app -- syncthingtray-qt6 --wait >> " .. logPath .. "/log/syncthingtray.log 2>&1")

	-- KDEConnect Indicator
	hl.exec_cmd("uwsm app -- kdeconnect-indicator >> " .. logPath .. "/kdeconnect/kdeconnect.log 2>&1")

	-- Start session with an open terminal on Workspace 1
	hl.dsp.focus({ workspace = 1 })
	hl.exec_cmd(vars.terminal)
end)

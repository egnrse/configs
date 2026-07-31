-- The workspace/window/layers rules for this hyprland config.

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- some workspace filters:
-- w[tv1]	: one tiled visible window
-- w[tg1]	: one tiled group
-- f[1]		: maximized
-- f[0]		: fullscreen

-- customized version of "Smart gaps" / "No gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "w[tg1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[t1]" }, border_size = 0 })	--borderless if only 1 tiling window
hl.window_rule({ match = { workspace = "w[tg1]" }, border_size = 0 })	-- borderless if only 1 tiling group
hl.window_rule({ match = { workspace = "f[1]" }, rounding = 0, border_size = 0 })		--  borderless/no rounding if maximized


hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
	name = "fix-small-initial-sizes",
	match = { class = ".*", float = true },
	size = { ">100", ">5%" },
})


---------------------
---- LAYER RULES ----
---------------------

hl.layer_rule({
    name = "blur-all-layers",
    match = { namespace = ".*" },
    blur = true,
})


----------------------------------------
---- CUSTOMIZE APP / LAYER BEHAVIOR ----
----------------------------------------
-- window/layer rules that are for specific apps/layers


-- ====== Steam (for "steam_proton" windows look below) ======
hl.window_rule({
	-- everything, but the main window floats
    name = "steam-float-popups",
    match = { class = "steam", title = "(Steam%b)?(.+)" },
    float = true,
})
hl.window_rule({
    name = "steam-tile-main",
    match = { class = "steam", title = "Steam" },
    tile = true,
})
hl.window_rule({
    name = "steam-initial-update",
    match = { class = "^$", title = "^Steam$" },
    center = true,
    size = { 400, 129 },
})
hl.window_rule({
    name = "steam-notifications",
    match = { class = "steam", title = "notification.*", float = true },
    size = { ">20%", ">20%" },
})
hl.window_rule({
    name = "steam-popups-center",
    match = { class = "^steam.*$", title = "negative:^(notification.*).*$|^$", float = true },
    center = true,
    size = { ">20%", ">20%" },
})
hl.window_rule({
    name = "steam-app-launcher",
    match = { class = "^steam_app_.*$" },
    center = true,
    size = { ">50%", ">50%" },
})

-- Warframe (Steam)
hl.window_rule({
    name = "warframe",
    match = { class = "^steam_app_.*$", title = "^Warframe$" },
    immediate = true,
    center = true,
    size = { 1050, 645 },
})

-- Soulframe (Steam)
hl.window_rule({
    name = "soulframe",
    match = { class = "steam_app_0", title = "Soulframe" },
    immediate = true,
    min_size = { 1030, 640 },
    max_size = { 1030, 640 },
    center = true,
})

-- ====== Steam Proton / Bottles ======

hl.window_rule({
    name = "steam-proton-no-max-size",
    match = { class = "^steam_proton$", xwayland = true },
    no_max_size = true,
})
hl.window_rule({
    name = "steam-proton-file-picker",
    match = { class = "^steam_proton$", title = "(Save Live Set As|Save|Open|Add Folder|Select .*folder).*", xwayland = true },
    size = { 980, 550 },
})

-- ableton live 11 (running in bottles over steam_proton)
hl.window_rule({
    name = "ableton-live-main",
    match = { class = "^steam_proton$", title = ".* - Ableton Live 11 Suite", xwayland = true },
    tile = true,
})
hl.window_rule({
    name = "ableton-live-menus",
    match = { class = "^steam_proton$", title = "^$", xwayland = true },
    move = "onscreen cursor -10 0",
})
hl.window_rule({
    name = "ableton-live-export-popup",
    match = { class = "^steam_proton$", title = "Export Audio%b%b%b" },
    max_size = { 436, 136 },
})

-- VST Plugins
hl.window_rule({
    name = "vst-vital",
    match = { class = "^steam_proton$", title = "Vital.*", xwayland = true },
    size = { 1500, 900 },
})
hl.window_rule({
    name = "vst-span",
    match = { class = "^steam_proton$", title = "SPAN.*", xwayland = true },
    size = { 852, 565 },
})
hl.window_rule({
    name = "vst-phase-plant",
    match = { class = "^steam_proton$", title = "Phase Plant.*", xwayland = true },
    size = { 1265, 786 },
})
hl.window_rule({
    name = "vst-fabfilter-pro-q3",
    match = { class = "^steam_proton$", title = "FabFilter Pro-Q 3.*", xwayland = true },
    size = { 907, 565 },
})
hl.window_rule({
    name = "vst-fabfilter-pro-r",
    match = { class = "^steam_proton$", title = "FabFilter Pro-R.*", xwayland = true },
    size = { 860, 625 },
})
hl.window_rule({
    name = "vst-fabfilter-saturn",
    match = { class = "^steam_proton$", title = "FabFilter Saturn.*", xwayland = true },
    size = { 726, 392 },
})
hl.window_rule({
    name = "vst-fabfilter-pro-l2",
    match = { class = "^steam_proton$", title = "FabFilter Pro-L 2.*", xwayland = true },
    size = { 960, 600 },
})
hl.window_rule({
    name = "vst-fabfilter-pro-c2",
    match = { class = "^steam_proton$", title = "FabFilter Pro-C 2.*", xwayland = true },
    size = { 748, 475 },
})
hl.window_rule({
    name = "vst-fabfilter-pro-mb",
    match = { class = "^steam_proton$", title = "FabFilter Pro-MB.*", xwayland = true },
    size = { 905, 605 },
})
hl.window_rule({
    name = "vst-fabfilter-pro-ds",
    match = { class = "^steam_proton$", title = "FabFilter Pro-DS.*", xwayland = true },
    size = { 645, 445 },
})
hl.window_rule({
    name = "vst-fabfilter-pro-g",
    match = { class = "^steam_proton$", title = "FabFilter Pro-G.*", xwayland = true },
    size = { 625, 345 },
})
hl.window_rule({
    name = "vst-bbc-so",
    match = { class = "^steam_proton$", title = "BBC Symphony Orchestra.*", xwayland = true },
    size = { 1000, 1250 },
})
hl.window_rule({
    name = "vst-keyzone-classic",
    match = { class = "^steam_proton$", title = "Keyzone Classic.*", xwayland = true },
    size = { 885, 420 },
})
hl.window_rule({
    name = "vst-freeclip",
    match = { class = "^steam_proton$", title = "FreeClip.*", xwayland = true },
    size = { 505, 525 },
})
hl.window_rule({
    name = "vst-multiply",
    match = { class = "^steam_proton$", title = "Multiply.*", xwayland = true },
    size = { 725, 465 },
})
hl.window_rule({
    name = "vst-la-petite-excite",
    match = { class = "^steam_proton$", title = "La Petite Excite.*", xwayland = true },
    size = { 625, 250 },
})
hl.window_rule({
    name = "vst-gsnap",
    match = { class = "^steam_proton$", title = "GSnap.*", xwayland = true },
    size = { 555, 450 },
})
hl.window_rule({
    name = "vst-bl-denoiser",
    match = { class = "^steam_proton$", title = "BL-Denoiser.*", xwayland = true },
    size = { 500, 490 },
})
hl.window_rule({
    name = "vst-goyo",
    match = { class = "^steam_proton$", title = "Goyo.*", xwayland = true },
    size = { 700, 425 },
})
hl.window_rule({
    name = "vst-izotope-vinyl",
    match = { class = "^steam_proton$", title = "iZotope Vinyl.*", xwayland = true },
    size = { 530, 380 },
})

-- ====== Wine ======

hl.window_rule({
    name = "winecfg",
    match = { class = "winecfg.exe", title = "Wine configuration" },
    size = { 410, 450 },
    center = true,
})
hl.window_rule({
    name = "explorer-properties",
    match = { class = "explorer.exe", title = "Properties for .*" },
    size = { 390, 430 },
    center = true,
})
hl.window_rule({
    name = "explorer-desktop",
    match = { class = "explorer.exe", title = "Desktop" },
    size = { ">700", ">400" },
    center = true,
})

-- ====== Music ======

-- Audacity
hl.window_rule({
    name = "audacity-popups-center",
    match = { class = "^Audacity$", title = "negative:^audacity$" },
    center = true,
})
hl.window_rule({
    name = "audacity-general-popups",
    match = { class = "^Audacity$", title = "negative:(^Save changes to .*|^audacity|^Audacity is starting up...$)" },
    size = { ">20%", ">20%" },
})
hl.window_rule({
    name = "audacity-save-changes",
    match = { class = "^Audacity$", title = "^Save changes to .*" },
    size = { 244, 102 },
})
hl.window_rule({
    name = "audacity-startup",
    match = { class = "^Audacity$", title = "^Audacity is starting up%b%b%b$" },
    size = { 550, 190 },
})
hl.window_rule({
    name = "audacity-crash-recovery",
    match = { class = "^Audacity$", title = "^Automatic Crash Recovery$" },
    size = { 510, 360 },
})
hl.window_rule({
    name = "audacity-export-audio",
    match = { class = "^Audacity$", title = "^Export Audio$" },
    size = { 538, 538 },
})
hl.window_rule({
    name = "audacity-edit-metadata",
    match = { class = "^Audacity$", title = "^Edit Metadata Tags$" },
    size = { 499, 453 },
})
hl.window_rule({
    name = "audacity-compressor",
    match = { class = "^Audacity$", title = "^Compressor - .*" },
    size = { 670, 661 },
})
hl.window_rule({
    name = "audacity-limiter",
    match = { class = "^Audacity$", title = "^Limiter - .*" },
    size = { 670, 589 },
})

-- ====== Documents ======

-- LibreOffice Loading Bar
hl.window_rule({
    name = "libreoffice-loading",
    match = { class = "^$", title = "^LibreOffice$", xwayland = true },
    center = true,
    size = { 600, 200 },
})

-- ====== Games ======

-- Minecraft (prism-launcher)
hl.window_rule({
    name = "minecraft",
    match = { class = "^Minecraft.*", title = "^Minecraft.*" },
    tile = true,
    size = { ">20%", ">20%" },
})

-- ====== Media ======

-- ffplay
hl.window_rule({
    name = "ffplay-default",
    match = { class = "ffplay" },
    center = true,
    tile = true,
})

-- Krita
hl.window_rule({
    name = "krita-main-window",
    match = { class = "^krita$", title = "^.* — Krita$" },
    size = { 624, 552 },
    center = true,
})
hl.window_rule({
    name = "krita-about",
    match = { class = "^krita$", title = "^About Krita$" },
    size = { 614, 651 },
    center = true,
})

-- Godot
hl.window_rule({
    name = "godot-debug-window",
    match = { class = "^org%.godotengine%.Editor$", title = "^.* %bDEBUG%b$" },
    float = true,
})
hl.window_rule({
	-- running game window
    name = "godot-game-window",
    match = { class = "negative:^org%.godotengine%.Editor$", initial_title = "^Godot$" },
    center = true,
    size = { ">50%", ">50%" },
})


-- ====== OTHER ======

-- Firefox/Waterfox/Zen Picture-in-Picture
hl.window_rule({
    name = "browser-pip",
    match = { class = "^(firefox|waterfox.*|zen)$", title = "^Picture-in-Picture$" },
    float = true,
})

-- Audio control
hl.window_rule({
    name = "audio-mixers",
    match = { class = "^(org%.pulseaudio%.pavucontrol|com%.saivert%.pwvucontrol)$" },
    float = true,
})

-- Bluetooth
hl.window_rule({
    name = "blueman-manager",
    match = { class = "^blueman-manager$" },
    float = true,
})

-- Vesktop/Discord Popout
hl.window_rule({
    name = "discord-popout",
    match = { class = "^vesktop$", initial_title = "^Discord Popout$" },
    float = true,
})

-- MATLAB
hl.window_rule({
    name = "matlab-main",
    match = { class = "^MATLAB R%d%d%d%d%a - .*", title = "^MATLAB R%d%d%d%d%a - .*" },
    tile = true,
})

-- Questa Sim
hl.window_rule({
    name = "questasim-restart",
    match = { class = "MtiDialog", title = "Restart" },
    center = true,
    size = { 210, 254 },
})
hl.window_rule({
    name = "questasim-save-format",
    match = { class = "Toplevel", title = "Save Format" },
    center = true,
    size = { 474, 168 },
})
hl.window_rule({
    name = "questasim-tcl-error",
    match = { class = "Dialog", title = "Error in Tcl Script" },
    center = true,
    size = { 500, 180 },
})
hl.window_rule({
    name = "questasim-quit",
    match = { class = "Dialog", title = "Quit Vsim" },
    center = true,
    size = { 257, 93 },
})
hl.window_rule({
    name = "questasim-blank-dialog",
    match = { class = "Dialog", title = "^ $" },
    center = true,
    size = { 300, 115 },
})

-- ===== CUSTOM GUIs ======

-- Uni
hl.window_rule({
    name = "uni-remote-place-assigner",
    match = { class = "Tk", title = "Remote Place Assigner" },
    size = { ">590", ">250" },
    center = true,
})
hl.window_rule({
    name = "uni-ffplay-ppm",
    match = { class = "ffplay", title = "(out%.ppm|.*%d%d%.ppm)", xwayland = true },
    tile = true,
    size = { ">20%", ">20%" },
})
hl.window_rule({
    name = "uni-ffplay-rtsp",
    match = { class = "ffplay", title = "Stream - rtsp://.*", xwayland = true },
    tile = true,
    size = { ">20%", ">20%" },
})



------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- laptop monitor
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "1.2"
})
-- pc main monitor
hl.monitor({
	output = "DP-1",
	mode = "3840x2160@120",
	position = "auto",
	scale = "1.67"
})
-- pc monitor 2
hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "-1920x190",
	scale = "1"
})
-- archFrame monitor
hl.monitor({
	output = "desc: BOE 0x0BC",
	mode = "preferred",
	position = "auto",
	scale = "1.3333"
})
-- all other monitor do automatically
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1"
})


---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "intl",
		kb_model = "",
		-- map capslock to escape
		kb_options = "caps:escape",
		kb_rules = "",
		numlock_by_default = true,

		sensitivity = 0, 			-- -1.0 - 1.0, 0 means no modification.
		accel_profile = "adaptive",	-- adaptive/flat/custom

		scroll_method = "2fg",		-- "2fg" (2 fingers)/"edge"/"on_button_down"/"no_scroll"

		follow_mouse = 1,			-- (window) focus follows the mouse
		off_window_axis_events = 2, -- what to do with events around gaps/border/dragarea
		-- 0: ignores events, 1: out-of-bound coordinates, 2: fakes closest inside coordinates, 3: warps the cursor to the closest point inside the window

		touchpad = {
			disable_while_typing = true,
			natural_scroll = true,
			tap_to_click = true,		-- tapping with 1/2/3 fingers will send LMB/RMB/MMB
		},
		touchdevice = {
			-- DISABLES TOUCH DEVICES
			enabled = false,
		},
	},
	cursor = {
		no_hardware_cursors = 2,
		inactive_timeout = 0,		-- in seconds, after how many seconds of cursor’s inactivity to hide it. Set to 0 for never. (float)
		persistent_warps = true,	-- when a window is refocused, the cursor returns to its last position relative to that window, rather than to the centre.
		zoom_factor = 1.0,			-- magnifying glass. Minimum 1.0 (meaning no zoom)
		hide_on_key_press = false,
		hide_on_touch = true,
		hide_on_tablet = false,
		warp_back_after_non_mouse_input = false,	-- warp the cursor back to where it was after using a non-mouse input to move it, and then returning back to mouse.
	},
})

-- per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
-- get device names with `hyprctl devices`
hl.device({
    name = "logitech-gaming-mouse-g402",
    sensitivity = -0.33
})



-----------------
---- GENERAL ----
-----------------

hl.config({ ecosystem = {	no_donation_nag = true } })

hl.config({
	misc = {
		disable_hyprland_logo = false,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		vrr = 2,		-- variable refresh rate/adaptive sync (0: off, 1: on, 2: fullscreen only)

		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,

		disable_autoreload = false,
		focus_on_activate = false,
		allow_session_lock_restore = false,	-- if true, will allow you to restart a lockscreen app in case it crashes

		session_lock_xray = false,
		session_lock_blur = false,
		close_special_on_empty = true,
		on_focus_under_fullscreen = 1,	-- 0: behind, 1: takes over, 2:unfullscreen
		initial_workspace_tracking = 0, -- 0: disabled, 1: single-shot, 2: persistent (all children too)
		initial_workspace_token_timeout = 10,
		middle_click_paste = false,
		render_unfocused_fps = 15,
		disable_xdg_env_checks = false,
		lockdead_screen_delay = 1000,
		enable_anr_dialog = true,		-- app not responding
		anr_missed_pings = 5,
		size_limits_tiled = false,
		disable_watchdog_warning = false,
		--float_force_onscreen = 1,		-- constrains for new floating windows; 0: no constraints, 1: must be partially onscreen, 2: must be fully onscreen	--dev
	},
	binds = {
		workspace_back_and_forth = false,
		workspace_center_on = 0,		-- Whether switching workspaces should center the cursor on the workspace (0) or on the last active window for that workspace (1)
		focus_preferred_method = 0,		--  0: history (recent have priority), 1: length (longer shared edges have priority)
		window_direction_monitor_fallback = true,
		allow_pin_fullscreen = true,
	},
	xwayland = {
		enabled = true,					-- allow running applications using X11
		use_nearest_neighbor = false,	-- pixelated rather than blurry
		force_zero_scaling = false,
	},
	opengl = { nvidia_anti_flicker = true },
	render = {
		direct_scanout = 0,				-- 0: off, 1: on, 2: auto
		ctm_animation = 2,				-- enable a fade animation for CTM changes (hyprsunset)
		new_render_scheduling = false,	-- can improve performance on true
	},
})



-----------------------
----- PERMISSIONS -----
-----------------------
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
hl.config({ ecosystem = { enforce_permissions = true } })
hl.permission({	binary = "*", type = "screencopy", mode = "ask" })
hl.permission({	binary = "*", type = "plugin", mode = "ask" })
--hl.permission({	binary = "*", type = "keyboard", mode = "ask" })
--hl.permission({	binary = "*", type = "cursorpos", mode = "ask" })
--hl.permission({	binary = "*", type = "input-capture", mode = "ask" })
hl.permission({	binary = "/usr/bin/hyprlock", type = "screencopy", mode = "allow" })



-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- nvidia
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")
-- xcursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-- The keybindings part of this hyprland config.
--
-- == IDEA ==
-- $mainMod (SUPER) is for general window management
-- ALT is for group/workspace mappings
-- Space as a mouse replacement for hyprland stuff (+ALT for the right-button)



---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local vars = require("hyprland.vars")
local mainMod = vars.mainMod

-- ========== GENERAL ==========
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(vars.terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(vars.menuClose .. " || " .. vars.menu)) -- close $menu if it is open, else open it
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(vars.drawer))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(vars.drawer))

hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd(vars.windowSwitchRun))

hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(vars.sysMonitor))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd(vars.powerMenu))
hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Close all open layer surfaces on SUPER release
hl.bind("SUPER + SUPER_L", function()
    hl.dispatch(hl.dsp.exec_cmd(vars.menuClose))
    hl.dispatch(hl.dsp.exec_cmd(vars.drawerClose))
    hl.dispatch(hl.dsp.exec_cmd("pkill wlogout"))
    hl.dispatch(hl.dsp.exec_cmd("pkill rofi"))
    hl.dispatch(hl.dsp.exec_cmd("hyprswitch close"))	-- does not work
end, { release = true })


-- ========== FOCUS ==========
-- Switch focus and bring window to top
-- (also works in floating or maximized workspaces)
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next({}))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

hl.bind("ALT + SHIFT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next({"prev"}))
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Directional Focus (Arrow Keys)
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Directional Focus (Vim Controls)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "down" }))


-- ========== LOOK / WINDOW ==========
hl.bind(mainMod .. " + P", hl.dsp.window.pin({ target = "active" }))
hl.bind(mainMod .. " + O", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + I", hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + U", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind("F11", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = 1 }))	-- maximize a window (keep borders/bars)

-- Mouse bindings (move/resize)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + mouse:273", hl.dsp.window.resize({ keep_aspect_ratio = true }), { mouse = true })

-- Space alternative controls
hl.bind(mainMod .. " + Space", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + ALT + SHIFT + Space", hl.dsp.window.resize({ keep_aspect_ratio = true }), { mouse = true })


-- ========== WORKSPACES ==========
-- Switch workspaces (1–10 & F1–F6)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

for i = 1, 6 do
    local ws = i + 10
    local key = "F" .. i
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = ws, follow = false }))
end

-- Special Workspace (Scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("wsSpecial"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:wsSpecial" }))
hl.bind(mainMod .. " + CTRL + S", hl.dsp.window.move({ workspace = "special:wsSpecial", follow = false }))


-- ========== SPECIAL KEYS ==========
-- Audio & Brightness Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Media Player Controls
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

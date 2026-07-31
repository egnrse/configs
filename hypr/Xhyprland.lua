-- Custom Hyprland config file (by egnrse)
--
-- Refer to the hyprland wiki or the egnrse/configs git for more information.
-- https://wiki.hypr.land/Configuring/
-- https://github.com/egnrse/configs
--
-- This config uses the 'Universal Wayland Session Manager' (uwsm) and will not work without this dependency (select/use the 'hyprland (uwsm managed)' desktop entry)
-- https://github.com/Vladimir-csp/uwsm
-- See https://wiki.hyprland.org/Useful-Utilities/Systemd-start/
-- tl;dr: when starting apps add `uwsm app -- {launch command}`
--
-- You can create your files separately and then link them to this file like this:
-- require("./custom.lua")


require("hyprland.vars")
require("hyprland.general")
require("hyprland.keybinds")
require("hyprland.look-feel")
require("hyprland.window-rules")
require("hyprland.autostart")

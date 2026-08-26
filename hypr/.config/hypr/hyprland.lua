-- Hyprland config (Lua)
-- https://wiki.hypr.land/Configuring/

--------------------
---- MONITORS ----
--------------------

-- Monitor config managed by Monique
require("monitors")

--------------------
---- MY PROGRAMS ----
--------------------

local terminal = "alacritty"
local fileManager = "dolphin"
local menu = "qs -c noctalia-shell ipc call launcher toggle"
local controlCenter = "qs -c noctalia-shell ipc call controlCenter toggle"
local browser = "vivaldi-stable"
local screenshot = "hyprshot -m region --clipboard-only"

--------------------
---- AUTOSTART ----
--------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("qs -c noctalia-shell")
end)

-----------------------------
---- ENVIRONMENT VARIABLES ----
-----------------------------

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_MENU_PREFIX", "arch-")

--------------------
---- LOOK AND FEEL ----
--------------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 0,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	cursor = {
		inactive_timeout = 3,
	},

	decoration = {
		rounding = 0,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(ee1a1a1a)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = false,
	},

	master = {
		new_status = "master",
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},
})

-- Bezier curves
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations (defined but disabled above)
hl.animation({ leaf = "global", enabled = true, speed = 16, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

--------------
---- INPUT ----
--------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		repeat_delay = 180,
		repeat_rate = 50,
		follow_mouse = 2,
		float_switch_override_focus = 0,

		sensitivity = -0.3,

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- Per-device keyboard layouts
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({ name = "at-translated-set-2-keyboard", kb_layout = "de" })
hl.device({ name = "ferris-bling-lp-keyboard", kb_layout = "us" })
hl.device({ name = "hoksi-technology-durgod-taurus-k320", kb_layout = "gb" })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- 3-finger horizontal swipe to switch workspaces
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

------------------------
---- WORKSPACE RULES ----
------------------------

-- Workspaces 1-8 on HDMI-A-1, workspace 9 on eDP-1
for i = 1, 8 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })

--------------------
---- KEYBINDINGS ----
--------------------

local mainMod = "ALT"
local super = "SUPER"

-- Apps
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(super .. " + q", hl.dsp.window.close())
hl.bind(super .. " + e", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + b", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + v", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(super .. " + space", hl.dsp.exec_cmd(controlCenter))
hl.bind(mainMod .. " + j", hl.dsp.layout("togglesplit"))

-- Move focus
hl.bind(super .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(super .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(super .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(super .. " + down", hl.dsp.focus({ direction = "down" }))

-- Resize active window horizontally
hl.bind(super .. " + SHIFT + left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind(super .. " + SHIFT + right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))

-- Switch workspaces (number row + home-row mnemonic keys)
local workspaceKeys = { "n", "e", "i", "o", "a", "r", "s", "t", "g" }
for i, key in ipairs(workspaceKeys) do
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	-- Also bind number keys (1-9)
	hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end

-- Fullscreen
hl.bind(super .. " + m", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(super .. " + f", hl.dsp.window.fullscreen({ mode = 1 }))

-- Scroll through workspaces with SUPER + scroll
hl.bind(super .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(super .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(super .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(super .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshot
hl.bind(super .. " + p", hl.dsp.exec_cmd(screenshot))

-- Volume & brightness (bindel equivalent: locked + repeating)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Media keys (bindl equivalent: locked)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

----------------------------
---- WINDOWS AND WORKSPACES ----
----------------------------

-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Ignore maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix XWayland dragging issues
hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Float hyprland-run windows at the bottom of the screen
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

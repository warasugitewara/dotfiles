local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 基本
config.automatically_reload_config = true
config.font = wezterm.font("HackGen Console")
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.85

-- 使うターミナル
config.default_prog = { "nu" }

----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_decorations = "RESIZE"
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = true

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

config.window_background_gradient = {
	colors = { "#1a1a1a" },
}

config.colors = {
	background = "#1a1a1a",
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

-- Tab shape
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	if tab.is_active then
		background = "#ae8b2d"
	end
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = "none" } },
		{ Foreground = { Color = background } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = "none" } },
		{ Foreground = { Color = background } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }
config.enable_scroll_bar = true
config.scrollback_lines = 90000
return config

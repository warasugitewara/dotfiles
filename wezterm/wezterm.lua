local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 基本
config.automatically_reload_config = true
config.font = wezterm.font("HackGen Console NF")
config.font_size = 11.85
config.use_ime = true
config.window_background_opacity = 0.75
--                                ↑推定 0.75
-- 使うターミナル
config.default_prog = { "nu" }

-- XDG_CONFIG_HOME を .config に設定（nushell が .config から設定を読み込む）
-- パス区切りは OS に応じて自動判定（Windows: "\", Unix: "/"）
local home = wezterm.home_dir
local sep = package.config:sub(1, 1)
config.set_environment_variables = {
	XDG_CONFIG_HOME = home .. sep .. ".config",
	XDG_DATA_HOME = home .. sep .. ".local" .. sep .. "share",
	XDG_CACHE_HOME = home .. sep .. ".cache",
}

-- wezterm connect 経由の mux-server はログインシェルを通らず LANG が空になるため、
-- 未設定時のみ /etc/locale.conf から補う（Windows ではファイルが無いので何もしない）
if not os.getenv("LANG") then
	local f = io.open("/etc/locale.conf", "r")
	if f then
		for line in f:lines() do
			local lang = line:match("^LANG=\"?([^\"]+)\"?$")
			if lang then
				config.set_environment_variables.LANG = lang
				break
			end
		end
		f:close()
	end
end

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
-- SSH domain
----------------------------------------------------
-- Windows は公式 stable (20240203 / codec 42) しか無く、Arch の git スナップショット
-- (codec 45) と mux プロトコルが噛み合わないため素の SSH で繋ぐ。
-- Arch 同士 (VAIO ↔ dev) は pacman で版が揃うので mux-server を使う。
local is_windows = wezterm.target_triple:find("windows") ~= nil

config.ssh_domains = {
	{
		name = "dev",
		remote_address = "dev", -- ~/.ssh/config の Host dev を解決
		multiplexing = is_windows and "None" or "WezTerm",
		assume_shell = "Posix",
		-- set_environment_variables の XDG_* (Windows パス) が SSH ペインにも注入され、
		-- リモートの nushell が xdg_config_home_invalid を出すため外してから起動する。
		-- Linux の XDG デフォルトに任せれば ~/.config/nushell が読まれる。
		-- (default_prog は multiplexing = "None" のときのみ有効)
		default_prog = { "env", "-u", "XDG_CONFIG_HOME", "-u", "XDG_DATA_HOME", "-u", "XDG_CACHE_HOME", "nu" },
	},
}

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

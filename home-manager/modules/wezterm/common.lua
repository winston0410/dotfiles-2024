local wezterm = require("wezterm")

local M = {}

M.config = {
	initial_rows = 36,
	initial_cols = 120,
	default_prog = { "zsh" },
	font = wezterm.font_with_fallback({
        "0xProto Nerd Font",
		"Noto Sans Mono CJK HK",
	}),
	font_size = 16.0,
	enable_tab_bar = true,
	window_frame = {
		font_size = 18.0,
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	color_scheme = "tokyonight_night",
	color_schemes = {
		tokyonight_storm = {
			foreground = "#c0caf5",
			background = "#24283b",
			cursor_bg = "#c0caf5",
			cursor_border = "#c0caf5",
			cursor_fg = "#24283b",
			selection_bg = "#364A82",
			selection_fg = "#c0caf5",
			ansi = { "#1D202F", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },
			brights = { "#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },
		},
		tokyonight_night = {
			foreground = "#c0caf5",
			background = "#1a1b26",
			cursor_bg = "#c0caf5",
			cursor_border = "#c0caf5",
			cursor_fg = "#1a1b26",
			selection_bg = "#33467C",
			selection_fg = "#c0caf5",
			ansi = { "#15161E", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },
			brights = { "#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },
		},
	},
	disable_default_key_bindings = true,
	adjust_window_size_when_changing_font_size = true,
	enable_kitty_keyboard = true,
	enable_csi_u_key_encoding = false,
	leader = { key = ",", mods = "CTRL" },
	keys = {
		{
			key = "c",
			mods = "LEADER",
			action = wezterm.action.SpawnTab("DefaultDomain"),
		},
		{
			key = "q",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentTab({ confirm = false }),
		},
		{ key = "q", mods = "CTRL", action = wezterm.action.QuitApplication },
		{ key = "f", mods = "CTRL", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
		{ key = "c", mods = "CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
	},
}

for i = 1, 8 do
	table.insert(M.config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

return M

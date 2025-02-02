local wezterm = require("wezterm")

local hostname = wezterm.hostname()

-- dont edit
-- https://github.com/wez/wezterm/issues/3731#issuecomment-1592198263
local function is_vim(pane)
	local is_vim_env = pane:get_user_vars().IS_NVIM == "true"
	if is_vim_env == true then
		return true
	end
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

local super_vim_keys_map = {
	["["] = utf8.char(0xAA),
	p = utf8.char(0xAB),
	n = utf8.char(0xAC),
	w = utf8.char(0xAD),
	r = utf8.char(0xAE),
	s = utf8.char(0xAF),
	t = utf8.char(0xBA),
	e = utf8.char(0xBB),
}

local function bind_super_key_to_vim(key)
	return {
		key = key,
		mods = "CMD",
		action = wezterm.action_callback(function(win, pane)
			local char = super_vim_keys_map[key]
			-- send unicode for all programs, so we can bind key in zsh and nvim
			win:perform_action({
				SendKey = { key = char, mods = nil },
			}, pane)
		end),
	}
end
-- dont edit end

local config = {
	initial_rows = 48,
	initial_cols = 160,
	default_prog = { "zsh" },
	font = wezterm.font("Hack Nerd Font", { weight = "Regular", italic = false }),
	font_size = 16.0,
	enable_tab_bar = true,
	window_frame = {
		font_size = 18.0,
	},
	window_decorations = "INTEGRATED_BUTTONS|RESIZE",
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
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
	leader = { key = ",", mods = "CMD" },
	enable_kitty_keyboard = true,
	enable_csi_u_key_encoding = false,
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
		-- macos like shortcut for closing wezterm
		{ key = "q", mods = "CMD", action = wezterm.action.QuitApplication },
		{
			key = "f",
			mods = "CMD|CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
		-- not sure why I did this
		-- { key = "c", mods = "ALT", action = wezterm.action({ SendString = "\x03" }) },
		{ key = "f", mods = "CMD", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
		{ key = "c", mods = "CMD", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "CMD", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "=", mods = "CMD", action = "IncreaseFontSize" },
		{ key = "-", mods = "CMD", action = "DecreaseFontSize" },
		bind_super_key_to_vim("["),
		bind_super_key_to_vim("n"),
		bind_super_key_to_vim("p"),
		bind_super_key_to_vim("w"),
		bind_super_key_to_vim("r"),
		bind_super_key_to_vim("s"),
		bind_super_key_to_vim("t"),
		bind_super_key_to_vim("e"),
	},
}

for i = 1, 8 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

return config

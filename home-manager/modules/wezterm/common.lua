local wezterm = require("wezterm")
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local M = {}

M.config = {
	native_macos_fullscreen_mode = true,
	initial_rows = 32,
	initial_cols = 120,
	default_prog = { "zsh" },
	default_cursor_style = "SteadyBlock",
	font = wezterm.font_with_fallback({
		-- very legible, but a bit boring
		-- "Hack Nerd Font Mono",
		"0xProto Nerd Font Mono",
		-- not a bad font, but seems to be not actively maintained
		-- "Mononoki Nerd Font Mono",
		"Noto Sans Mono CJK HK",
		-- for matplotlib
		"DejaVu Sans Mono",
	}),
	font_size = 14,
	enable_tab_bar = true,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	window_frame = {
		font_size = 16.0,
	},
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	color_scheme = "tokyonight_night",
	color_schemes = {},
	disable_default_key_bindings = true,
	adjust_window_size_when_changing_font_size = true,
	enable_kitty_keyboard = true,
	enable_csi_u_key_encoding = false,
	leader = { key = ",", mods = "CTRL" },
	keys = {
		{
			key = "s",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				wezterm.log_info("Saving!")
				resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
				resurrect.window_state.save_window_action()
				resurrect.tab_state.save_tab_action()
			end),
		},
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
					local type = string.match(id, "^([^/]+)")
					id = string.match(id, "([^/]+)$")
					id = string.match(id, "(.+)%..+$")
					wezterm.log_info(string.format("type is %s, id is %s", type, id))
					local opts = {
						close_open_tabs = true,
						close_open_panes = true,
						window = pane:window(),
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					}
					if type == "workspace" then
						local state = resurrect.state_manager.load_state(id, "workspace")
						resurrect.workspace_state.restore_workspace(state, opts)
					elseif type == "window" then
						local state = resurrect.state_manager.load_state(id, "window")
						resurrect.window_state.restore_window(pane:window(), state, opts)
					elseif type == "tab" then
						local state = resurrect.state_manager.load_state(id, "tab")
						resurrect.tab_state.restore_tab(pane:tab(), state, opts)
					end
				end)
			end),
		},
		{
			key = "D",
			mods = "LEADER",
			action = wezterm.action.ShowDebugOverlay,
		},
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

resurrect.state_manager.periodic_save({
	interval_seconds = 60,
	save_workspaces = true,
	save_windows = true,
	save_tabs = true,
})
resurrect.state_manager.set_encryption({
	enable = false,
})
wezterm.on("resurrect.error", function(err)
	wezterm.log_error("ERROR!")
	wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
end)
-- NOTE this function only saves the workspace state at the moment, which is not what we want
-- REF https://github.com/MLFlexer/resurrect.wezterm/issues/86
-- wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
wezterm.on("gui-startup", function(cmd)
	-- NOTE all_windows will be empty in gui-startup
	-- local windows = wezterm.mux.all_windows()
	-- wezterm.log_info(wezterm.to_string(windows))
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	local opts = {
		close_open_tabs = true,
		close_open_panes = true,
		window = pane:window(),
		relative = true,
		restore_text = true,
		on_pane_restore = resurrect.tab_state.default_on_pane_restore,
	}
	local state = resurrect.state_manager.load_state("default", "workspace")
	resurrect.workspace_state.restore_workspace(state, opts)
end)

return M

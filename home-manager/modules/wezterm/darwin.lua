local wezterm = require("wezterm")
local common = require("common")

local config = common.config

local darwinOnlyMapping = {
	{ key = "c", mods = "CMD", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CMD", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

for _, mapping in ipairs(darwinOnlyMapping) do
	table.insert(config.keys, mapping)
end

-- REF https://github.com/wezterm/wezterm/issues/3299#issuecomment-2145712082
wezterm.on("gui-startup", function(cmd)
	local active = wezterm.gui.screens().active

	local _, _, window = wezterm.mux.spawn_window(cmd or {
		x = active.x,
		y = active.y,
		width = active.width,
		height = active.height,
	})

	window:gui_window():set_position(active.x, active.y)
	window:gui_window():set_inner_size(active.width, active.height)
end)

return config

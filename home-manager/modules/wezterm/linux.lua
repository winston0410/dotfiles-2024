local wezterm = require("wezterm")
local common = require("common")

local config = common.config
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config

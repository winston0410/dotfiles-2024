local wezterm = require("wezterm")
local common = require("common")

local config = common.config
-- just a temp solution
config.window_decorations = "NONE"
-- config.window_decorations = "RESIZE"

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)
-- REF https://github.com/wezterm/wezterm/issues/2595
-- When running wezterm in Wayland mode, the cursor in wezterm will be smaller due to the above issue

return config

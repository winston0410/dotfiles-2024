local wezterm = require("wezterm")
local common = require("common")

local config = common.config
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- REF https://github.com/wez/wezterm/issues/3751
-- Wezterm is a standalone X11 application, therefore we have to set cursor ourselves here
config.xcursor_theme = "phinger-cursors-light"
config.xcursor_size = 48

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config

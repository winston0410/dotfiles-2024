local wezterm = require("wezterm")
local common = require("common")

local config = common.config
config.native_macos_fullscreen_mode = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

local darwinOnlyMapping = {
	{ key = "c", mods = "CMD", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CMD", action = wezterm.action({ PasteFrom = "Clipboard" }) },
}

for _, mapping in ipairs(darwinOnlyMapping) do
	table.insert(config.keys, mapping)
end

-- REF https://github.com/wezterm/wezterm/issues/3299#issuecomment-2145712082

return config

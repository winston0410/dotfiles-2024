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

return config

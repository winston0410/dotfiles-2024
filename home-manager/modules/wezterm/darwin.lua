local wezterm = require("wezterm")
local common = require("common")

local config = common.config

local darwinOnlyMapping = {}

for _, mapping in ipairs(darwinOnlyMapping) do
	table.insert(config.keys, mapping)
end

return config

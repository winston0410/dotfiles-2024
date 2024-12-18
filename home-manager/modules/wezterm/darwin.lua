local wezterm = require("wezterm")
local common = require("common")


local config = common.config
config.leader = { key = ",", mods = "CMD" }

for _, mapping in ipairs(config.keys) do
	if mapping.mods == "CTRL" then
		mapping.mods = "CMD"
	end
end

return config
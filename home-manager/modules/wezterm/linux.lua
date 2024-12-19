local wezterm = require("wezterm")
local common = require("common")

local config = common.config
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

return config
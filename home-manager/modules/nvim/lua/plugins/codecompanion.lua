local render_markdown_ft = { "markdown", "codecompanion" }
-- use markview as it supports multiple filetypes
local enable_markview = true

return {
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		version = "6.x",
		cmd = { "MCPHub" },
		build = "bundled_build.lua",
		config = function()
		end,
	},
}

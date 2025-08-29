return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		version = "3.x",
		keys = {
			{
				"?l",
				function()
					require("which-key").show({ global = false, loop = true })
				end,
				silent = true,
				noremap = true,
				desc = "Show local keymaps",
			},
			{
				"?g",
				function()
					require("which-key").show({ global = true, loop = true })
				end,
				silent = true,
				noremap = true,
				desc = "Show global keymaps",
			},
		},
		config = function()
			local wk = require("which-key")

			wk.setup({
				preset = "helix",
				plugins = {
					marks = true,
					registers = true,
					spelling = {
						enabled = false,
						suggestions = 20,
					},
					presets = {
						operators = true,
						motions = true,
						text_objects = true,
						windows = true,
						nav = true,
						z = true,
						g = true,
					},
				},
				keys = {
					scroll_down = "<c-n>",
					scroll_up = "<c-p>",
				},
			})
		end,
	},
}

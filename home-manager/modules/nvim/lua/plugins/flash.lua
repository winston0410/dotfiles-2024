return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		version = "2.x",
		config = function()
			---@type Flash.Config
			require("flash").setup({
				highlight = {
					backdrop = false,
					matches = true,
				},
				---@type table<string, Flash.Config>
				modes = {
					search = {
						enabled = false,
					},
					char = {
						enabled = false,
						highlight = {
							backdrop = false,
						},
					},
				},
			})
		end,
		keys = {
			{
				"<leader>/",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						remote_op = {
							restore = true,
							motion = true,
						},
					})
				end,
				noremap = true,
				desc = "Flash",
			},
		},
	},
}

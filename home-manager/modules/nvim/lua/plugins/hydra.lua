return {
	{
		"nvimtools/hydra.nvim",
		version = "1.x",
		lazy = false,
		config = function()
			local hydra = require("hydra")

			hydra.setup({})

			hydra({
				name = "Window",
				mode = { "n" },
				body = "<c-w>",
				hint = false,
				config = {},
				heads = {
					{
						"+",
						"10<c-w>+",
						{
							noremap = true,
							silent = true,
							desc = "Increase split height",
						},
					},
					{
						"-",
						"10<c-w>-",
						{
							noremap = true,
							silent = true,
							desc = "Decrease split height",
						},
					},
					{
						">",
						"10<c-w>>",
						{
							noremap = true,
							silent = true,
							desc = "Increase split width",
						},
					},
					{
						"<",
						"10<c-w><",
						{
							noremap = true,
							silent = true,
							desc = "Decrease split width",
						},
					},
				},
			})
		end,
	},
}

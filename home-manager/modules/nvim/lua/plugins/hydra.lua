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
				config = {
					hint = false,
				},
				heads = {
					{
						"q",
						function()
							vim.cmd("quit")
						end,
						{
							noremap = true,
							silent = true,
							desc = "Create a horizontal split",
						},
					},
					{
						"s",
						"<c-w>s",
						{
							noremap = true,
							silent = true,
							desc = "Create a horizontal split",
						},
					},
					{
						"v",
						"<c-w>v",
						{
							noremap = true,
							silent = true,
							desc = "Create a vertical split",
						},
					},
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
						"=",
						"<c-w>=",
						{
							noremap = true,
							silent = true,
							desc = "Resize all splits to identical size",
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
					{
						"l",
						"<c-w>l",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the right split",
						},
					},
					{
						"h",
						"<c-w>h",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the left split",
						},
					},
					{
						"k",
						"<c-w>k",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the top split",
						},
					},
					{
						"j",
						"<c-w>j",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the bottom split",
						},
					},
					{
						"L",
						"<c-w>L",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the right split",
						},
					},
					{
						"H",
						"<c-w>H",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the left split",
						},
					},
					{
						"K",
						"<c-w>K",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the top split",
						},
					},
					{
						"J",
						"<c-w>J",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the bottom split",
						},
					},
				},
			})
		end,
	},
}

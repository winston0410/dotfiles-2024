return {
	{
		"chrisgrieser/nvim-spider",
		keys = {
			{
				"W",
				function()
					require("spider").motion("w")
				end,
				mode = { "n", "o", "x" },
				silent = true,
				noremap = true,
				desc = "Jump forward to word",
			},
			{
				"w",
				function()
					require("spider").motion("w")
				end,
				mode = { "n", "o", "x" },
				silent = true,
				noremap = true,
				desc = "Jump forward to word",
			},
			{
				"e",
				function()
					require("spider").motion("e")
				end,
				mode = { "n", "o", "x" },
				silent = true,
				noremap = true,
				desc = "Jump forward to end of word",
			},
			{
				"E",
				function()
					require("spider").motion("e")
				end,
				mode = { "n", "o", "x" },
				silent = true,
				noremap = true,
				desc = "Jump forward to end of word",
			},
			{
				"b",
				function()
					require("spider").motion("b")
				end,
				mode = { "n", "o", "x" },
				silent = true,
				noremap = true,
				desc = "Jump backward to word",
			},
			{
				"B",
				function()
					require("spider").motion("b")
				end,
				mode = { "n", "o", "x" },
				silent = true,
				noremap = true,
				desc = "Jump backward to word",
			},
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		-- NOTE By default, s is a useless synonym of cc, therefore we remap that
		keys = {
			{ "s", mode = "n" },
			{ "ss", mode = "n" },
			{ "cs", mode = "n" },
			{ "ds", mode = "n" },
			{ "s", mode = "x" },
		},
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = false,
					insert_line = false,
					normal = "s",
					normal_cur = "ss",
					normal_line = false,
					normal_cur_line = false,
					visual = "s",
					visual_line = false,
					delete = "ds",
					change = "cs",
					change_line = false,
				},
				aliases = {},
			})
		end,
	},
	{
		"gbprod/substitute.nvim",
		keys = {
			{
				"x",
				function()
					require("substitute.exchange").operator()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Exchange",
			},
			{
				"x",
				function()
					require("substitute.exchange").visual()
				end,
				mode = { "x" },
				silent = true,
				noremap = true,
				desc = "Exchange",
			},
			{
				"xx",
				function()
					require("substitute.exchange").line()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Exchange line",
			},
		},
		config = function()
			require("substitute").setup()
			vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Visual" })
			vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Visual" })
			vim.api.nvim_set_hl(0, "SubstituteExchange", { link = "Visual" })
		end,
	},
}

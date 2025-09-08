return {
	{
		"winston0410/encoding.nvim",
		keys = {
			{
				"g?1e",
				function()
					require("encoding").base64_encode()
				end,

				mode = { "n", "x" },
				silent = true,
				noremap = true,
				desc = "Base64 encode",
			},
			{
				"g?1d",
				function()
					require("encoding").base64_decode()
				end,

				mode = { "n", "x" },
				silent = true,
				noremap = true,
				desc = "Base64 decode",
			},
			{
				"g?2",
				function()
					require("encoding").uri_encode_or_decode()
				end,

				mode = { "n", "x" },
				silent = true,
				noremap = true,
				desc = "URI encode or decode",
			},
			{
				"g?3",
				"g?",
				mode = { "n", "x" },
				silent = true,
				remap = true,
				desc = "ROT13 encode or decode",
			},
		},
		opts = {},
	},
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
		version = "3.x",
		-- NOTE By default, s is a useless synonym of cc, therefore we remap that
		event = { "VeryLazy" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = false,
					insert_line = false,
					normal = false,
					normal_cur = false,
					normal_line = false,
					normal_cur_line = false,
					visual = false,
					visual_line = false,
					delete = false,
					change = false,
					change_line = false,
					-- insert = "<C-g>s",
					-- insert_line = "<C-g>S",
					-- normal = "s",
					-- normal_cur = "ss",
					-- normal_line = "S",
					-- normal_cur_line = "SS",
					-- visual = "s",
					-- visual_line = "gS",
					-- delete = "ds",
					-- change = "cs",
					-- change_line = "cS",
				},
				aliases = {},
			})
		end,
	},
	{
		"gbprod/substitute.nvim",
		keys = {
			-- do not use x and X default binding, as it is just a d alias (dl or dh)
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

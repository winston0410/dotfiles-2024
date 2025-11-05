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
		"chrisgrieser/nvim-various-textobjs",
		event = { "VeryLazy" },
		config = function()
			require("various-textobjs").setup({
				keymaps = {
					useDefaults = false,
				},
			})
			vim.keymap.set({ "o", "x" }, "aw", function()
				require("various-textobjs").subword("outer")
			end, { silent = true, noremap = true, desc = "Around subword" })
			vim.keymap.set({ "o", "x" }, "iw", function()
				require("various-textobjs").subword("inner")
			end, { silent = true, noremap = true, desc = "Inside subword" })
		end,
	},
	{
		"chrisgrieser/nvim-spider",
		keys = {
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
				"ge",
				function()
					require("spider").motion("ge")
				end,
				mode = { "n", "o", "x" },
				silent = true,
				noremap = true,
				desc = "Jump backward to previous end of word",
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
					-- insert = false,
					-- insert_line = false,
					-- normal = false,
					-- normal_cur = false,
					-- normal_line = false,
					-- normal_cur_line = false,
					-- visual = false,
					-- visual_line = false,
					-- delete = false,
					-- change = false,
					-- change_line = false,
					insert = "<C-g>s",
					insert_line = "<C-g>S",
					normal = "s",
					normal_cur = "ss",
					normal_line = "S",
					normal_cur_line = "SS",
					visual = "s",
					visual_line = "gS",
					delete = "ds",
					change = "cs",
					change_line = "cS",
				},
				aliases = {},
			})
		end,
	},
	{
		"winston0410/substitute.nvim",
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

			-- local hydra = require("hydra")
			-- local exchange_hydra = hydra({
			-- 	name = "Exchange",
			-- 	mode = { "n", "x" },
			-- 	config = {
			--                  -- color = "pink",
			--                  -- foreign_keys = 'run'
			-- 		hint = false,
			-- 	},
			-- 	heads = {},
			-- })

			local group = vim.api.nvim_create_augroup("SubstitueHydraMode", { clear = true })

			-- somehow with pink hydra, the mode cannot be switched correctly
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "SubstitutePrepareExchange",
				callback = function()
					-- exchange_hydra:activate()
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "SubstituteCancelExchange",
				callback = function()
					-- exchange_hydra:exit()
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "SubstituteCompleteExchange",
				callback = function()
					-- exchange_hydra:exit()
				end,
			})
		end,
	},
}

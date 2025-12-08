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

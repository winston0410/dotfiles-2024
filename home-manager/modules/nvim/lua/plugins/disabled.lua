return {

	{
		"chrisgrieser/nvim-recorder",
		enabled = false,
		opts = {},
	},
	{
		"Isrothy/neominimap.nvim",
		version = "v3.*.*",
		enabled = false,
		lazy = false,
		init = function()
			vim.opt.wrap = false
			vim.opt.sidescrolloff = 36 -- Set a large value
			vim.g.neominimap = {
				auto_enable = true,
				-- NOTE to have higher z-index than nvim-treesitter
				float = { z_index = 11 },
			}
		end,
	},
	{
		"mcauley-penney/visual-whitespace.nvim",
		-- this plugin is too intrusive
		enabled = false,
		opts = {},
	},
	{
		"folke/trouble.nvim",
		version = "3.x",
		event = { "BufReadPre", "BufNewFile" },
		enabled = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("trouble").setup({
				position = "bottom",
				use_diagnostic_signs = true,
				indent_lines = false,
				auto_preview = false,
				auto_close = true,
				auto_refresh = true,
				win = {
					wo = {
						wrap = true,
					},
				},
				modes = {
					diagnostics = {
						auto_open = true,
						format = "{severity_icon} {message:md} {item.source} {code}",
					},
					lsp_document_symbols = {
						auto_open = false,
						win = {
							wo = {
								wrap = false,
							},
						},
						format = "{kind_icon} {symbol.name} {text:Comment} {pos}",
					},
					symbols = {
						auto_open = false,
						format = "{kind_icon} {symbol.name}",
					},
				},
				keys = {
					["?"] = false,
					["<cr>"] = "jump",
					["<leader>ws<cr>"] = "jump_split",
					["<leader>wv<cr>"] = "jump_vsplit",
				},
			})
		end,
	},
}

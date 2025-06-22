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
		"jackplus-xyz/player-one.nvim",
		enabled = false,
		opts = {
			is_enabled = true,
			debug = true,
		},
	},
	{
		"nvim-neorg/neorg",
		ft = { "norg" },
		enabled = false,
		dependencies = { "pysan3/pathlib.nvim", "nvim-neorg/lua-utils.nvim", "nvim-neotest/nvim-nio" },
		version = "9.x",
		config = function()
			-- NOTE https://github.com/nvim-neorg/neorg/blob/53714b1783d4bb5fa154e2a5428b086fb5f3d8a5/res/wiki/static/Setup-Guide.md
			require("neorg").setup({
				load = {
					["core.defaults"] = {},
					["core.concealer"] = {},
				},
			})
		end,
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
	{
		"folke/edgy.nvim",
		version = "1.x",
		event = "VeryLazy",
		enabled = false,
		opts = {
			animate = {
				enabled = false,
			},
			wo = {
				winbar = false,
			},
			options = {
				left = { size = 30 },
				bottom = { size = 4 },
				right = { size = 30 },
				top = { size = 10 },
			},
			left = {
				-- NOTE use oil.nvim for create/edit/delete files. For opening file, use picker is a better option
				-- {
				-- 	ft = "oil",
				-- 	size = { width = 0.25 },
				-- },
			},
			right = {
				{
					ft = "trouble",
					title = "LSP Symbols",
					filter = function(_, win)
						return vim.w[win].trouble
							and (
								vim.w[win].trouble.mode == "symbols"
								or vim.w[win].trouble.mode == "lsp_document_symbols"
							)
					end,
					size = { width = 0.2 },
				},
			},
			bottom = {
				{
					ft = "trouble",
					title = "Diagnostics",
					filter = function(_, win)
						return vim.w[win].trouble and vim.w[win].trouble.mode == "diagnostics"
					end,
					size = { width = 0.5, height = 1 },
				},
				{ ft = "qf", title = "QuickFix", size = { width = 0.5, height = 1 } },
				-- {
				-- 	ft = "trouble",
				-- 	title = "Quickfix",
				-- 	filter = function(_buf, win)
				-- 		return vim.w[win].trouble and vim.w[win].trouble.mode == "qflist"
				-- 	end,
				-- 	size = { width = 0.5, height = 1 },
				-- },
			},
			exit_when_last = true,
		},
		init = function()
			vim.opt.splitkeep = "screen"
		end,
	},
}

return {
	{
		"artemave/workspace-diagnostics.nvim",
		-- TODO enable this later, as there is no way to disable the warning message, and it can only help with existing LSP client. It doesn't trigger LSP to start automatically.
		enabled = false,
		event = { "LspAttach" },
		config = function()
			require("workspace-diagnostics").setup({})
		end,
	},
    -- NOTE enable this plugin after 0.12 using vim.pack, and disable it by default. Trigger it with usercmd when needed, so to reduce the noise in code
	{
		"oribarilan/lensline.nvim",
		enabled = false,
		version = "2.x",
		event = { "LspAttach" },
		config = function()
			require("lensline").setup()
		end,
	},
	{
		"nvimtools/none-ls.nvim",
        enabled = false,
		dependencies = { "nvim-lua/plenary.nvim", "ckolkey/ts-node-action", "ThePrimeagen/refactoring.nvim" },
		event = lspconfig_load_event,
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.gdlint,
					null_ls.builtins.diagnostics.checkmake,
					null_ls.builtins.diagnostics.haml_lint,
					null_ls.builtins.diagnostics.terraform_validate,
					null_ls.builtins.diagnostics.tidy,
					null_ls.builtins.diagnostics.opacheck,
					null_ls.builtins.code_actions.refactoring,
					null_ls.builtins.code_actions.ts_node_action,
				},
			})
		end,
	},
	{
		"kosayoda/nvim-lightbulb",
		enabled = false,
		version = "1.x",
		event = { "LspAttach" },
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
				ignore = {
					clients = { "null-ls" },
					ft = {},
					actions_without_kind = false,
				},
			})
		end,
	},    
	{
		"tzachar/highlight-undo.nvim",
		-- Using u and <C-r> seems to be enough for me
		enabled = false,
		event = "VeryLazy",
		opts = {
			hlgroup = "Visual",
			duration = 500,
			pattern = { "*" },
			ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "snacks_dashboard" },
		},
	},
	{
		"mrjones2014/smart-splits.nvim",
		version = "1.x",
		enabled = false,
		keys = {
			{
				"<leader>w>",
				function()
					require("smart-splits").resize_right()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to right",
			},
			{
				"<C-w>>",
				function()
					require("smart-splits").resize_right()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to right",
			},
			{
				"<C-w><",
				function()
					require("smart-splits").resize_left()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to left",
			},
			{
				"<leader>w<",
				function()
					require("smart-splits").resize_left()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to left",
			},
			{
				"<leader>w+",
				function()
					require("smart-splits").resize_up()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to top",
			},
			{
				"<C-w>+",
				function()
					require("smart-splits").resize_up()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to top",
			},
			{
				"<leader>w-",
				function()
					require("smart-splits").resize_down()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to bottom",
			},
			{
				"<C-w>-",
				function()
					require("smart-splits").resize_down()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to bottom",
			},
		},
		opts = {
			default_amount = 10,
		},
	},
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

local ERROR_ICON = " "
local WARNING_ICON = " "
local INFO_ICON = " "
local HINT_ICON = "󰌶 "
-- https://www.reddit.com/r/neovim/comments/1308ie7/comment/jhvkipp/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
local lspconfig_load_event = {
	-- for reading a buffer
	"BufReadPost",
	-- for creating an unnamed buffer
	"BufNewFile",
	"CursorMoved",
}
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
		"AbysmalBiscuit/insert-inlay-hints.nvim",
		event = { "LspAttach" },
		version = "0.x",
		keys = {
			{
				"<leader>si",
				function()
					require("insert-inlay-hints").closest()
				end,
				desc = "Insert the closest inline hint as code.",
				mode = { "n" },
			},
			{
				"<leader>si",
				function()
					require("insert-inlay-hints").visual()
				end,
				desc = "Insert all inlay hints in the current visual selection as code.",
				mode = { "x" },
			},
		},
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
}

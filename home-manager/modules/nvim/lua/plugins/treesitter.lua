return {
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
		config = function() end,
	},
	-- keep using this until d2 is supporte by neovim out of the box
	{
		"ravsii/tree-sitter-d2",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		version = "*",
		build = "make nvim-install",
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = false,
					node_incremental = "+",
					node_decremental = "-",
					scope_incremental = false,
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			-- { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
		},
		build = function()
			vim.cmd("TSUpdate")
		end,
		branch = "main",
		lazy = false,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			require("nvim-treesitter").setup({})

			vim.api.nvim_create_autocmd("User", { pattern = "TSUpdate", callback = function() end })
		end,
	},

	-- TODO see if we can turn these into treesitter's dependencies, and config with its setup function
	{
		"nvim-treesitter/nvim-treesitter-context",
		-- replaced this plugin with dropbar.nvim, as it occupies less estate on screen
		enabled = false,
		opts = {
			max_lines = 5,
		},
		event = { "VeryLazy" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = { "VeryLazy" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}

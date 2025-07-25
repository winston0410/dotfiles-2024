return {
	{
		"mistricky/codesnap.nvim",
		build = "make",
		version = "1.x",
		cmd = { "CodeSnapHighlight", "CodeSnapSaveHighlight", "CodeSnapASCII", "CodeSnap", "CodeSnapSave" },
	},
	-- NOTE interesting plugin, but not very useful
	{
		"mawkler/hml.nvim",
		enabled = false,
		event = { "VeryLazy" },
		opts = {},
	},
	{
		"mcauley-penney/visual-whitespace.nvim",
		event = { "VeryLazy" },
		config = function()
			local comment_hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
			local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
			require("visual-whitespace").setup({
				highlight = { fg = comment_hl.fg, bg = visual_hl.bg },
			})
		end,
	},
	{
		"trixnz/sops.nvim",
		lazy = false,
		opts = {
			supported_file_formats = { "*.yaml", "*.json", "*.ini" },
		},
	},
	{
		"michaelb/sniprun",
		version = "1.x",
		build = false,
		cmd = { "SnipClose", "SnipInfo", "SnipReset", "SnipRun", "SnipReplMemoryClean" },
		config = function()
			require("sniprun").setup({
				binary_path = "sniprun",
			})
		end,
	},
	{
		"stevearc/overseer.nvim",
		cmd = {
			"OverseerOpen",
			"OverseerClose",
			"OverseerToggle",
			"OverseerSaveBundle",
			"OverseerLoadBundle",
			"OverseerDeleteBundle",
			"OverseerRunCmd",
			"OverseerRun",
			"OverseerInfo",
			"OverseerBuild",
			"OverseerQuickAction",
			"OverseerTaskAction",
			"OverseerClearCache",
		},
		keys = {
			{
				"<leader>e",
				function()
					require("overseer").toggle()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Toggle Overseer",
			},
			{
				"<leader>p<leader>e",
				function()
					vim.cmd("OverseerRun")
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Pick task to run",
			},
		},
		version = "1.x",
		opts = {
			bundles = {
				autostart_on_load = false,
			},
		},
	},
}

return {
	{
		"lewis6991/gitsigns.nvim",
		version = "1.x",
		event = { "VeryLazy" },
		keys = {
			-- TODO how to select local diff hunk?????
			-- TODO review the keybindings here
			{
				"ac",
				function()
					require("gitsigns").select_hunk()
				end,
				mode = { "o", "x" },
				silent = true,
				noremap = true,
				desc = "Git hunk",
			},
			-- NOTE in the structure of ns-verb-noun, similar to an operator
			{
				"<leader>gsc",
				function()
					require("gitsigns").stage_hunk()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Stage hunk",
			},
			{
				"<leader>gpc",
				function()
					require("gitsigns").preview_hunk()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Preview hunk",
			},
			{
				"<leader>grc",
				function()
					require("gitsigns").reset_hunk()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Reset hunk",
			},
			{
				"]c",
				function()
					if vim.wo.diff then
						vim.cmd.normal({ "]c", bang = true })
					else
						require("gitsigns").nav_hunk("next")
					end
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Jump to next hunk",
			},
			{
				"[c",
				function()
					if vim.wo.diff then
						vim.cmd.normal({ "[c", bang = true })
					else
						require("gitsigns").nav_hunk("prev")
					end
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Jump to previous hunk",
			},
		},
		config = function()
			local pipe_icon = "┃"
			local signs_icons = {
				add = { text = pipe_icon },
				change = { text = pipe_icon },
				delete = { text = pipe_icon },
				topdelete = { text = pipe_icon },
				changedelete = { text = pipe_icon },
				untracked = { text = pipe_icon },
			}
			require("gitsigns").setup({
				signs = signs_icons,
				signs_staged = signs_icons,
				signcolumn = true,
				linehl = false,
				current_line_blame = true,
				preview_config = {
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
}

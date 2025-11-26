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
	{
		"esmuellert/vscode-diff.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		version = "1.x",
        cmd = {"CodeDiff"}
	},
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewRefresh",
			"DiffviewFileHistory",
		},
		config = function()
			local actions = require("diffview.actions")

			require("diffview").setup({
				enhanced_diff_hl = true,
				use_icons = true,
				show_help_hints = false,
				watch_index = true,
				icons = {
					folder_closed = "",
					folder_open = "",
				},
				signs = {
					fold_closed = "",
					fold_open = "",
					done = "✓",
				},
				view = {
					default = {
						layout = "diff2_horizontal",
					},
					merge_tool = {
						layout = "diff3_mixed",
					},
					file_history = {
						layout = "diff2_horizontal",
					},
				},
				file_panel = {
					listing_style = "tree",
					tree_options = {
						flatten_dirs = true,
						folder_statuses = "never",
					},
					win_gitsigconfig = {
						position = "left",
						width = 25,
						win_opts = {
							wrap = true,
						},
					},
				},
				file_history_panel = {
					log_options = {
						git = {
							single_file = {
								diff_merges = "combined",
							},
							multi_file = {
								diff_merges = "first-parent",
							},
						},
					},
					win_config = {
						position = "bottom",
						height = 10,
						win_opts = {},
					},
				},
				commit_log_panel = {
					win_config = {},
				},
				keymaps = {
					disable_defaults = true,
					-- the view for the changed files
					view = {
						{
							"n",
							"[x",
							actions.prev_conflict,
							{ desc = "Jump to the previous conflict" },
						},
						{
							"n",
							"]x",
							actions.next_conflict,
							{ desc = "Jump to the next conflict" },
						},
						{
							"n",
							"<tab>",
							actions.select_next_entry,
							{ desc = "Open the diff for the next file" },
						},
						{
							"n",
							"<s-tab>",
							actions.select_prev_entry,
							{ desc = "Open the diff for the previous file" },
						},
						-- TODO decide the right bindings, and apply it to all views
						-- {
						-- 	"n",
						-- 	"<leader>ed",
						-- 	actions.cycle_layout,
						-- 	{ desc = "Cycle through available layouts." },
						-- },
						{
							"n",
							"<leader>o",
							actions.toggle_files,
							{ desc = "Toggle the file panel." },
						},
						-- NOTE use <leader>x as the exclusive key for diffview for now. DO NOT use do and dp, as they would not work with 3 way diffs
						{
							"n",
							"<leader>bo",
							actions.conflict_choose("ours"),
							{ desc = "Choose OURS version of a conflict" },
						},
						{
							"n",
							"<leader>bt",
							actions.conflict_choose("theirs"),
							{ desc = "Choose THEIRS version of a conflict" },
						},
						{
							"n",
							"<leader>bb",
							actions.conflict_choose("base"),
							{ desc = "Choose BASE version of a conflict" },
						},
						{
							"n",
							"<leader>ba",
							actions.conflict_choose("all"),
							{ desc = "Choose ALL version of a conflict" },
						},
						{
							"n",
							"<leader>bn",
							actions.conflict_choose("none"),
							{ desc = "Choose NONE version of a conflict" },
						},
						{
							"n",
							"<leader>bO",
							actions.conflict_choose_all("ours"),
							{ desc = "Choose OURS version of all conflicts" },
						},
						{
							"n",
							"<leader>bT",
							actions.conflict_choose_all("theirs"),
							{ desc = "Choose THEIRS version of all conflicts" },
						},
						{
							"n",
							"<leader>bB",
							actions.conflict_choose_all("base"),
							{ desc = "Choose BASE version of all conflicts" },
						},
						{
							"n",
							"<leader>bA",
							actions.conflict_choose_all("all"),
							{ desc = "Choose ALL version of all conflicts" },
						},
						{
							"n",
							"<leader>bN",
							actions.conflict_choose("none"),
							{ desc = "Choose NONE version of all conflicts" },
						},
					},
					file_panel = {
						{
							"n",
							"<cr>",
							actions.select_entry,
							{ desc = "Open the diff for the selected entry" },
						},
						{
							"n",
							"<2-LeftMouse>",
							actions.select_entry,
							{ desc = "Open the diff for the selected entry" },
						},
						{
							"n",
							"[x",
							actions.prev_conflict,
							{ desc = "Jump to the previous conflict" },
						},
						{
							"n",
							"]x",
							actions.next_conflict,
							{ desc = "Jump to the next conflict" },
						},
						{
							"n",
							"<tab>",
							actions.select_next_entry,
							{ desc = "Open the diff for the next file" },
						},
						{
							"n",
							"<s-tab>",
							actions.select_prev_entry,
							{ desc = "Open the diff for the previous file" },
						},
						{
							"n",
							"gf",
							actions.goto_file_edit,
							{ desc = "Open the file in the previous tabpage" },
						},
					},
					file_history_panel = {
						{
							"n",
							"y",
							actions.copy_hash,
							{ desc = "Copy the commit hash of the entry under the cursor" },
						},
						{
							"n",
							"<cr>",
							actions.select_entry,
							{ desc = "Open the diff for the selected entry" },
						},
						{
							"n",
							"<2-LeftMouse>",
							actions.select_entry,
							{ desc = "Open the diff for the selected entry" },
						},
						{
							"n",
							"<tab>",
							actions.select_next_entry,
							{ desc = "Open the diff for the next file" },
						},
						{
							"n",
							"<s-tab>",
							actions.select_prev_entry,
							{ desc = "Open the diff for the previous file" },
						},
						{
							"n",
							"gf",
							actions.goto_file_edit,
							{ desc = "Open the file in the previous tabpage" },
						},
					},
					option_panel = {
						{ "n", "<tab>", actions.select_entry, { desc = "Change the current option" } },
						{ "n", "q", actions.close, { desc = "Close the panel" } },
					},
					help_panel = {
						{ "n", "q", actions.close, { desc = "Close help menu" } },
						{ "n", "<esc>", actions.close, { desc = "Close help menu" } },
					},
				},
			})

			-- local autocmd_callback = function(ev)
			-- 	vim.api.nvim_set_option_value("foldenable", false, { scope = "local" })
			-- 	vim.api.nvim_set_option_value("foldcolumn", "0", { scope = "local" })
			-- 	vim.api.nvim_set_option_value("wrap", false, { scope = "local" })
			--
			-- 	vim.keymap.set("n", "[h", "[c", { noremap = true, silent = true, desc = "Jump to the previous hunk" })
			-- 	vim.keymap.set("n", "]h", "]c", { noremap = true, silent = true, desc = "Jump to the next hunk" })
			--
			-- 	vim.api.nvim_buf_set_var(ev.buf, "isdiffbuf", true)
			-- 	vim.api.nvim_buf_set_var(ev.buf, "lockbuffer", true)
			-- end
			--
			-- vim.api.nvim_create_autocmd("User", {
			-- 	pattern = "DiffviewDiffBufRead",
			-- 	callback = autocmd_callback,
			-- })
			-- vim.api.nvim_create_autocmd("User", {
			-- 	pattern = "DiffviewDiffBufWinEnter",
			-- 	callback = autocmd_callback,
			-- })
			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	pattern = "DiffviewFileHistory",
			-- 	callback = function(ev)
			-- 		local tab_id = vim.api.nvim_get_current_tabpage()
			-- 		vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFileHistory")
			-- 		vim.api.nvim_tabpage_set_var(tab_id, "lockbuffer", true)
			-- 		vim.api.nvim_buf_set_var(ev.buf, "lockbuffer", true)
			-- 	end,
			-- })
			-- vim.api.nvim_create_autocmd("FileType", {
			-- 	pattern = "DiffviewFiles",
			-- 	callback = function(ev)
			-- 		local tab_id = vim.api.nvim_get_current_tabpage()
			-- 		vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFiles")
			-- 		vim.api.nvim_buf_set_var(ev.buf, "lockbuffer", true)
			-- 		vim.api.nvim_tabpage_set_var(tab_id, "lockbuffer", true)
			-- 	end,
			-- })
		end,
	},
	{
		"NeogitOrg/neogit",
		cmd = {
			"Neogit",
			"NeogitCommit",
			"NeogitLogCurrent",
			"NeogitResetState",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"folke/snacks.nvim",
		},
		keys = {
			{
				"<leader>gg",
				function()
					require("neogit").open()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Open Neogit status",
			},
		},
		opts = {
			-- FIXME range diffing is not working correctly, cannot select the target of "to"
			disable_hint = true,
			disable_commit_confirmation = true,
			graph_style = "unicode",
			kind = "tab",
			integrations = {
				diffview = true,
				snacks = true,
			},
			mappings = {
				status = {
					["<enter>"] = "Toggle",
				},
			},
		},
	},
}

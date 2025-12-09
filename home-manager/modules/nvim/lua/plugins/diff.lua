vim.pack.add({
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/esmuellert/vscode-diff.nvim", version = vim.version.range("1.x") },
	{ src = "https://github.com/sindrets/diffview.nvim" },
})
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

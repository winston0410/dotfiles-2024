vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim", version = vim.version.range("2.x") },
})
local picker_keys = {
	["/"] = "toggle_focus",
	["<2-LeftMouse>"] = "confirm",
	["<leader>q"] = { "qflist", mode = { "n" } },
	["<leader>a"] = { "argadd", mode = { "n" } },
	["<CR>"] = { "confirm", mode = { "n", "i" } },
	["<Down>"] = { "list_down", mode = { "i", "n" } },
	["<Up>"] = { "list_up", mode = { "i", "n" } },
	["<Esc>"] = "close",
	["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
	["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
	["G"] = "list_bottom",
	["gg"] = "list_top",
	["j"] = "list_down",
	["k"] = "list_up",
	["q"] = "close",
	["<a-p>"] = "toggle_preview",
	["<a-w>"] = "cycle_win",
	["<c-w>H"] = "layout_left",
	["<c-w>J"] = "layout_bottom",
	["<c-w>K"] = "layout_top",
	["<c-w>L"] = "layout_right",
	["?"] = function()
		require("which-key").show({ global = true, loop = true })
	end,
}

local config_dir = vim.fn.stdpath("config")
---@cast config_dir string
require("snacks").setup({
	toggle = { enabled = true },
	gitbrowse = {
		enabled = true,
		remote_patterns = {
			{ "^(.-)@vs%-ssh%.visualstudio%.com:v3/(.-)/(.-)/(.-)$", "%1.visualstudio.com/%3/_git/%4" },
		},
		url_patterns = {
			["visualstudio%.com"] = {
				branch = "?version=GB{branch}",
				-- FIXME only line row number is returned, we need both row and column to get the highlight in ado https://github.com/folke/snacks.nvim/blob/bfe8c26dbd83f7c4fbc222787552e29b4eccfcc0/lua/snacks/gitbrowse.lua#L177C24-L177C49
				file = "?path={file}&version=GB{branch}&line={line_start}&lineEnd={line_end}&lineStartColumn=1&lineEndColumn=999&lineStyle=plain&_a=contents",
				permalink = "?path={file}&version=GB{branch}&line={line_start}&lineEnd={line_end}&lineStartColumn=1&lineEndColumn=999&lineStyle=plain&_a=contents",
				commit = "/commit/{commit}",
			},
		},
	},
	bigfile = { enabled = false },
	scratch = { enabled = true },
	image = { enabled = true },
	dashboard = {
		enabled = false,
		sections = {
			{
				section = "terminal",
				cmd = string.format(
					"chafa %s --format symbols --symbols block --size 60x17",
					vim.fs.joinpath(config_dir, "assets", "flag_of_british_hk.png")
				),
				height = 17,
				padding = 1,
			},
			{
				pane = 2,
				{
					icon = " ",
					title = "Recent Files",
					section = "recent_files",
					limit = 3,
					indent = 2,
					padding = { 2, 2 },
				},
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
				{ section = "startup" },
			},
		},
	},
	picker = {
		sources = {
			enhanced_git_log = require("custom.snacks.enhanced_git_log_source").enhanced_git_log,
			ast_grep = require("custom.snacks.ast_grep").ast_grep,
		},
		enabled = true,
		ui_select = true,
		---@class snacks.picker.matcher.Config
		matcher = {
			cwd_bonus = true,
		},
		layout = {
			cycle = true,
			preset = function()
				return vim.o.columns >= 120 and "default" or "vertical"
			end,
		},
		actions = {
			argadd = function(picker)
				picker:close()
				local selected = picker:selected({ fallback = true })
				for _, item in ipairs(selected) do
					vim.cmd.argadd(item.file)
				end
				vim.cmd.argdedupe()
			end,
			difftool = function(picker, item)
                vim.cmd("packadd nvim.difftool")
                local difftool_utils = require("custom.difftool-utils")
				picker:close()
				if not item then
					return
				end

				local what = item.branch or item.commit --[[@as string?]]

				if not what then
					return
				end
                local current_branch = difftool_utils.get_current_branch()

                local left_dir = difftool_utils.convert_revision_into_temp_dir(current_branch)
                local right_dir = difftool_utils.convert_revision_into_temp_dir(what)

				require("difftool").open(left_dir, right_dir)
			end,
		},
		win = {
			input = {
				keys = picker_keys,
			},
			list = {
				keys = vim.tbl_extend("force", picker_keys, {
					["zb"] = "list_scroll_bottom",
					["zt"] = "list_scroll_top",
					["zz"] = "list_scroll_center",
				}),
			},
		},
	},
	scroll = {
		enabled = true,
		animate = {
			duration = { step = 10, total = 100 },
			easing = "linear",
		},
	},
	input = {
		enabled = true,
	},
	notifier = {
		enabled = true,
		style = "fancy",
		level = vim.log.levels.INFO,
	},
	indent = {
		-- TODO enable later, after is it working with DiffviewOpen without error
		enabled = true,
	},
	words = { enabled = false },
	styles = {
		notification = {
			wo = {
				wrap = true,
			},
		},
	},
})

vim.api.nvim_create_user_command("Zen", function()
	Snacks.notifier.hide() -- hide all notifications, but keep Snacks.notifier there
end, {
	desc = "Reduce distraction",
})


vim.keymap.set({ "n" }, "<leader>n", function()
	Snacks.scratch()
end, { silent = true, noremap = true, desc = "Toggle Scratch Buffer" })

vim.keymap.set({ "n" }, "<leader>p<leader>a", function()
	-- TODO
end, { silent = true, noremap = true, desc = "Search arglist" })

vim.keymap.set({ "n" }, "<leader>p<leader>q", function()
	Snacks.picker.qflist()
end, { silent = true, noremap = true, desc = "Search quickfix" })

vim.keymap.set({ "n" }, "<leader>p<leader>n", function()
	Snacks.scratch.select()
end, { silent = true, noremap = true, desc = "Select Scratch Buffer" })

vim.keymap.set({ "n" }, "<leader>pj", function()
	Snacks.picker.jumps()
end, { silent = true, noremap = true, desc = "Search jumplist history" })

vim.keymap.set({ "n" }, '<leader>p"', function()
	Snacks.picker.registers()
end, { silent = true, noremap = true, desc = "Search registers" })

vim.keymap.set({ "n" }, "<leader>p/", function()
	Snacks.picker.search_history()
end, { silent = true, noremap = true, desc = "Search search history" })

vim.keymap.set({ "n" }, "<leader>pu", function()
	Snacks.picker.undo()
end, { silent = true, noremap = true, desc = "Search undo history" })

vim.keymap.set({ "n" }, "<leader>pn", function()
	Snacks.picker.notifications({ confirm = { "copy", "close" } })
end, { silent = true, noremap = true, desc = "Search notifications history" })

vim.keymap.set({ "n" }, "<leader>pc", function()
	Snacks.picker.command_history()
end, { silent = true, noremap = true, desc = "Search command history" })

vim.keymap.set({ "n" }, "<leader>pd", function()
	Snacks.picker.diagnostics()
end, { silent = true, noremap = true, desc = "Search diagnostics" })

vim.keymap.set({ "n" }, "<leader>pD", function()
	Snacks.picker.diagnostics_buffer()
end, { silent = true, noremap = true, desc = "Search diagnostics in the current buffer" })

vim.keymap.set({ "n" }, "<leader>p<leader>gs", function()
	Snacks.picker.git_status()
end, { silent = true, noremap = true, desc = "Search Git Status" })

vim.keymap.set({ "n" }, "<leader>p<leader>gZ", function()
	Snacks.picker.git_stash()
end, { silent = true, noremap = true, desc = "Search Git Stash" })

vim.keymap.set({ "n" }, "<leader>p<leader>gc", function()
	Snacks.picker.git_diff()
end, { silent = true, noremap = true, desc = "Search Git Hunks" })

vim.keymap.set({ "n" }, "<leader>gl", function()
	vim.cmd("DiffviewFileHistory %")
end, { silent = true, noremap = true, desc = "Git log of the current file" })

vim.keymap.set({ "n" }, "<leader>p<leader>gl", function()
	Snacks.picker.pick({
		format = "git_log",
		notify = false,
		source = "enhanced_git_log",
		show_empty = true,
		preview = "git_show",
		confirm = "difftool",
		live = true,
		supports_live = true,
		sort = { fields = { "score:desc", "idx" } },
	})
end, { silent = true, noremap = true, desc = "Search Git log" })

vim.keymap.set({ "n" }, "<leader>pW", function()
	Snacks.picker.pick({
		format = "file",
		notify = false,
		source = "ast_grep",
		show_empty = true,
		live = true,
		supports_live = true,
		hidden = true,
		ignored = true,
	})
end, { silent = true, noremap = true, desc = "AST Grep in files" })

vim.keymap.set({ "n" }, "<leader>pw", function()
	Snacks.picker.grep({ hidden = true })
end, { silent = true, noremap = true, desc = "Grep in files" })

vim.keymap.set({ "x" }, "<leader>pw", function()
	Snacks.picker.grep_word({ hidden = true })
end, { silent = true, noremap = true, desc = "Combined Grep in files" })

vim.keymap.set({ "n" }, "<leader>p<leader>gb", function()
	Snacks.picker.git_branches({ confirm = "difftool" })
end, { silent = true, noremap = true, desc = "Search Git branches" })

vim.keymap.set({ "n", "x" }, "<leader>gx", function()
	vim.ui.select({ "file", "branch", "permalink", "commit" }, {
		prompt = "Gitbrowse resource type",
	}, function(choice)
		if not choice then return end
		Snacks.gitbrowse.open({ what = choice })
	end)
end, { silent = true, noremap = true, desc = "Browse files in remote Git server" })

vim.keymap.set({ "n" }, "<leader>pf", function()
	Snacks.picker.files({ hidden = true })
end, { silent = true, noremap = true, desc = "Explore files" })

vim.keymap.set({ "n" }, "<leader>ps", function()
	Snacks.picker.lsp_symbols({})
end, { silent = true, noremap = true, desc = "Explore LSP symbols" })

vim.keymap.set({ "n" }, "<leader>pS", function()
	Snacks.picker.lsp_workspace_symbols({})
end, { silent = true, noremap = true, desc = "Explore LSP workspace symbols" })

vim.keymap.set({ "n" }, "<leader>pr", function()
	Snacks.picker.resume()
end, { silent = true, noremap = true, desc = "Resume last picker" })

vim.keymap.set({ "n" }, "<leader>pxh", function()
	Snacks.picker.highlights()
end, { silent = true, noremap = true, desc = "Explore highlight" })

vim.keymap.set({ "n" }, "<leader>pxs", function()
	Snacks.picker.lsp_config()
end, { silent = true, noremap = true, desc = "Explore LSP config" })

vim.keymap.set({ "n" }, "<leader>pxc", function()
	Snacks.picker.colorschemes()
end, { silent = true, noremap = true, desc = "Search colorschemes" })

vim.keymap.set({ "n" }, "<leader>pxi", function()
	Snacks.picker.icons()
end, { silent = true, noremap = true, desc = "Search icons" })

vim.keymap.set({ "n" }, "<leader>pxC", function()
	Snacks.picker.commands()
end, { silent = true, noremap = true, desc = "Search commands" })


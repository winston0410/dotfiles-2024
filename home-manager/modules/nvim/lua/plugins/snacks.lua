local utils = require("custom.utils")
return {
	{
		"folke/snacks.nvim",
		version = "2.x",
		priority = 1000,
		lazy = false,
		dependencies = {},
		keys = {
			{
				-- mnemonic of note
				"<leader>n",
				function()
					Snacks.scratch()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>p<leader>n",
				function()
					Snacks.scratch.select()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>phj",
				function()
					Snacks.picker.jumps()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search jumplist history",
			},
			{
				"<leader>phu",
				function()
					Snacks.picker.undo()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search undo history",
			},
			{
				"<leader>phn",
				function()
					Snacks.picker.notifications({
						confirm = { "copy", "close" },
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search notifications history",
			},
			{
				"<leader>phc",
				function()
					Snacks.picker.command_history()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search command history",
			},
			{
				"<leader>pb",
				function()
					Snacks.picker.buffers()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search buffers",
			},
			{
				"<leader>pc",
				function()
					Snacks.picker.colorschemes()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search colorschemes",
			},
			{
				"<leader>pd",
				function()
					Snacks.picker.diagnostics()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search diagnostics",
			},
			{
				"<leader>pl",
				function()
					-- Snacks.picker.lines()
					local items = {
						{
							text = "Sidebar layout",
							---@type LayoutRuleOpts[]
							value = {
								{
									width = 0.2,
									height = 1,
									allowed = {
										ft = { "oil" },
									},
								},
								{ width = 0.8, height = 1 },
							},
							preview = {
								text = "foo",
							},
						},
					}

					-- Create and show the picker
					require("snacks").picker({
						title = "Pick a Greeting",
						items = items,
						format = "text",
						preview = "preview",
						---@param item { value: LayoutRuleOpts[]}
						confirm = function(picker, item)
							utils.open_layout(item.value)
							picker:close()
						end,
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search lines in buffer",
			},
			{
				"<leader>pgs",
				function()
					Snacks.picker.git_stash()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git Stash",
			},
			{
				"<leader>pgh",
				function()
					Snacks.picker.git_diff()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git Hunks",
			},
			{
				"<leader>pgl",
				function()
					Snacks.picker.git_log({})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git log",
			},
			{
				"<leader>pw",
				function()
					Snacks.picker.grep()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Grep in files",
			},
			{
				"<leader>pw",
				function()
					Snacks.picker.grep_word()
				end,
				mode = { "x" },
				silent = true,
				noremap = true,
				desc = "Grep in files",
			},

			{
				"<leader>pgb",
				function()
					Snacks.picker.git_branches()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git branches",
			},
			{
				"<leader>go",
				function()
					Snacks.gitbrowse.open()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Browse files in remote Git server",
			},
			{
				"<leader>pf",
				function()
					Snacks.picker.files()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Explore files",
			},
			{
				"<leader>pr",
				function()
					Snacks.picker.resume()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Resume last picker",
			},
		},
		config = function()
			local picker_keys = {
				["<2-LeftMouse>"] = "confirm",
				["<leader>k"] = { "qflist", mode = { "n" } },
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
				["?"] = function()
					require("which-key").show({ global = false, loop = true })
				end,
			}
			local config_dir = vim.fn.stdpath("config")
			---@cast config_dir string
			require("snacks").setup({
				toggle = { enabled = true },
				gitbrowse = { enabled = true },
				bigfile = { enabled = true },
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
					sources = {},
					enabled = true,
					ui_select = true,
					layout = {
						cycle = true,
						preset = function()
							return vim.o.columns >= 120 and "default" or "vertical"
						end,
					},
					win = {
						input = {
							keys = picker_keys,
						},
						list = {
							keys = picker_keys,
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
		end,
	},
}

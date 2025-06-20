require("custom.essential")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	rocks = {
		hererocks = false,
	},
	spec = {
		{
			"rose-pine/neovim",
			name = "rose-pine",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"rose-pine.lua",
					"rose-pine-dawn.lua",
				})
				vim.cmd.colorscheme("rose-pine-moon")
			end,
		},
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			version = "2.x",
			---@type Flash.Config
			opts = {
				highlight = {
					backdrop = false,
					matches = true,
				},
			},
			keys = {
				{
					"<leader>f",
					mode = { "n", "x", "o" },
					function()
						require("flash").jump({
							remote_op = {
								restore = true,
								motion = true,
							},
						})
					end,
					noremap = true,
					desc = "Flash",
				},
			},
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			dependencies = {},
			version = "2.22.0",
			keys = {
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
					"<leader>pr",
					function()
						Snacks.picker.resume()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Resume last picker",
				},
				{
					"<leader>pf",
					function()
						Snacks.picker.explorer({
							auto_close = false,
							jump = { close = false },
							win = {
								list = {
									keys = {
										["-"] = "explorer_up",
										["+"] = "explorer_focus",
										["<cr>"] = "confirm",
										["zc"] = "explorer_close",
										["zC"] = "explorer_close_all",
										-- NOTE Missing action that would open all directories, and we should assign zo and zO to it
										["d"] = "explorer_del",
										["c"] = "explorer_rename",
										["y"] = { "explorer_yank", mode = { "n", "x" } },
										["p"] = "explorer_paste",
										-- Use copy here, until there is a new action allows creating a new empty files or dir
										["o"] = "explorer_copy",
										["gx"] = "explorer_open",
										["<a-i>"] = "toggle_ignored",
										["<a-h>"] = "toggle_hidden",
										["]gh"] = "explorer_git_next",
										["[gh"] = "explorer_git_prev",
										["]d"] = "explorer_diagnostic_next",
										["[d"] = "explorer_diagnostic_prev",
										-- NOTE / is searching for files, not sure if we need grep at specific dir
										-- ["<leader>/"] = "picker_grep",
										["<leader>~"] = "tcd",
										-- TODO not sure how to deal with these actions yet
										-- ["m"] = "explorer_move",
									},
								},
							},
						})
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Explore files",
				},
			},
			config = function()
				local picker_keys = {
					["<2-LeftMouse>"] = "confirm",
					["<leader>k"] = { "qflist", mode = { "i", "n" } },
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
				require("snacks").setup({
					gitbrowse = { enabled = true },
					image = { enabled = true },
					picker = {
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
		{
			"chrisgrieser/nvim-spider",
			keys = {
				{
					"W",
					function()
						require("spider").motion("w")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to word",
				},
				{
					"w",
					function()
						require("spider").motion("w")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to word",
				},
				{
					"e",
					function()
						require("spider").motion("e")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to end of word",
				},
				{
					"E",
					function()
						require("spider").motion("e")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to end of word",
				},
				{
					"b",
					function()
						require("spider").motion("b")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump backward to word",
				},
				{
					"B",
					function()
						require("spider").motion("b")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump backward to word",
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
			build = function()
				vim.cmd("TSUpdate")
			end,
			lazy = false,
			priority = 999,
			cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
			config = function()
				local installer = require("nvim-treesitter.install")
				installer.prefer_git = true

				local config = {
					ensure_installed = "all",
					auto_install = false,
					sync_install = false,
					ignore_install = {},
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = false,
							node_incremental = "+",
							node_decremental = "-",
							scope_incremental = false,
						},
					},
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
						priority = {
							["@comment.error"] = 999,
							["@comment.warning"] = 999,
							["@comment.note"] = 999,
							["@comment.todo"] = 999,
							-- ["@comment.info"] = 999,
							-- ["@comment.hint"] = 999,
						},
					},
					indent = { enable = true },
					query_linter = {
						enable = true,
						use_virtual_text = true,
						lint_events = { "BufWrite", "CursorHold" },
					},
					textobjects = {
						select = {
							enable = true,
							lookahead = true,
						},
						move = {
							enable = true,
							set_jumps = true,
						},
					},
				}
				require("nvim-treesitter.configs").setup(config)
			end,
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			version = "3.14.1",
			keys = {
				{
					"?",
					function()
						require("which-key").show({ global = true, loop = true })
					end,
					silent = true,
					noremap = true,
					desc = "Show local keymaps",
				},
			},
			config = function()
				local wk = require("which-key")

				wk.setup({
					preset = "helix",
					plugins = {
						marks = true,
						registers = true,
						spelling = {
							enabled = false,
							suggestions = 20,
						},
						presets = {
							operators = true,
							motions = true,
							text_objects = true,
							windows = true,
							nav = true,
							z = true,
							g = true,
						},
					},
					keys = {
						scroll_down = "<c-n>",
						scroll_up = "<c-p>",
					},
				})
			end,
		},
		{
			"stevearc/oil.nvim",
			version = "2.x",
			lazy = false,
			cmd = { "Oil" },
			keys = {
				{
					"<leader>o",
					function()
						local buf_id = vim.api.nvim_get_current_buf()
						local buf_name = vim.api.nvim_buf_get_name(buf_id)
						local buf_dir = vim.fn.fnamemodify(buf_name, ":h")

						local tab_idx = find_tab_with_filetype("oil")
						if tab_idx == -1 then
							vim.cmd("tabnew | Oil .")
							vim.cmd(string.format("vsplit | Oil %s", buf_dir))
							return
						end
						vim.api.nvim_set_current_tabpage(tab_idx)
					end,
					mode = { "n" },
					noremap = true,
					silent = true,
					desc = "Open Oil.nvim panel",
				},
			},
			config = function()
				local show_detail = false
				local default_columns = {
					"icon",
					"permissions",
				}
				local detail_columns = vim.list_extend(vim.list_slice(default_columns), { "size", "mtime" })
				require("oil").setup({
					default_file_explorer = true,
					columns = default_columns,
					constrain_cursor = "editable",
					watch_for_changes = true,
					keymaps = {
						-- NOTE disable these bindings for now, so we force ourselves to go back to the original tab to open those files, and only use oil.nvim for manipulating files
						["<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false },
							desc = "Select a file",
						},
						-- ["<leader>t<CR>"] = {
						-- 	"actions.select",
						-- 	mode = "n",
						-- 	opts = { close = false, tab = true },
						-- 	desc = "Select a file and open in a new tab",
						-- },
						-- ["<leader>wv<CR>"] = {
						-- 	"actions.select",
						-- 	mode = "n",
						-- 	opts = { close = false, vertical = true },
						-- 	desc = "Select a file and open in a vertical split",
						-- },
						-- ["<leader>ws<CR>"] = {
						-- 	"actions.select",
						-- 	mode = "n",
						-- 	opts = { close = false, horizontal = true },
						-- 	desc = "Select a file and open in a horizontal split",
						-- },
						["~"] = { "actions.cd", mode = "n", desc = "Change current directory of NeoVim" },
						["<a-m>"] = {
							callback = function()
								show_detail = not show_detail
								if show_detail then
									require("oil").set_columns(detail_columns)
								else
									require("oil").set_columns(default_columns)
								end
							end,
							mode = "n",
							desc = "Toggle file detail",
						},
						["<a-h>"] = {
							"actions.toggle_hidden",
							mode = "n",
							desc = "Toggle hidden files",
						},
						["<a-s>"] = { "actions.change_sort", mode = "n" },
						["-"] = { "actions.parent", mode = "n", desc = "Go to parent directory" },
						["q"] = {
							callback = function()
								local tab_idx = find_tab_with_filetype("oil")
								if tab_idx == -1 then
									return
								end
								vim.cmd(string.format("tabclose %s", tab_idx))
							end,
							mode = "n",
							desc = "Quit Oil.nvim panel",
						},
						["gx"] = { "actions.open_external", mode = "n", desc = "Open in external application" },
					},
					use_default_keymaps = false,
					win_options = {
						wrap = true,
					},
					view_options = {
						show_hidden = true,
					},
					skip_confirm_for_simple_edits = true,
					float = {
						border = "none",
					},
				})
				-- REF https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
				vim.api.nvim_create_autocmd("User", {
					pattern = "OilActionsPost",
					callback = function(event)
						if event.data.actions.type == "move" then
							Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
						end
					end,
				})
			end,
			dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
		},
		{
			"nvim-lualine/lualine.nvim",
			event = { "VeryLazy" },
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				local should_show_buffers = function()
					local tab_id = vim.api.nvim_get_current_tabpage()
					local ok, lockbuffer = pcall(function()
						return vim.api.nvim_tabpage_get_var(tab_id, "lockbuffer")
					end)

					if ok then
						return not lockbuffer
					end

					return true
				end
				local utility_filetypes = {
					"terminal",
					"snacks_terminal",
					"oil",
					"trouble",
					"DiffviewFileHistory",
					"DiffviewFiles",
					"snacks_dashboard",
					"snacks_picker_list",
					"snacks_layout_box",
					"snacks_picker_input",
					"snacks_win_backdrop",
					"NeogitStatus",
					"NeogitCommitView",
					"NeogitStashView",
					"NeogitConsole",
					"NeogitLogView",
					"NeogitDiffView",
				}
				require("lualine").setup({
					options = {
						theme = "auto",
						component_separators = "",
						section_separators = "",
						disabled_filetypes = {
							winbar = utility_filetypes,
							inactive_winbar = utility_filetypes,
						},
						always_show_tabline = true,
						globalstatus = true,
					},
					tabline = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {
							{
								"buffers",
								mode = 0,
								icons_enabled = true,
								max_length = function()
									return vim.o.columns / 2
								end,
								filetype_names = {
									checkhealth = "Healthcheck",
									qf = "Quickfix",
								},
								symbols = {
									modified = "[+]",
									alternate_file = "",
								},
								cond = should_show_buffers,
							},
						},
						lualine_x = {
							{
								"tabs",
								mode = 0,
								max_length = function()
									return vim.o.columns / 2
								end,
							},
						},
						lualine_y = {},
						lualine_z = {},
					},
					winbar = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					inactive_winbar = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = {
							"branch",
						},
						lualine_c = {
							{
								"location",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								padding = { left = 1, right = 0 },
							},
							{
								"encoding",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								padding = { left = 1, right = 1 },
							},
							{
								"filesize",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								padding = { left = 1, right = 1 },
							},
							"%=",
							{
								function()
									local current_tab = vim.api.nvim_get_current_tabpage()

									local tab_number = vim.api.nvim_tabpage_get_number(current_tab)
									local cwd = vim.fn.getcwd(-1, tab_number)
									local home = os.getenv("HOME")
									if home then
										cwd = cwd:gsub("^" .. home, "~")
									end
									return cwd
								end,
							},
							"%=",
						},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
				})
			end,
		},
	},
})

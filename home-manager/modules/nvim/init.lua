-- Use space as leader key
vim.g.mapleader = " "

local ERROR_ICON = " "
local WARNING_ICON = " "
local INFO_ICON = " "
local HINT_ICON = "󰌶 "

vim.cmd("filetype on")
vim.filetype.add({
	extension = {
		http = "http",
	},
})

local modes = { "n", "v", "c" }

pcall(function()
	vim.keymap.del(modes, "q:")
	-- NOTE somehow using keymap.del does not work on q:, we need to set <Nop> as well
	vim.keymap.set(modes, "q:", "<Nop>", { noremap = true, silent = true })
	vim.keymap.del(modes, "s", { desc = "Synonym for 'cl' (not linewise)" })
	vim.keymap.del(modes, "S", { desc = "Synonym for 'cc' linewise" })
end)
vim.keymap.set(modes, "<leader>y", '"+y', { silent = true, noremap = true, desc = "Yank text to system clipboard" })
vim.keymap.set(modes, "<leader>p", '"+p', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
vim.keymap.set(modes, "<leader>P", '"+P', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
vim.keymap.set(
	modes,
	"<leader>d",
	'"+d',
	{ silent = true, noremap = true, desc = "Delete text and yank to system clipboard" }
)
-- NOTE make Y consistent with how C and D behave for changing or deleting to the end of the line.
vim.keymap.set(modes, "Y", "y$", {
	silent = true,
	noremap = true,
	desc = "Yanks from the cursor position to the end of the line.",
})
vim.keymap.set({ "i", "n", "v" }, "<Char-0xAE>", "<C-r>", { silent = true, noremap = true, desc = "Redo" })

vim.keymap.set(
	modes,
	"<leader>wv",
	"<cmd>vsplit<cr>",
	{ silent = true, noremap = true, desc = "Create a vertical split" }
)
vim.keymap.set(
	modes,
	"<leader>ws",
	"<cmd>split<cr>",
	{ silent = true, noremap = true, desc = "Create a horizontal split" }
)
vim.keymap.set(modes, "<leader>wq", "<cmd>quit<cr>", { silent = true, noremap = true, desc = "Close a split" })
vim.keymap.set(modes, "<leader>wl", "<C-w>l", { silent = true, noremap = true, desc = "Navigate to left split" })
vim.keymap.set(modes, "<leader>wh", "<C-w>h", { silent = true, noremap = true, desc = "Navigate to right split" })
vim.keymap.set(modes, "<leader>wk", "<C-w>k", { silent = true, noremap = true, desc = "Navigate to top split" })
vim.keymap.set(modes, "<leader>wj", "<C-w>j", { silent = true, noremap = true, desc = "Navigate to bottom split" })

vim.keymap.set(modes, "<leader>tv", "<cmd>tabnew<cr>", { silent = true, noremap = true, desc = "Create a new tab" })
vim.keymap.set(
	modes,
	"<leader>tl",
	"gt",
	{ silent = true, noremap = true, desc = "Go to the next tab page. Wraps around from the last to the first one." }
)
vim.keymap.set(modes, "<leader>th", "gT", {
	silent = true,
	noremap = true,
	desc = "Go to the previous tab page. Wraps around from the first one to the last one.",
})
vim.keymap.set(modes, "<leader>tq", "<cmd>tabclose<cr>", { silent = true, noremap = true, desc = "Close a tab" })

vim.keymap.set(
	modes,
	"<leader>bq",
	"<cmd>bprevious<bar>bdelete #<cr>",
	{ silent = true, noremap = true, desc = "Delete current buffer and switch to prev buffer" }
)
vim.keymap.set(modes, "<leader>bl", "<cmd>bprev<cr>", { silent = true, noremap = true, desc = "Go to previous buffer" })
vim.keymap.set(modes, "<leader>bh", "<cmd>bnext<cr>", { silent = true, noremap = true, desc = "Go to next buffer" })

--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
vim.keymap.set(
	{ "i" },
	"<Esc>",
	"<Esc>`^",
	{ silent = true, noremap = true, desc = "Prevent the cursor move back when returning to normal mode" }
)

vim.keymap.set("n", "<leader>s", ":%s/", { silent = true, noremap = true, desc = "Substitute globally" })
vim.keymap.set("v", "<leader>s", ":s/", { silent = true, noremap = true, desc = "Substitute the selected area" })

vim.keymap.set("v", "p", "pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set("v", "P", "Pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set(
	"i",
	"<esc>",
	"<esc>`^",
	{ silent = true, noremap = true, desc = "Revert back to previous cursor position" }
)

--Quit default plugin early
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_man = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1

local global_options = {
	{ "encoding", "UTF-8" },
	{ "fileencoding", "UTF-8" },
	{ "termguicolors", true },
	{ "mouse", "nvic" },
	{ "timeoutlen", 400 },
	{ "ttimeoutlen", 0 },
	{ "updatetime", 300 },
	{ "showmode", false },
	{ "backup", false },
	{ "writebackup", false },
	{ "cmdheight", 1 },
	{ "showmatch", true },
	{ "splitbelow", true },
	{ "splitright", true },
	{ "lazyredraw", true },
	{ "ignorecase", true },
	{ "smartcase", true },
	{ "magic", true },
	{ "grepprg", "rg --vimgrep --no-heading --smart-case" },
	{ "grepformat", "%f:%l:%c:%m" },
	{ "wildmenu", true },
	{ "wildmode", "longest:full,full" },
	-- NOTE Make it false, so once a buffer is closed with :q, the LSP message will be removed as well
	{ "hidden", false },
	{ "cursorline", true },
}

for _, option in ipairs(global_options) do
	vim.opt[option[1]] = option[2]
end

local window_options = {
	{ "wrap", true },
	{ "linebreak", true },
	{ "number", true },
	{ "relativenumber", true },
	-- at most 2 columns for left hand signcolumn
	{ "signcolumn", "auto:2" },
	{ "scrolloff", 8 },
	-- Ensure tilde signs are not show at the end of buffer
	{ "fillchars", "eob: " },
}

for _, option in ipairs(window_options) do
	vim.o[option[1]] = option[2]
	vim.wo[option[1]] = option[2]
end

local buffer_options = {
	{ "expandtab", true },
	{ "autoindent", true },
	{ "smartindent", false },
	{ "grepprg", "rg --vimgrep --no-heading --smart-case" },
	{ "undofile", true },
	{ "shiftwidth", 4 },
	{ "tabstop", 4 },
}

for _, option in ipairs(buffer_options) do
	vim.o[option[1]] = option[2]
	vim.bo[option[1]] = option[2]
end

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
			"LazyVim/LazyVim",
			version = "13.6.0",
			opts = {
				defaults = {
					autocmds = true,
					keymaps = false,
				},
				news = {
					lazyvim = false,
					neovim = false,
				},
			},
		},
		{
			"folke/tokyonight.nvim",
			commit = "c2725eb6d086c8c9624456d734bd365194660017",
			lazy = false,
			priority = 1000,
			requires = { "nvim-tree/nvim-web-devicons" },
			init = function()
				vim.g.tokyonight_style = "night"
				vim.cmd.colorscheme("tokyonight")
			end,
		},
		{
			"saghen/blink.cmp",
			dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
			version = "0.11.0",
			opts = {
				keymap = {
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
					["<Char-0xAC>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<Char-0xAB>"] = { "select_prev", "fallback" },
					["<CR>"] = { "accept", "fallback" },
				},

				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},

				snippets = { preset = "luasnip" },

				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					-- FIXME enable again once it become stable
					cmdline = {},
				},
				completion = {
					keyword = { range = "full" },
					documentation = {
						auto_show = true,
					},
				},
				signature = { enabled = true },
				fuzzy = {
					prebuilt_binaries = {},
				},
			},
		},
		-- {
		-- 	"gennaro-tedesco/nvim-possession",
		-- 	version = "0.0.15",
		-- 	dependencies = {
		-- 		"ibhagwan/fzf-lua",
		-- 	},
		-- 	opts = {
		-- 		sessions = {
		-- 			sessions_path = vim.fn.stdpath("data") .. "/sessions/",
		-- 			sessions_variable = "session",
		-- 			sessions_icon = "📌",
		-- 			sessions_prompt = "sessions:",
		-- 		},
		-- 		autoload = true,
		-- 		autosave = true,
		-- 	},
		-- 	keys = {
		-- 		{
		-- 			"<leader>sl",
		-- 			function()
		-- 				require("nvim-possession").list()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "List sessions",
		--                silent = true,
		-- 		},
		-- 		{
		-- 			"<leader>sn",
		-- 			function()
		-- 				require("nvim-possession").new()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Create new session",
		--                silent = true,
		-- 		},
		-- 		{
		-- 			"<leader>su",
		-- 			function()
		-- 				require("nvim-possession").update()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Update session",
		--                silent = true,
		-- 		},
		-- 		{
		-- 			"<leader>sd",
		-- 			function()
		-- 				require("nvim-possession").delete()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Delete session",
		--                silent = true,
		-- 		},
		-- 	},
		-- 	init = function()
		-- 		local lfs = require("lfs")
		-- 		local sessionsPath = vim.fn.stdpath("data") .. "/sessions/"
		-- 		local attr = lfs.attributes(sessionsPath)
		--
		-- 		if attr and attr.mode == "directory" then
		-- 			return
		-- 		end
		--
		-- 		local _, err = lfs.mkdir(sessionsPath)
		-- 		if err then
		-- 			vim.notify("failed to create dir for sessions", vim.log.levels.ERROR)
		-- 			vim.notify(err, vim.log.levels.ERROR)
		-- 		end
		-- 	end,
		-- },
		-- {
		-- 	"folke/persistence.nvim",
		-- 	version = "3.1.0",
		-- 	event = "BufReadPre",
		-- 	keys = {
		-- 		-- Load the session for the current directory
		-- 		{
		-- 			"<leader>qs",
		-- 			function()
		-- 				require("persistence").load()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Load session for current directory",
		-- 		},
		--
		-- 		-- Select a session to load
		-- 		{
		-- 			"<leader>qS",
		-- 			function()
		-- 				require("persistence").select()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Select a session to load",
		-- 		},
		--
		-- 		-- Load the last session
		-- 		{
		-- 			"<leader>ql",
		-- 			function()
		-- 				require("persistence").load({ last = true })
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Load the last session",
		-- 		},
		--
		-- 		-- Stop Persistence => session won't be saved on exit
		-- 		{
		-- 			"<leader>qd",
		-- 			function()
		-- 				require("persistence").stop()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Stop Persistence (no save on exit)",
		-- 		},
		-- 	},
		-- 	opts = {
		-- 		dir = vim.fn.stdpath("state") .. "/sessions/",
		-- 		need = 1,
		-- 		branch = true,
		-- 	},
		-- },
		{
			{
				"linrongbin16/lsp-progress.nvim",
				version = "1.0.13",
				event = { "BufReadPre", "BufNewFile" },
				opts = {},
			},
		},
		{
			"yorickpeterse/nvim-window",
			commit = "93af78311e53919a0b13d1bf6d857880bb0b975d",
			keys = {
				{
					"<leader>wf",
					function()
						require("nvim-window").pick()
					end,
					silent = true,
					noremap = true,
					desc = "Jump to window",
				},
			},
			config = function()
				local chars = {} -- a list from a-z
				for i = 97, 122 do
					table.insert(chars, string.char(i))
				end
				require("nvim-window").setup({
					chars = chars,
					normal_hl = "Normal",
					hint_hl = "Bold",
					border = "single",
					render = "float",
				})
			end,
		},
		{
			"chentoast/marks.nvim",
			event = "VeryLazy",
			commit = "bb25ae3f65f504379e3d08c8a02560b76eaf91e8",
			keys = {
				{
					"m",
					function()
						require("marks").set()
					end,
					silent = true,
					noremap = true,
					desc = "Set mark",
				},
				{
					"m,",
					function()
						require("marks").set_next()
					end,
					silent = true,
					noremap = true,
					desc = "Set next available mark",
				},
				{
					"dm",
					function()
						require("marks").delete()
					end,
					silent = true,
					noremap = true,
					desc = "Delete mark",
				},
			},
			opts = {
				default_mappings = false,
				builtin_marks = {
					-- NOTE beginning of last change. This is not reliable, as plugin such as formatter.nvim would reset its location back to line 1
					-- ".",
					"[",
					"]",
					-- beginning of last insert
					"^",
				},
				excluded_filetypes = { "fzf" },
				excluded_buftypes = { "nofile" },
			},
		},
		{
			"nvim-lualine/lualine.nvim",
			commit = "2a5bae925481f999263d6f5ed8361baef8df4f83",
			event = "VeryLazy",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				local colors = require("tokyonight.colors").setup()
				require("lualine").setup({
					options = {
						theme = "tokyonight",
						component_separators = "",
						section_separators = "",
						disabled_filetypes = {
							winbar = { "trouble", "oil", "qf" },
							inactive_winbar = { "trouble", "oil", "qf" },
						},
						always_show_tabline = false,
						globalstatus = true,
					},
					tabline = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {
							{
								"tabs",
								mode = 2,
								max_length = function()
									return vim.o.columns / 2
								end,
								tabs_color = {
									active = "TabLineFill",
									inactive = "TabLine",
								},
							},
						},
					},
					winbar = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {
							{
								"filetype",
								colored = true,
								icon_only = true,
								icon = { align = "left" },
								padding = { left = 1, right = 0 },
							},
							{
								"filename",
								file_status = true,
								path = 3,
								-- color = { fg = colors.fg, bg = colors.bg_statusline },
								color = "TabLineFill",
								padding = 0,
							},
						},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					inactive_winbar = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {
							{
								"filetype",
								colored = false,
								icon_only = true,
								icon = { align = "left" },
								padding = { left = 1, right = 0 },
							},
							{
								"filename",
								file_status = true,
								path = 3,
								-- color = { fg = colors.fg, bg = colors.bg_statusline },
								color = "TabLine",
								padding = 0,
							},
						},
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
						lualine_b = { "branch" },
						lualine_c = { "location", "encoding", "filesize" },
						lualine_x = {},
						lualine_y = {},
						lualine_z = {
							{
								"diagnostics",
								sources = { "nvim_lsp" },
								symbols = {
									error = ERROR_ICON,
									warn = WARNING_ICON,
									info = INFO_ICON,
									hint = HINT_ICON,
								},
								color = { bg = colors.bg_statusline },
							},
							{
								function()
									-- vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
									-- vim.api.nvim_create_autocmd("User", {
									-- 	group = "lualine_augroup",
									-- 	pattern = "LspProgressStatusUpdated",
									-- 	callback = require("lualine").refresh,
									-- })
									return require("lsp-progress").progress({
										format = function(messages)
											local active_clients = vim.lsp.get_clients()
											local client_count = #active_clients
											if #messages > 0 then
												return " LSP:" .. client_count .. " " .. table.concat(messages, " ")
											end
											if #active_clients <= 0 then
												return " LSP:" .. client_count
											else
												local client_names = {}
												for _, client in ipairs(active_clients) do
													if client and client.name ~= "" then
														table.insert(client_names, "[" .. client.name .. "]")
													end
												end
												return " LSP:"
													.. client_count
													.. " "
													.. table.concat(client_names, " ")
											end
										end,
									})
								end,
								color = { fg = colors.fg, bg = colors.bg_statusline },
							},
						},
					},
				})
			end,
		},
		-- Doesn't seems to be useful now, as it does not support winbar. bufferline will only work in the first split, when split or vsplit is being used.
		-- {
		-- 	"akinsho/bufferline.nvim",
		-- 	commit = "261a72b90d6db4ed8014f7bda976bcdc9dd7ce76",
		-- 	dependencies = "nvim-tree/nvim-web-devicons",
		-- 	config = function()
		-- 		require("bufferline").setup({
		-- 			options = {
		-- 				modified_icon = "󰧞",
		-- 				close_icon = "",
		-- 			},
		-- 		})
		-- 	end,
		-- },
		{
			"sindrets/diffview.nvim",
			config = function()
				-- Lua
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
					file_panel = {
						listing_style = "tree",
						tree_options = {
							flatten_dirs = true,
							folder_statuses = "only_folded",
						},
						win_config = {
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
							height = 16,
							win_opts = {},
						},
					},
					commit_log_panel = {
						win_config = {},
					},
					keymaps = {
						disable_defaults = true,
					},
				})
			end,
		},
		{
			"NeogitOrg/neogit",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
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
				disable_hint = true,
				disable_commit_confirmation = true,
				kind = "tab",
				integrations = {
					diffview = true,
				},
				mappings = {
					status = {
						["<enter>"] = "Toggle",
					},
				},
			},
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			version = "3.14.1",
			keys = {
				{
					"?",
					function()
						require("which-key").show({ global = false })
					end,
					silent = true,
					noremap = true,
					desc = "Show local keymaps",
				},
			},
			opts = {
				preset = "helix",
				plugins = {
					marks = true,
					registers = true,
					spelling = {
						enabled = true,
						suggestions = 20,
					},
					presets = {
						operators = true,
						motions = true,
						text_objects = true,
						windows = true,
						nav = true,
						z = false,
						g = false,
					},
				},
				keys = {
					scroll_down = "<c-n>",
					scroll_up = "<c-p>",
				},
			},
		},
		{
			"L3MON4D3/LuaSnip",
			event = "InsertEnter",
			version = "v2.*",
			build = "make install_jsregexp",
			opts = {
				history = true,
				delete_check_events = "TextChanged",
			},
		},
		{
			"mrjones2014/smart-splits.nvim",
			version = "1.7.0",
			keys = {
				{
					"<leader>wL",
					function()
						require("smart-splits").resize_right()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to right",
				},
				{
					"<leader>wH",
					function()
						require("smart-splits").resize_left()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to left",
				},
				{
					"<leader>wK",
					function()
						require("smart-splits").resize_up()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to top",
				},
				{
					"<leader>wJ",
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
			"brenoprata10/nvim-highlight-colors",
			opts = {
				render = "virtual",
				enable_tailwind = true,
				exclude_filetypes = { "lazy" },
				exclude_buftypes = {},
			},
		},
		{
			"lewis6991/gitsigns.nvim",
			version = "0.9.0",
			event = "CursorHold",
			keys = {
				{
					"<leader>gh",
					function()
						require("gitsigns").select_hunk()
					end,
					mode = { "o", "x" },
					silent = true,
					noremap = true,
					desc = "Select hunk",
				},
				{
					"<leader>ghs",
					function()
						require("gitsigns").stage_hunk()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Stage hunk",
				},
				{
					"<leader>ghp",
					function()
						require("gitsigns").preview_hunk()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Preview hunk",
				},
				{
					"<leader>ghr",
					function()
						require("gitsigns").reset_hunk()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Reset hunk",
				},
				{
					"<leader>ghi",
					function()
						require("gitsigns").nav_hunk("next")
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Jump to next hunk",
				},
				{
					"<leader>gho",
					function()
						require("gitsigns").nav_hunk("prev")
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Jump to previous hunk",
				},
			},
			opts = {
				on_attach = function(bufnr)
					local function startsWith(str, prefix)
						return string.sub(str, 1, #prefix) == prefix
					end

					local ft = vim.bo[bufnr].filetype
					if startsWith(ft, "Neogit") or startsWith(ft, "k8s") or ft == "trouble" or ft == "gitcommit" then
						return false
					end
				end,
				current_line_blame = true,
				preview_config = {
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			},
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		-- {
		-- 	"3rd/image.nvim",
		-- 	build = false,
		-- 	ft = { "markdown", "vimwiki", "norg", "typst" },
		-- 	config = function()
		-- 		require("image").setup({
		-- 			backend = "kitty",
		-- 			processor = "magick_cli",
		-- 			integrations = {
		-- 				markdown = {
		-- 					enabled = true,
		-- 					clear_in_insert_mode = false,
		-- 					download_remote_images = true,
		-- 					only_render_image_at_cursor = false,
		-- 					floating_windows = false,
		-- 					filetypes = { "markdown", "vimwiki" },
		-- 				},
		-- 				neorg = {
		-- 					enabled = true,
		-- 					filetypes = { "norg" },
		-- 				},
		-- 				typst = {
		-- 					enabled = true,
		-- 					filetypes = { "typst" },
		-- 				},
		-- 				html = {
		-- 					enabled = false,
		-- 				},
		-- 				css = {
		-- 					enabled = false,
		-- 				},
		-- 			},
		-- 			-- NOTE we rely on neo-img for viewing image
		-- 			hijack_file_patterns = {},
		-- 		})
		-- 	end,
		-- },
		{
			"ramilito/kubectl.nvim",
			cmd = { "Kubectl", "Kubectx", "Kubens" },
			keys = {
				{
					"<leader>k",
					function()
						require("kubectl").toggle({ tab = true })
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open kubectl.nvim panel",
				},
			},
			dependencies = { "folke/snacks.nvim" },
			config = function()
				require("kubectl").setup({
					log_level = vim.log.levels.INFO,
					auto_refresh = {
						enabled = true,
						interval = 300,
					},
					diff = {
						bin = "kubediff",
					},
					kubectl_cmd = { cmd = "kubectl", env = {}, args = {}, persist_context_change = false },
					terminal_cmd = nil,
					namespace = "All",
					namespace_fallback = {},
					hints = true,
					context = true,
					heartbeat = true,
					lineage = {
						enabled = false,
					},
					logs = {
						prefix = true,
						timestamps = true,
						since = "5m",
					},
					alias = {
						apply_on_select_from_history = true,
						max_history = 5,
					},
					filter = {
						apply_on_select_from_history = true,
						max_history = 10,
					},
					float_size = {
						width = 0.9,
						height = 0.8,
						col = 10,
						row = 5,
					},
					obj_fresh = 5,
					skew = {
						enabled = true,
						log_level = vim.log.levels.INFO,
					},
					headers = true,
					completion = { follow_cursor = true },
				})
				local group = vim.api.nvim_create_augroup("kubectl_mappings", { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = group,
					pattern = "k8s_*",
					callback = function(ev)
						local opts = { buffer = ev.buf }
					end,
				})
			end,
		},
		{
			"mistweaverco/kulala.nvim",
			version = "4.10.0",
			ft = { "http", "rest" },
			opts = {
				curl_path = "curl",
				display_mode = "split",
				split_direction = "vertical",
				debug = false,
				winbar = true,
				vscode_rest_client_environmentvars = true,
				disable_script_print_output = false,
				environment_scope = "b",
				urlencode = "always",
				show_variable_info_text = "float",
			},
		},
		-- FIXME seems to be buggy, and it seems to be too intrusive
		-- {
		-- 	"mcauley-penney/visual-whitespace.nvim",
		-- 	config = function()
		-- 		-- https://github.com/mcauley-penney/visual-whitespace.nvim
		-- 		require("visual-whitespace").setup({
		-- 			highlight = { link = "Visual" },
		-- 			space_char = "·",
		-- 			-- tab_char = "→",
		-- 			-- nl_char = "↲",
		-- 			-- cr_char = "←",
		-- 			tab_char = "",
		-- 			nl_char = "",
		-- 			cr_char = "",
		-- 			enabled = true,
		-- 			excluded = {
		-- 				filetypes = {},
		-- 				buftypes = {},
		-- 			},
		-- 		})
		-- 	end,
		-- },
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			dependencies = { "folke/which-key.nvim" },
			keys = {
				{
					"<leader>ghf",
					function()
						Snacks.picker.git_diff()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git Hunks",
				},
				{
					"<leader>f",
					function()
						Snacks.picker.grep()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Grep files",
				},
				{
					"<leader>m",
					function()
						Snacks.picker.files()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Find files",
				},
				{
					"<leader>gb",
					function()
						Snacks.picker.git_branches()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git branches",
				},
				{
					"<leader>gl",
					function()
						Snacks.picker.git_log()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git log",
				},
			},
			config = function()
				local pickerKeys = {
					["<2-LeftMouse>"] = "confirm",
					["<S-CR>"] = { "qflist", mode = { "i", "n" } },
					["<CR>"] = { "confirm", mode = { "n", "i" } },
					-- ["<CR>"] = {
					-- 	function(picker)
					-- 		local selected = picker:selected()
					-- 		if #selected > 0 then
					-- 			return Snacks.picker.actions.qflist()
					-- 		end
					-- 		return Snacks.picker.actions.confirm()
					-- 	end,
					-- 	mode = { "n", "i" },
					-- },
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
						require("which-key").show({ global = false })
					end,
				}
				require("snacks").setup({
					-- dim
					image = { enabled = true },
					dashboard = {
						enabled = true,
						sections = {
							{ section = "header" },
							{
								icon = " ",
								title = "Recent Files",
								section = "recent_files",
								indent = 2,
								padding = { 2, 2 },
							},
							{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
							{ section = "startup" },
						},
					},
					picker = {
						enabled = true,
						ui_select = true,
						win = {
							input = {
								keys = pickerKeys,
							},
							list = {
								keys = pickerKeys,
							},
						},
					},
					scroll = {
						enabled = false,
					},
					input = {
						enabled = true,
					},
					notifier = {
						enabled = true,
						style = "fancy",
					},
					indent = {
						enabled = true,
						char = "│",
						hl = "SnacksIndent",
					},
					words = { enabled = false },
				})
			end,
		},
		{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = "CursorHold" },
		{
			"numToStr/Comment.nvim",
			commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
			dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
			-- FIXME cant really make custom key binding works, 06-12-2024
			keys = { { "<leader>c" }, { "<leader>b" }, { "<leader>c", mode = "v" }, { "<leader>b", mode = "v" } },
			config = function()
				require("Comment").setup({
					padding = true,
					sticky = true,
					post_hook = function() end,
					pre_hook = function()
						---@diagnostic disable-next-line: missing-return
						require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
					end,
					toggler = {
						line = "<leader>cc",
						block = "<leader>bc",
					},
					opleader = {
						line = "<leader>c",
						block = "<leader>b",
					},
				})
			end,
		},
		-- FIXME enable once this issue is resolved https://github.com/petertriho/nvim-scrollbar/issues/34
		-- {
		-- 	"petertriho/nvim-scrollbar",
		-- 	config = function()
		-- 		local colors = require("tokyonight.colors").setup()
		--
		-- 		require("scrollbar").setup({
		-- 			show = true,
		-- 			show_in_active_only = false,
		-- 			set_highlights = true,
		-- 			throttle_ms = 100,
		-- 			handle = {
		-- 				text = " ",
		-- 				blend = 30,
		-- 				color = colors.bg_highlight,
		-- 				highlight = "CursorColumn",
		-- 				hide_if_all_visible = false,
		-- 			},
		-- 			excluded_filetypes = {
		-- 				"dropbar_menu",
		-- 				"dropbar_menu_fzf",
		-- 				"DressingInput",
		-- 				"cmp_docs",
		-- 				"cmp_menu",
		-- 				"noice",
		-- 				"prompt",
		-- 				"TelescopePrompt",
		-- 				"trouble",
		-- 			},
		-- 			marks = {
		-- 				Search = { color = colors.orange },
		-- 				Error = { color = colors.error },
		-- 				Warn = { color = colors.warning },
		-- 				Info = { color = colors.info },
		-- 				Hint = { color = colors.hint },
		-- 				Misc = { color = colors.purple },
		-- 			},
		-- 			handlers = {
		-- 				cursor = true,
		-- 				diagnostic = true,
		-- 				gitsigns = true,
		-- 				handle = true,
		-- 			},
		-- 		})
		-- 	end,
		-- 	dependencies = {
		-- 		"folke/tokyonight.nvim",
		-- 		"lewis6991/gitsigns.nvim",
		-- 	},
		-- },
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {
				max_lines = 5,
			},
			event = "CursorHold",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			commit = "8ebcf62cf48dd97b3d121884ecb6bc4c00f1b069",
		},
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = "CursorHold",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			commit = "9c74db656c3d0b1c4392fc89a016b1910539e7c0",
		},
		{
			"aaronik/treewalker.nvim",
			event = "CursorHold",
			opts = {
				highlight = false,
			},
			keys = {
				{
					"<leader>th",
					"<cmd>Treewalker Left<cr>",
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move left to a Treesitter node",
				},
				{
					"<leader>tl",
					"<cmd>Treewalker Right<cr>",
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move right to a Treesitter node",
				},
				{
					"<leader>tk",
					"<cmd>Treewalker Up<cr>",
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move upward to a Treesitter node",
				},
				{
					"<leader>tj",
					"<cmd>Treewalker Down<cr>",
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move downward to a Treesitter node",
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			commit = "5874cac1b76c97ebb3fc03225bd7215d4e671cd2",
			build = function()
				vim.cmd("TSUpdate")
			end,
			event = "CursorHold",
			cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
			config = function()
				local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
				local installer = require("nvim-treesitter.install")
				installer.prefer_git = true

				---@diagnostic disable-next-line: inject-field
				parser_config.ejs = {
					install_info = {
						branch = "master",
						url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
						files = { "src/parser.c" },
					},
					filetype = "ejs",
					used_by = { "erb" },
				}
				---@diagnostic disable-next-line: inject-field
				parser_config.make = {
					install_info = {
						branch = "main",
						url = "https://github.com/alemuller/tree-sitter-make",
						files = { "src/parser.c" },
					},
					filetype = "make",
					used_by = { "make" },
				}
				pcall(function()
					vim.keymap.del({ "n", "v" }, "x")
				end)
				require("nvim-treesitter.configs").setup({
					ensure_installed = "all",
					auto_install = false,
					sync_install = false,
					ignore_install = {},
					incremental_selection = {
						enable = true,
						keymaps = {
							node_incremental = "+",
							node_decremental = "-",
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
				})
			end,
		},
		{
			"rlane/pounce.nvim",
			commit = "2e36399ac09b517770c459f1a123e6b4b4c1c171",
			keys = {
				{
					"f",
					function()
						require("pounce").pounce()
					end,
					mode = { "n", "v", "o" },
					noremap = true,
					silent = true,
					desc = "Find 1 character forward",
				},
				{
					"F",
					function()
						require("pounce").pounce()
					end,
					mode = { "n", "v", "o" },
					noremap = true,
					silent = true,
					desc = "Find 1 character backward",
				},
			},
			config = function()
				-- wait for tokyonight to support these highlight group
				-- using https://github.com/folke/tokyonight.nvim/blob/355e2842291dbf51b2c5878e9e37281bbef09783/lua/tokyonight/groups/hop.lua#L5
				local c = require("tokyonight.colors").setup()
				vim.api.nvim_set_hl(0, "PounceMatch", {
					link = "Search",
				})
				vim.api.nvim_set_hl(0, "PounceAcceptBest", {
					fg = c.magenta2,
					bg = "none",
					bold = true,
				})
				vim.api.nvim_set_hl(0, "PounceAccept", {
					fg = c.blue2,
					bg = "none",
					bold = true,
				})
				vim.api.nvim_set_hl(0, "PounceUnmatched", {
					fg = c.dark3,
				})
				vim.api.nvim_set_hl(0, "PounceGap", {
					fg = c.dark3,
				})
			end,
		},
		{
			"stevearc/oil.nvim",
			version = "2.14.0",
			cmd = { "Oil" },
			keys = {
				{
					"<leader>o",
					function()
						require("oil").open()
					end,
					mode = { "n" },
					noremap = true,
					silent = true,
					desc = "Open Oil.nvim panel",
				},
			},
			config = function()
				require("oil").setup({
					columns = {
						"icon",
						"permissions",
						-- NOTE wait until these fields to be excluded by constrain_cursor, then enable these fields again
						-- "size",
						-- "mtime",
					},
					constrain_cursor = "editable",
					watch_for_changes = true,
					keymaps = {
						["<CR>"] = { "actions.select", mode = "n", opts = { close = false }, desc = "Select a file" },
						["<leader>t<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false, tab = true },
							desc = "Select a file and open in a new tab",
						},
						["<leader>wv<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false, vertical = true },
							desc = "Select a file and open in a vertical split",
						},
						["<leader>ws<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false, horizontal = true },
							desc = "Select a file and open in a horizontal split",
						},
						["-"] = { "actions.parent", mode = "n", desc = "Go to parent directory" },
						["q"] = {
							"actions.close",
							mode = "n",
							desc = "Quit Oil.nvim panel",
						},
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
		-- NOTE just a plugin for fun, maybe later
		-- {
		-- 	"Isrothy/neominimap.nvim",
		-- 	version = "v3.*.*",
		-- 	enabled = true,
		-- 	lazy = false, -- NOTE: NO NEED to Lazy load
		-- 	init = function()
		-- 		vim.opt.wrap = false
		-- 		vim.opt.sidescrolloff = 36 -- Set a large value
		-- 		vim.g.neominimap = {
		-- 			auto_enable = true,
		-- 			-- NOTE to have higher z-index than nvim-treesitter
		-- 			float = { z_index = 11 },
		-- 		}
		-- 	end,
		-- },
		{
			"stevearc/quicker.nvim",
			event = "FileType qf",
			opts = {
				opts = {
					buflisted = false,
					number = false,
					relativenumber = false,
					signcolumn = "auto:2",
					winfixheight = true,
					wrap = true,
				},
				follow = {
					enabled = false,
				},
			},
		},
		{
			"folke/edgy.nvim",
			version = "1.10.2",
			event = "VeryLazy",
			opts = {
				animate = {
					enabled = false,
				},
				wo = {
					winbar = false,
				},
				options = {
					left = { size = 30 },
					bottom = { size = 4 },
					right = { size = 30 },
					top = { size = 10 },
				},
				left = {
					-- NOTE use oil.nvim for create/edit/delete files. For opening file, use picker is a better option
					-- {
					-- 	ft = "oil",
					-- 	size = { width = 0.25 },
					-- },
				},
				right = {
					{
						ft = "trouble",
						title = "LSP Symbols",
						filter = function(_buf, win)
							return vim.w[win].trouble
								and (
									vim.w[win].trouble.mode == "symbols"
									or vim.w[win].trouble.mode == "lsp_document_symbols"
								)
						end,
						size = { width = 0.2 },
					},
				},
				bottom = {
					{
						ft = "trouble",
						title = "Diagnostics",
						filter = function(_buf, win)
							return vim.w[win].trouble and vim.w[win].trouble.mode == "diagnostics"
						end,
						size = { width = 0.5, height = 1 },
					},
					{ ft = "qf", title = "QuickFix", size = { width = 0.5, height = 1 } },
					-- {
					-- 	ft = "trouble",
					-- 	title = "Quickfix",
					-- 	filter = function(_buf, win)
					-- 		return vim.w[win].trouble and vim.w[win].trouble.mode == "qflist"
					-- 	end,
					-- 	size = { width = 0.5, height = 1 },
					-- },
				},
				exit_when_last = true,
			},
			init = function()
				vim.opt.splitkeep = "screen"
			end,
		},
		{
			"stevearc/conform.nvim",
			version = "8.4.0",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			config = function()
				local prettier = { "prettierd", "prettier", stop_after_first = true }
				require("conform").setup({
					formatters_by_ft = {
						html = prettier,
						xml = prettier,
						svg = prettier,
						css = prettier,
						scss = prettier,
						sass = prettier,
						less = prettier,
						javascript = prettier,
						javascriptreact = prettier,
						["javascript.jsx"] = prettier,
						typescript = prettier,
						typescriptreact = prettier,
						["typescript.jsx"] = prettier,
						sh = { "shfmt" },
						zsh = { "shfmt" },
						markdown = prettier,
						json = prettier,
						jsonl = prettier,
						jsonc = prettier,
						json5 = prettier,
						yaml = prettier,
						vue = prettier,
						http = { "kulala_fmt" },
						rest = { "kulala_fmt" },
						toml = { "taplo" },

						lua = { "stylua" },
						teal = { "stylua" },
						python = { "black" },
						rust = { "rustfmt", lsp_format = "fallback" },
						go = { "goimports", "gofmt" },
						nix = { "nixfmt" },
						nginx = { "nginxfmt" },
						ruby = { "rufo" },
						dart = { "dartformat" },
						haskell = { "hindent" },
						kotlin = { "ktlint" },
						cpp = { "clang_format" },
						c = { "clang_format" },
						cs = { "clang_format" },
						swift = { "swift_format" },
						r = { "styler" },
						elm = { "elm-format" },
						elixir = { "mix" },
						sql = { "pg_format" },
						tf = { "hcl" },
						ini = { "inifmt" },
						dosini = { "inifmt" },
						dhall = { "dhall_format" },
						fennel = { "fnlfmt" },
						-- copied from formatter.nvim
						-- 				pug = {
						-- 					prettier({
						-- 						"--plugin-search-dir=.",
						-- 						"--plugin=plugin-pug",
						-- 					}),
						-- 					--  Falling back with system plugin
						-- 					prettier({
						-- 						"--plugin-search-dir=$XDG_DATA_HOME/prettier",
						-- 						"--plugin=plugin-pug",
						-- 					}),
						-- 				},
						nunjucks = { "njkfmt" },
						liquid = { "liquidfmt" },
						nim = { "nimpretty" },
						mint = { "mintfmt" },
					},
					default_format_opts = {
						lsp_format = "fallback",
					},
					format_on_save = { timeout_ms = 500 },
					formatters = {},
				})
			end,
			init = function()
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			end,
		},
		{
			"vyfor/cord.nvim",
			build = ":Cord update",
			opts = {
				timestamp = {
					enabled = true,
					reset_on_idle = false,
					reset_on_change = false,
				},
				editor = {
					client = "neovim",
					tooltip = "Hugo's ultimate editor",
				},
			},
		},
		{
			"neovim/nvim-lspconfig",
			version = "1.6.0",
			-- Reference the lazyload event from LazyVim
			-- REF https://github.com/LazyVim/LazyVim/blob/86ac9989ea15b7a69bb2bdf719a9a809db5ce526/lua/lazyvim/plugins/lsp/init.lua#L5
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local lspconfig = require("lspconfig")
				local util = require("lspconfig.util")

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				-- REF https://github.com/hrsh7th/nvim-cmp/issues/373
				-- capabilities.textDocument.completion.completionItem.snippetSupport = false
				capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

				-- REF https://github.com/neovim/nvim-lspconfig/blob/d0467b9574b48429debf83f8248d8cee79562586/doc/server_configurations.md#denols
				vim.g.markdown_fenced_languages = {
					"ts=typescript",
				}

				local servers = {
					"rust_analyzer",
					"astro",
					"beancount",
					"solang",
					"solargraph",
					"theme_check",
					"taplo",
					"mint",
					"bicep",
					"ansiblels",
					"vala_ls",
					"jdtls",
					"groovyls",
					"lemminx",
					"html",
					"cssls",
					"jsonls",
					"jsonnet_ls",
					"leanls",
					"dhall_lsp_server",
					"hls",
					"dartls",
					"terraformls",
					"texlab",
					"tilt_ls",
					"ccls",
					"svelte",
					"graphql",
					"elmls",
					"ocamlls",
					"puppet",
					"serve_d",
					"gdscript",
					"scry",
					-- enable later when we work on ember project
					-- "ember",
					"eslint",
					"angularls",
					"bashls",
					"hhvm",
					"prismals",
					"gopls",
					"docker_compose_language_service",
					"glsl_analyzer",
					"gradle_ls",
					"nimls",
					"metals",
					"julials",
					"purescriptls",
					"rescriptls",
					"racket_langserver",
					"pasls",
					"yamlls",
					"postgres_lsp",
					-- use postgres_lsp for now
					-- "sqlls",
					"vimls",
					"nixd",
					"r_language_server",
					"kotlin_language_server",
					"cmake",
					"pyright",
					"taplo",
					"cucumber_language_server",
					"slint_lsp",
					"regal",
					-- nix does not provide this package yet
					-- "snyk-ls",
					"ballerina",
					"bitbake_ls",
					"ltex",
					"csharp_ls",
				}

				for _, server in ipairs(servers) do
					lspconfig[server].setup({
						on_init = function(client)
							-- FIXME seems to be able to prevent LSP from highlighting
							client.server_capabilities.semanticTokensProvider = nil
						end,
						capabilities = capabilities,
					})
				end

				lspconfig.elixirls.setup({
					cmd = { "elixir-ls" },
					capabilities = capabilities,
				})

				lspconfig.kulala_ls.setup({
					capabilities = capabilities,
					filetypes = { "http", "rest" },
				})

				lspconfig.dockerls.setup({
					capabilities = capabilities,
					settings = {
						docker = {
							languageserver = {
								formatter = {
									ignoreMultilineInstructions = true,
								},
							},
						},
					},
				})

				lspconfig.ts_ls.setup({
					init_options = {
						--   plugins = {
						-- 	{
						-- 	  name = "@vue/typescript-plugin",
						-- 	  location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
						-- 	  languages = {"javascript", "typescript", "vue"},
						-- 	},
						--   },
					},
					filetypes = {
						"javascript",
						"typescript",
						--   "vue",
					},
				})

				-- it only works if deno.json is at the root level
				lspconfig.denols.setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("deno.json", "deno.jsonc"),
				})

				lspconfig.lua_ls.setup({
					diagnostics = {
						underline = true,
						update_in_insert = false,
						severity_sort = true,
					},
					capabilities = capabilities,
					on_init = function(client)
						-- FIXME seems to be able to prevent LSP from highlighting
						client.server_capabilities.semanticTokensProvider = nil

						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (
									vim.loop.fs_stat(path .. "/.luarc.json")
									or vim.loop.fs_stat(path .. "/.luarc.jsonc")
								)
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {},
							},
						})
					end,
					settings = {
						Lua = {
							diagnostics = {
								globals = {},
							},
							telemetry = {
								enable = false,
							},
							hint = { enable = true },
						},
					},
					inlay_hints = {
						enabled = true,
						exclude = {},
					},
					codelens = {
						enabled = true,
					},
					document_highlight = {
						enabled = true,
					},
				})
			end,
		},
		{
			"m00qek/baleia.nvim",
			version = "*",
			cmd = { "BaleiaColorize", "BaleiaLogs" },
			config = function()
				vim.g.baleia = require("baleia").setup({})

				vim.api.nvim_create_user_command("BaleiaColorize", function()
					local bufId = tonumber(vim.api.nvim_get_current_buf())
					if bufId == nil then
						vim.notify("Unable to find current buffer handle", vim.log.levels.ERROR)
						return
					end
					---@diagnostic disable-next-line: param-type-mismatch
					vim.g.baleia.once(bufId)
				end, { bang = true })

				vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
			end,
		},
		{
			"folke/trouble.nvim",
			version = "3.7.0",
			event = { "BufReadPre", "BufNewFile" },
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
		{ "echasnovski/mini.icons", version = false },
	},
})
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local supported_modes = { "n", "v" }
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.keymap.set(
			supported_modes,
			"<leader>li",
			vim.lsp.buf.implementation,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Jump to implementation" }
		)
		vim.keymap.set(supported_modes, "<leader>lh", function()
			-- if we call twice, we will enter the hover windows immediately after running the keybinding
			vim.lsp.buf.hover()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show hover tips" })
		vim.keymap.set(
			supported_modes,
			"<leader>ldd",
			vim.lsp.buf.definition,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Jump to definition" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>ldt",
			vim.lsp.buf.type_definition,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Jump to type definition" }
		)
		-- vim.keymap.set(
		-- 	supported_modes,
		-- 	"<leader>lr",
		-- 	vim.lsp.buf.rename,
		-- 	{ silent = true, noremap = true, buffer = ev.buf, desc = "Rename variable" }
		-- )
		vim.keymap.set(
			supported_modes,
			"<leader>la",
			vim.lsp.buf.code_action,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Apply code action" }
		)
		pcall(function()
			-- Remove default keybinding added by lspconfig
			-- REF https://neovim.io/doc/user/lsp.html#lsp-config
			vim.keymap.del({ "n" }, "K", { buffer = ev.buf })
		end)
		vim.diagnostic.config({
			virtual_text = false,
			signs = false,
			-- FIXME: cannot customize the icon, without not showing it in signcolumn
			-- signs = {
			-- 	text = {
			-- 		[vim.diagnostic.severity.ERROR] = ERROR_ICON,
			-- 		[vim.diagnostic.severity.WARN] = WARNING_ICON,
			-- 		[vim.diagnostic.severity.INFO] = INFO_ICON,
			-- 		[vim.diagnostic.severity.HINT] = HINT_ICON,
			-- 	},
			-- },
			update_in_insert = false,
		})
	end,
})

-- TODO how can I always open helpfiles in a tab?

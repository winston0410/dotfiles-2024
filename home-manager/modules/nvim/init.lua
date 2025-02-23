-- Config principle
-- 1. Following the verb -> noun convention for defining mappings
-- 2. Following the default Vim's mapping semantic and enhance it

-- Use space as leader key
vim.g.mapleader = " "
-- Need to find plugin to improve mouse experience, to create something like vscode
-- FIXME vim.opt is overriding value in vim.o. This is likely a bug in Neovim
vim.o.mouse = "a"
vim.o.mousefocus = true

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

---@param filetype string A Nvim filetype
---@return number
local function find_tab_with_filetype(filetype)
	for i, tab_id in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab_id)) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if buf_ft == filetype then
				return i
			end
		end
	end
	return -1
end

local modes = { "n", "v", "c" }

vim.keymap.set("n", "q:", "<Nop>", { noremap = true, silent = true })
-- useless synonym of cc
vim.keymap.set({ "n" }, "s", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "S", "<Nop>", { noremap = true, silent = true })

vim.keymap.set({ "n" }, "[z", "zj", { silent = true, noremap = true, desc = "Jump to previous fold" })
vim.keymap.set({ "n" }, "]z", "zk", { silent = true, noremap = true, desc = "Jump to next fold" })

-- NOTE no longer need these bindings, just use register correctly
-- vim.keymap.set(modes, "<leader>y", '"+y', { silent = true, noremap = true, desc = "Yank text to system clipboard" })
-- vim.keymap.set(modes, "<leader>p", '"+p', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
-- vim.keymap.set(modes, "<leader>P", '"+P', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
-- vim.keymap.set(
-- 	modes,
-- 	"<leader>d",
-- 	'"+d',
-- 	{ silent = true, noremap = true, desc = "Delete text and yank to system clipboard" }
-- )

-- NOTE make Y consistent with how C and D behave for changing or deleting to the end of the line.
vim.keymap.set(modes, "Y", "y$", {
	silent = true,
	noremap = true,
	desc = "Yanks from the cursor position to the end of the line.",
})

vim.keymap.set(modes, "<leader>wv", function()
	vim.cmd("vsplit")
end, { silent = true, noremap = true, desc = "Create a vertical split" })
vim.keymap.set(modes, "<leader>ws", function()
	vim.cmd("split")
end, { silent = true, noremap = true, desc = "Create a horizontal split" })
vim.keymap.set(modes, "<leader>wq", function()
	vim.cmd("quit")
end, { silent = true, noremap = true, desc = "Close a split" })
vim.keymap.set(modes, "<leader>wl", "<C-w>l", { silent = true, noremap = true, desc = "Navigate to left split" })
vim.keymap.set(modes, "<leader>wh", "<C-w>h", { silent = true, noremap = true, desc = "Navigate to right split" })
vim.keymap.set(modes, "<leader>wk", "<C-w>k", { silent = true, noremap = true, desc = "Navigate to top split" })
vim.keymap.set(modes, "<leader>wj", "<C-w>j", { silent = true, noremap = true, desc = "Navigate to bottom split" })

vim.keymap.set(modes, "<leader>tv", function()
	vim.cmd("tabnew")
end, { silent = true, noremap = true, desc = "Create a new tab" })
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
vim.keymap.set(modes, "<leader>tq", function()
	vim.cmd("tabclose")
end, { silent = true, noremap = true, desc = "Close a tab" })
for i = 1, 9 do
	vim.keymap.set({ "n" }, "<leader>t" .. i, function()
		vim.cmd(string.format("tabn %s", i))
	end, { noremap = true, silent = true, desc = string.format("Jump to tab %s", i) })
end

vim.keymap.set(modes, "<leader>bq", function()
	vim.cmd("bprevious | bdelete #")
end, { silent = true, noremap = true, desc = "Delete current buffer and switch to prev buffer" })
vim.keymap.set(modes, "<leader>bl", function()
	vim.cmd("bnext")
end, { silent = true, noremap = true, desc = "Go to next buffer" })
vim.keymap.set(modes, "<leader>bh", function()
	vim.cmd("bprev")
end, { silent = true, noremap = true, desc = "Go to previous buffer" })

--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
vim.keymap.set(
	{ "i" },
	"<Esc>",
	"<Esc>`^",
	{ silent = true, noremap = true, desc = "Prevent the cursor move back when returning to normal mode" }
)

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
-- silent provider warning
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local global_options = {
	{ "encoding", "UTF-8" },
	{ "fileencoding", "UTF-8" },
	{ "termguicolors", true },
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
	-- NOTE disable cursorline in background as it would be shown in inactive split as well, not really useful when using splits
	{ "cursorlineopt", "number" },
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
	-- Ensure tilde signs are not show at the end of buffer, and use diagonal as filler for diff
	-- REF https://github.com/sindrets/diffview.nvim/issues/35#issuecomment-871455517
	{ "fillchars", "diff:╱,eob: " },
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

if vim.wo.diff then
	-- disable wrap so filler line will always align with changes
	vim.o.wrap = false
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
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			requires = { "nvim-tree/nvim-web-devicons" },
			init = function()
				vim.g.tokyonight_style = "night"
				vim.cmd.colorscheme("tokyonight")
			end,
		},
		{
			"jackplus-xyz/player-one.nvim",
			enabled = false,
			opts = {},
		},
		{
			"kevinhwang91/nvim-ufo",
			version = "1.4.0",
			dependencies = { "kevinhwang91/promise-async" },
			cmd = {
				"UfoEnable",
				"UfoDisable",
				"UfoInspect",
				"UfoAttach",
				"UfoDetach",
				"UfoEnableFold",
				"UfoDisableFold",
			},
			keys = {
				{
					"zR",
					function()
						require("ufo").openAllFolds()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open all folds",
				},
				{
					"zM",
					function()
						require("ufo").closeAllFolds()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Close all folds",
				},
			},
			event = "VeryLazy",
			init = function()
				vim.o.foldcolumn = "0"
				vim.o.foldlevel = 99
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true
			end,
			config = function()
				require("ufo").setup({
					open_fold_hl_timeout = 500,
					close_fold_kinds_for_ft = { default = {} },
					enable_get_fold_virt_text = false,
					provider_selector = function()
						return { "treesitter", "indent" }
					end,
					preview = {
						win_config = {
							border = "rounded",
							winblend = 12,
							winhighlight = "Normal:Normal",
							maxheight = 20,
						},
						mappings = {
							close = "q",
						},
					},
				})
			end,
		},
		{
			"saghen/blink.cmp",
			event = "InsertEnter",
			dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
			version = "0.12.0",
			opts = {
				keymap = {
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
					["<Char-0xAC>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<Char-0xAB>"] = { "select_prev", "fallback" },
					["<CR>"] = { "accept", "fallback" },
					-- NOTE mimick the behavior for vscode
					["<S-Tab>"] = { "select_prev", "fallback" },
					["<Tab>"] = { "select_next", "fallback" },
				},

				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},

				snippets = { preset = "luasnip" },

				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					min_keyword_length = function(ctx)
						-- only applies when typing a command, doesn't apply to arguments
						if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
							return 3
						end
						return 0
					end,
				},
				completion = {
					menu = {
						auto_show = function(ctx)
							return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
						end,
					},
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
		{
			"xemptuous/sqlua.nvim",
			cmd = "SQLua",
			config = function()
				require("sqlua").setup({
					keybinds = {
						execute_query = "<cr>",
						activate_db = "<cr>",
					},
				})
			end,
		},
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

				local utility_filetypes = {
					"oil",
					"trouble",
					"qf",
					"DiffviewFileHistory",
					"DiffviewFiles",
					"snacks_dashboard",
					"NeogitStatus",
					"NeogitConsole",
					"NeogitLogView",
					"NeogitDiffView",
				}
				require("lualine").setup({
					options = {
						theme = "tokyonight",
						component_separators = "",
						section_separators = "",
						disabled_filetypes = {
							winbar = utility_filetypes,
							inactive_winbar = utility_filetypes,
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
								fmt = function(name, context)
									local ok, result = pcall(function()
										return vim.api.nvim_tabpage_get_var(context.tabnr, "tabtitle")
									end)

									local tab_title = ""

									if ok then
										tab_title = result
									end

									if tab_title ~= "" then
										return tab_title
									end

									return name
								end,
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
						lualine_c = {
							{
								"location",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
							},
							{
								"encoding",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
							},
							{
								"filesize",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
							},
						},
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
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
							},
							{
								function()
									local active_clients = vim.lsp.get_clients()
									local client_count = #active_clients
									if #active_clients <= 0 then
										return " LSP:" .. client_count
									else
										local client_names = {}
										for _, client in ipairs(active_clients) do
											if client and client.name ~= "" then
												table.insert(client_names, "[" .. client.name .. "]")
											end
										end
										return " LSP:" .. client_count .. " " .. table.concat(client_names, " ")
									end
								end,
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								color = { fg = colors.fg, bg = colors.bg_statusline },
							},
						},
					},
				})
			end,
		},
		{
			"nvzone/minty",
			enabled = false,
			cmd = { "Shades", "Huefy" },
		},
		-- Doesn't seems to be useful now, as it does not support winbar. bufferline will only work in the first split, when split or vsplit is being used.
		{
			"akinsho/bufferline.nvim",
			commit = "261a72b90d6db4ed8014f7bda976bcdc9dd7ce76",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			enabled = false,
			config = function()
				require("bufferline").setup({
					options = {
						modified_icon = "󰧞",
						close_icon = "",
					},
				})
			end,
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
					file_panel = {
						listing_style = "tree",
						tree_options = {
							flatten_dirs = true,
							folder_statuses = "never",
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
							{
								"n",
								"<leader>ed",
								actions.cycle_layout,
								{ desc = "Cycle through available layouts." },
							},
							{
								"n",
								"<leader>ee",
								actions.toggle_files,
								{ desc = "Toggle the file panel." },
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

				local autocmd_callback = function(_)
					vim.api.nvim_set_option_value("foldcolumn", "0", { scope = "local" })
					vim.api.nvim_set_option_value("wrap", false, { scope = "local" })

					require("which-key").add({
						{ "[c", desc = "Jump to previous change", mode = "n" },
						{ "]c", desc = "Jump to next change", mode = "n" },
					})
				end

				vim.api.nvim_create_autocmd("User", {
					pattern = "DiffviewDiffBufRead",
					callback = autocmd_callback,
				})
				vim.api.nvim_create_autocmd("User", {
					pattern = "DiffviewDiffBufWinEnter",
					callback = autocmd_callback,
				})
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "DiffviewFileHistory",
					callback = function()
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFileHistory")
					end,
				})
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "DiffviewFiles",
					callback = function()
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFiles")
					end,
				})
			end,
		},
		-- NOTE doesn't seems to be particularly useful. qa ... Q seems to be good enough for me
		{
			"chrisgrieser/nvim-recorder",
			dependencies = { "folke/snacks.nvim" },
			enabled = false,
			opts = {},
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
			},
			keys = {
				{
					"<leader>og",
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
				-- FIXME range diffing is not working correctly, cannot select to
				disable_hint = true,
				disable_commit_confirmation = true,
				graph_style = "unicode",
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
						require("which-key").show({ global = true, loop = true })
					end,
					silent = true,
					noremap = true,
					desc = "Show local keymaps",
				},
			},
			config = function()
				local wk = require("which-key")
				local ignored_bindings = {
					"z<CR>",
					"z=",
					"zH",
					"zL",
					"zb",
					"ze",
					"zg",
					"zs",
					"zt",
					"zv",
					"zw",
					"zz",
					-- NOTE ignored as we don't use regular f,t
					",",
					";",
					-- NOTE ignored as this is a synonym
					"&",
					-- NOTE default binding set by neovim that does not use treesitter
					"[m",
					"]m",
					"[M",
					"]M",
					-- NOTE for checking misspelled word, we can use latex-lsp to highlight, and then jump with [d and ]d
					"[s",
					"]s",
				}

				wk.setup({
					preset = "helix",
					---@param mapping wk.Mapping
					filter = function(mapping)
						return not vim.list_contains(ignored_bindings, mapping.lhs)
					end,
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
							g = false,
						},
					},
					keys = {
						scroll_down = "<c-n>",
						scroll_up = "<c-p>",
					},
				})
				-- wk.add({
				-- 	{ "<leader>c", group = "Comment management" },
				-- 	{ "<leader>s", group = "LSP and Treesitter" },
				-- 	{ "<leader>t", group = "Tabs management" },
				-- 	{ "<leader>w", group = "Windows management" },
				-- 	{ "<leader>b", group = "Buffers management" },
				-- 	{ "<leader>g", group = "Git management" },
				-- 	{ "<leader>f", group = "File search" },
				-- })
				if vim.wo.diff then
					wk.add({
						{ "[c", desc = "Jump to previous change", mode = "n" },
						{ "]c", desc = "Jump to next change", mode = "n" },
					})
				end
			end,
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
		-- NOTE not sure if we need this
		{
			"mrjones2014/smart-splits.nvim",
			version = "1.7.0",
			enabled = false,
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
			event = "VeryLazy",
			opts = {
				render = "virtual",
				enable_tailwind = true,
				exclude_filetypes = { "lazy", "checkhealth", "snacks_dashboard" },
				exclude_buftypes = {},
			},
		},
		{
			"lewis6991/gitsigns.nvim",
			version = "0.9.0",
			event = { "VeryLazy" },
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
					"]gh",
					function()
						require("gitsigns").nav_hunk("next")
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Jump to next hunk",
				},
				{
					"[gh",
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
				signcolumn = false,
				linehl = true,
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
		{
			"ramilito/kubectl.nvim",
			cmd = { "Kubectl", "Kubectx", "Kubens" },
			keys = {
				{
					"<leader>ok",
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
					callback = function()
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "Kubectl")
					end,
				})
			end,
		},
		{
			"mistweaverco/kulala.nvim",
			version = "4.11.0",
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
					"<leader>fl",
					function()
						Snacks.picker.lines()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search lines in buffer",
				},
				{
					"<leader>fgh",
					function()
						Snacks.picker.git_diff()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git Hunks",
				},
				{
					"<leader>fw",
					function()
						Snacks.picker.grep()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Grep in files",
				},
				{
					"<leader>ff",
					function()
						Snacks.picker.files()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Find files",
				},
				{
					"<leader>fn",
					function()
						Snacks.picker.treesitter({
							filter = {
								-- default = true,
							},
						})
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Find Treesitter nodes",
				},
				{
					"<leader>fs",
					function()
						Snacks.picker.lsp_workspace_symbols()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Find LSP workspace symbols",
				},
				{
					"<leader>fgb",
					function()
						Snacks.picker.git_branches()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git branches",
				},
				{
					"<leader>fgl",
					function()
						Snacks.picker.git_log()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git log",
				},
				{
					"<leader>ogr",
					function()
						Snacks.gitbrowse.open()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Browse files in remote Git server",
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
						require("which-key").show({ global = false, loop = true })
					end,
				}
				local config_dir = vim.fn.stdpath("config")
				---@cast config_dir string
				require("snacks").setup({
					toggle = { enabled = true },
					gitbrowse = { enabled = true },
					bigfile = { enabled = false },
					-- dim
					image = { enabled = true },
					dashboard = {
						enabled = true,
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
								keys = pickerKeys,
							},
							list = {
								keys = pickerKeys,
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
						char = "│",
						hl = "SnacksIndent",
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
		{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = { "VeryLazy" } },
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
		{
			"petertriho/nvim-scrollbar",
			-- FIXME enable once this issue is resolved https://github.com/petertriho/nvim-scrollbar/issues/34
			enabled = false,
			config = function()
				local colors = require("tokyonight.colors").setup()

				require("scrollbar").setup({
					show = true,
					show_in_active_only = false,
					set_highlights = true,
					throttle_ms = 100,
					handle = {
						text = " ",
						blend = 30,
						color = colors.bg_highlight,
						highlight = "CursorColumn",
						hide_if_all_visible = false,
					},
					excluded_filetypes = {
						"dropbar_menu",
						"dropbar_menu_fzf",
						"DressingInput",
						"cmp_docs",
						"cmp_menu",
						"noice",
						"prompt",
						"TelescopePrompt",
						"trouble",
					},
					marks = {
						Search = { color = colors.orange },
						Error = { color = colors.error },
						Warn = { color = colors.warning },
						Info = { color = colors.info },
						Hint = { color = colors.hint },
						Misc = { color = colors.purple },
					},
					handlers = {
						cursor = true,
						diagnostic = true,
						gitsigns = true,
						handle = true,
					},
				})
			end,
			dependencies = {
				"folke/tokyonight.nvim",
				"lewis6991/gitsigns.nvim",
			},
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			event = { "VeryLazy" },
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
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
		-- NOTE it is a bit intrusive and noisy, disable for now
		{
			"tzachar/highlight-undo.nvim",
			enabled = false,
			event = "VeryLazy",
			opts = {
				hlgroup = "Visual",
				duration = 500,
				pattern = { "*" },
				ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "snack_dashboard" },
			},
		},
		{
			"aaronik/treewalker.nvim",
			event = "CursorHold",
			-- NOTE not really that accurate
			enabled = false,
			opts = {
				highlight = false,
			},
			keys = {
				{
					"<leader>sh",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Left")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move left to a Treesitter node",
				},
				{
					"<leader>sl",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Right")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move right to a Treesitter node",
				},
				{
					"<leader>sk",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Up")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move upward to a Treesitter node",
				},
				{
					"<leader>sj",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Down")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move downward to a Treesitter node",
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = function()
				vim.cmd("TSUpdate")
			end,
			event = { "VeryLazy" },
			lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
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
				-- NOTE not sure why we need to do that
				pcall(function()
					vim.keymap.del({ "n", "v" }, "x")
				end)

				local select_around_node = function()
					local ts_utils = require("nvim-treesitter.ts_utils")
					local node = ts_utils.get_node_at_cursor()
					if node == nil then
						vim.notify("No Treesitter node found at cursor position", vim.log.levels.WARN)
						return
					end
					local start_row, start_col, end_row, end_col = ts_utils.get_vim_range({ node:range() })

					if start_row > 0 and end_row > 0 then
						vim.api.nvim_buf_set_mark(0, "<", start_row, start_col - 1, {})
						vim.api.nvim_buf_set_mark(0, ">", end_row, end_col - 1, {})
						vim.cmd("normal! gv")
					end
				end

				vim.keymap.set(
					{ "o", "x" },
					"%",
					select_around_node,
					{ silent = true, noremap = true, desc = "Treesitter node" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"a%",
					select_around_node,
					{ silent = true, noremap = true, desc = "Treesitter node" }
				)
				vim.keymap.set({ "n", "v" }, "%", function()
					local ts_utils = require("nvim-treesitter.ts_utils")
					local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))

					local node = ts_utils.get_node_at_cursor()

					if node == nil then
						vim.notify("No Treesitter node found at cursor position", vim.log.levels.WARN)
						return
					end
					vim.notify(string.format("type of node is %s", node:type()), vim.log.levels.DEBUG)

					local start_row, start_col, end_row, end_col = ts_utils.get_vim_range({ node:range() })

					-- -- decide which position is further away from current cursor position, and jump to there
					-- -- simple algo, row is always compared before column
					local start_row_diff = math.abs(cur_row - start_row)
					local end_row_diff = math.abs(end_row - cur_row)

					local target_row = start_row
					local target_col = start_col

					if end_row_diff == start_row_diff then
						if math.abs(end_col - cur_col) > math.abs(cur_col - start_col) then
							target_row = end_row
							target_col = end_col
						end
					else
						if end_row_diff > start_row_diff then
							target_row = end_row
							target_col = end_col
						end
					end
					vim.api.nvim_win_set_cursor(0, { target_row, target_col - 1 })
				end, { silent = true, noremap = true, desc = "Jump between beginning and end of the node" })

				local function_textobj_binding = "f"
				local call_textobj_binding = "k"
				local conditional_textobj_binding = "i"
				local return_textobj_binding = "r"
				local parameter_textobj_binding = "p"
				local assignment_lhs_textobj_binding = "al"
				local assignment_rhs_textobj_binding = "ar"
				local block_textobj_binding = "b"
				local comment_textobj_binding = "n"
				local prev_next_binding = {
					{ lhs = "[", desc = "Jump to previous %s" },
					{ lhs = "]", desc = "Jump to next %s" },
				}
				local select_around_binding = {
					{ lhs = "a", desc = "Select around %s" },
				}
				local select_inside_binding = {
					{ lhs = "i", desc = "Select inside %s" },
				}

				local enabled_ts_nodes = {
					["@block.inner"] = {
						move = {},
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. block_textobj_binding,
								desc = string.format(entry.desc, "block"),
							}
						end, select_inside_binding),
					},
					["@block.outer"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. block_textobj_binding,
								desc = string.format(entry.desc, "block"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. block_textobj_binding,
								desc = string.format(entry.desc, "block"),
							}
						end, select_around_binding),
					},
					["@comment.inner"] = {
						move = {},
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. comment_textobj_binding,
								desc = string.format(entry.desc, "comment"),
							}
						end, select_inside_binding),
					},
					["@comment.outer"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. comment_textobj_binding,
								desc = string.format(entry.desc, "comment"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. comment_textobj_binding,
								desc = string.format(entry.desc, "comment"),
							}
						end, select_around_binding),
					},
					["@return.inner"] = {
						move = {},
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. return_textobj_binding,
								desc = string.format(entry.desc, "return statement"),
							}
						end, select_inside_binding),
					},
					["@return.outer"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. return_textobj_binding,
								desc = string.format(entry.desc, "return statement"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. return_textobj_binding,
								desc = string.format(entry.desc, "return statement"),
							}
						end, select_around_binding),
					},
					["@conditional.inner"] = {
						move = {},
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. conditional_textobj_binding,
								desc = string.format(entry.desc, "conditional"),
							}
						end, select_inside_binding),
					},
					["@conditional.outer"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. conditional_textobj_binding,
								desc = string.format(entry.desc, "conditional"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. conditional_textobj_binding,
								desc = string.format(entry.desc, "conditional"),
							}
						end, select_around_binding),
					},
					["@parameter.inner"] = {
						move = {},
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. parameter_textobj_binding,
								desc = string.format(entry.desc, "parameter"),
							}
						end, select_inside_binding),
					},
					["@parameter.outer"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. parameter_textobj_binding,
								desc = string.format(entry.desc, "parameter"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. parameter_textobj_binding,
								desc = string.format(entry.desc, "parameter"),
							}
						end, select_around_binding),
					},
					["@function.inner"] = {
						move = {},
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. function_textobj_binding,
								desc = string.format(entry.desc, "function"),
							}
						end, select_inside_binding),
					},
					["@function.outer"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. function_textobj_binding,
								desc = string.format(entry.desc, "function"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. function_textobj_binding,
								desc = string.format(entry.desc, "function"),
							}
						end, select_around_binding),
					},
					["@call.inner"] = {
						move = {},
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. call_textobj_binding,
								desc = string.format(entry.desc, "call"),
							}
						end, select_inside_binding),
					},
					["@call.outer"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. call_textobj_binding,
								desc = string.format(entry.desc, "call"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. call_textobj_binding,
								desc = string.format(entry.desc, "call"),
							}
						end, select_around_binding),
					},
					["@assignment.lhs"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. assignment_lhs_textobj_binding,
								desc = string.format(entry.desc, "lhs of assignment"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. assignment_lhs_textobj_binding,
								desc = string.format(entry.desc, "lhs of assignment"),
							}
						end, vim.list_extend(vim.list_extend({}, select_around_binding), select_inside_binding)),
					},
					["@assignment.rhs"] = {
						move = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. assignment_rhs_textobj_binding,
								desc = string.format(entry.desc, "rhs of assignment"),
							}
						end, prev_next_binding),
						select = vim.tbl_map(function(entry)
							return {
								lhs = entry.lhs .. assignment_rhs_textobj_binding,
								desc = string.format(entry.desc, "rhs of assignment"),
							}
						end, vim.list_extend(vim.list_extend({}, select_around_binding), select_inside_binding)),
					},
				}
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
							keymaps = {},
						},
						move = {
							enable = true,
							set_jumps = true,
							goto_next = {},
							goto_next_end = {},
							goto_previous = {},
							goto_previous_end = {},
							goto_previous_start = {},
							goto_next_start = {},
						},
					},
				}
				for node, value in pairs(enabled_ts_nodes) do
					if #value.move == 2 then
						local prev = value.move[1]
						local next = value.move[2]
						config.textobjects.move.goto_previous_start[prev.lhs] = { query = node, desc = prev.desc }
						config.textobjects.move.goto_next_start[next.lhs] = { query = node, desc = next.desc }
					end

					for _, item in ipairs(value.select) do
						config.textobjects.select.keymaps[item.lhs] = { query = node, desc = item.desc }
					end
				end
				require("nvim-treesitter.configs").setup(config)
				vim.api.nvim_create_autocmd("CursorHold", {
					pattern = "*",
					callback = function(ev)
						local ft = vim.bo.filetype
						local query = vim.treesitter.query.get(ft, "textobjects")

						if query == nil then
							return
						end

						local treesitter_textobjects_modes = { "n", "x", "o" }
						local del_desc = "Not available in this language"

						pcall(function()
							for node_type, value in pairs(enabled_ts_nodes) do
								local node_label = node_type:sub(2)
								if not vim.list_contains(query.captures, node_label) then
									vim.notify(
										string.format("found non-existent Treesitter node's binding: %s", node_label),
										vim.log.levels.DEBUG
									)
									for _, binding in ipairs(value.move) do
										vim.keymap.del(
											treesitter_textobjects_modes,
											binding.lhs,
											{ buffer = ev.buf, desc = del_desc }
										)
									end
								end
							end
						end)
					end,
				})
			end,
		},
		{
			"rlane/pounce.nvim",
			--NOTE relying the default f and treesitter textbobject seems to be enough
			enabled = false,
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
					"<leader>oo",
					function()
						local tab_idx = find_tab_with_filetype("oil")
						if tab_idx == -1 then
							vim.cmd("tabnew | Oil .")
							vim.cmd("leftabove vsplit | Oil .")
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
			"Isrothy/neominimap.nvim",
			version = "v3.*.*",
			enabled = false,
			lazy = false,
			init = function()
				vim.opt.wrap = false
				vim.opt.sidescrolloff = 36 -- Set a large value
				vim.g.neominimap = {
					auto_enable = true,
					-- NOTE to have higher z-index than nvim-treesitter
					float = { z_index = 11 },
				}
			end,
		},
		{
			"stevearc/quicker.nvim",
			event = "FileType qf",
			ft = { "qf" },
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
						filter = function(_, win)
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
						filter = function(_, win)
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
			version = "9.0.0",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			config = function()
				local prettier = { "prettierd", "prettier", stop_after_first = true }
				require("conform").setup({
					formatters_by_ft = {
						ember = {},
						apex = {},
						astro = {},
						bibtex = {},
						cuda = {},
						foam = {},
						fish = {},
						glsl = {},
						hack = {},
						inko = {},
						julia = {},
						odin = {},
						tact = {},
						nasm = {},
						slang = {},
						perl = {},
						wgsl = {},
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
						bash = { "shfmt" },
						markdown = prettier,
						json = prettier,
						jsonl = prettier,
						jsonc = prettier,
						json5 = prettier,
						yaml = prettier,
						vue = prettier,
						http = { "kulala-fmt" },
						rest = { "kulala-fmt" },
						toml = { "taplo" },
						lua = { "stylua" },
						teal = { "stylua" },
						python = function(bufnr)
							if require("conform").get_formatter_info("ruff_format", bufnr).available then
								return { "ruff_format" }
							else
								return { "isort", "black" }
							end
						end,
						rust = { "rustfmt", lsp_format = "fallback" },
						go = { "goimports", "gofmt" },
						nix = { "nixfmt" },
						nginx = { "nginxfmt" },
						ruby = { "rufo" },
						dart = { "dart_format" },
						haskell = { "hindent" },
						kotlin = { "ktlint" },
						cpp = { "clang_format" },
						c = { "clang_format" },
						cs = { "clang_format" },
						swift = { "swift_format" },
						r = { "styler" },
						elm = { "elm_format" },
						elixir = { "mix" },
						sql = { "pg_format" },
						tf = { "hcl" },
						ini = { "inifmt" },
						dosini = { "inifmt" },
						dhall = { "dhall_format" },
						fennel = { "fnlfmt" },
						svelte = prettier,
						pug = prettier,
						nunjucks = { "njkfmt" },
						liquid = { "liquidfmt" },
						nim = { "nimpretty" },
						mint = { "mintfmt" },
						kdl = { "kdlfmt" },
						just = { "just" },
						erb = { "erb_format" },
						ql = { "codeql" },
						d2 = { "d2" },
						erlang = { "efmt" },
						awk = { "gawk" },
						gleam = { "gleam" },
						rego = { "opa_fmt" },
						zig = { "zigfmt" },
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
			event = "VeryLazy",
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
		{ "echasnovski/mini.icons", version = false, event = "VeryLazy" },
	},
})
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local supported_modes = { "n", "v" }
		vim.keymap.set(supported_modes, "<leader>ss", function()
			-- if we call twice, we will enter the hover windows immediately after running the keybinding
			vim.lsp.buf.hover()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show hover tips" })
		-- TODO combine all these functions, using Snacks.picker
		vim.keymap.set(supported_modes, "<leader>s1", function()
			Snacks.picker.lsp_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to definition" })
		vim.keymap.set(supported_modes, "<leader>s2", function()
			Snacks.picker.lsp_type_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to type definition" })
		vim.keymap.set(supported_modes, "<leader>s3", function()
			Snacks.picker.lsp_implementations()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to implementation" })
		vim.keymap.set(supported_modes, "<leader>s4", function()
			Snacks.picker.lsp_references()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to references", nowait = true })
		vim.keymap.set(
			supported_modes,
			"<leader>s5",
			vim.lsp.buf.rename,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Rename variable" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>s6",
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
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
		if not client or type(value) ~= "table" then
			return
		end
		local p = progress[client.id]

		for i = 1, #p + 1 do
			if i == #p + 1 or p[i].token == ev.data.params.token then
				p[i] = {
					token = ev.data.params.token,
					msg = ("[%3d%%] %s%s"):format(
						value.kind == "end" and 100 or value.percentage or 100,
						value.title or "",
						value.message and (" **%s**"):format(value.message) or ""
					),
					done = value.kind == "end",
				}
				break
			end
		end

		local msg = {} ---@type string[]
		progress[client.id] = vim.tbl_filter(function(v)
			return table.insert(msg, v.msg) or not v.done
		end, p)

		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(table.concat(msg, "\n"), "info", {
			id = "lsp_progress",
			title = client.name,
			opts = function(notif)
				notif.icon = #progress[client.id] == 0 and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})
-- NOTE support clipboard in WSL, https://neovim.io/doc/user/provider.html#clipboard-wsl
if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "/mnt/c/Windows/System32/clip.exe",
			["*"] = "/mnt/c/Windows/System32/clip.exe",
		},
		paste = {
			["+"] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end
-- TODO how can I always open helpfiles in a tab?

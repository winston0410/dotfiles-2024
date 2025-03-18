local M = {}

function M.setup()
	vim.g.loaded_zipPlugin = 1
	vim.g.loaded_zip = 1
	vim.g.loaded_gzip = 1
	vim.g.loaded_matchit = 1
	vim.g.loaded_matchparen = 1
	vim.g.loaded_netrwPlugin = 1
	vim.g.loaded_remote_plugins = 1
	vim.g.loaded_shada_plugin = 0
	vim.g.loaded_spellfile_plugin = 1
	vim.g.loaded_tarPlugin = 1
	vim.g.loaded_2html_plugin = 1
	vim.g.loaded_tutor_mode_plugin = 1
	vim.g.loaded_python3_provider = 0
	vim.g.loaded_ruby_provider = 0
	vim.g.loaded_perl_provider = 0
	vim.g.loaded_node_provider = 0

	vim.o.encoding = "UTF-8"
	vim.o.fileencoding = "UTF-8"
	vim.o.confirm = true
	vim.opt.termguicolors = true
	vim.o.diffopt = "internal,filler,closeoff,algorithm:histogram,followwrap"
	vim.o.timeoutlen = 400
	vim.o.ttimeoutlen = 0
	vim.o.updatetime = 300
	vim.o.showmode = false
	vim.o.backup = false
	vim.o.writebackup = false
	vim.o.cmdheight = 1
	vim.o.showmatch = true
	-- FIXME how to split in right?
	vim.o.splitbelow = true
	vim.o.splitright = true
	vim.o.lazyredraw = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.magic = true
	vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
	vim.o.grepformat = "%f:%l:%c:%m"
	vim.o.wildmenu = true
	vim.o.wildmode = "longest:full,full"
	vim.o.hidden = true
	vim.o.bufhidden = "unload"
	vim.o.cursorline = true
	vim.o.cursorlineopt = "number"
	vim.o.wrap = true
	vim.o.linebreak = true
	vim.o.number = true
	vim.opt.relativenumber = true
	vim.o.signcolumn = "auto:2"
	vim.o.scrolloff = 8
	vim.o.fillchars = "diff:╱,eob: "
	vim.o.expandtab = true
	vim.o.autoindent = true
	vim.o.smartindent = true
	vim.o.undofile = true
	vim.o.shiftwidth = 4
	vim.o.tabstop = 4

	if vim.wo.diff then
		-- disable wrap so filler line will always align with changes
		vim.o.wrap = false
	end
	-- Use space as leader key
	vim.g.mapleader = " "
	-- Need to find plugin to improve mouse experience, to create something like vscode
	-- FIXME vim.opt is overriding value in vim.o. This is likely a bug in Neovim
	vim.o.mouse = "a"
	vim.o.mousefocus = true

	vim.o.sessionoptions = "buffers,curdir,folds,help,resize,tabpages,winsize,winpos,terminal"

	-- NOTE hide colorscheme provided by Neovim in colorscheme picker
	vim.opt.wildignore:append({
		"blue.vim",
		"darkblue.vim",
		"delek.vim",
		"desert.vim",
		"elflord.vim",
		"evening.vim",
		"industry.vim",
		"habamax.vim",
		"koehler.vim",
		"lunaperche.vim",
		"morning.vim",
		"murphy.vim",
		"pablo.vim",
		"peachpuff.vim",
		"quiet.vim",
		"ron.vim",
		"shine.vim",
		"slate.vim",
		"sorbet.vim",
		"retrobox.vim",
		"torte.vim",
		"wildcharm.vim",
		"zaibatsu.vim",
		"zellner.vim",
		"default.vim",
		"vim.lua",
	})
	vim.opt.background = "dark"
	vim.cmd("filetype on")
	vim.filetype.add({
		extension = {
			http = "http",
			rest = "http",
			qalc = "qalc",
		},
	})

	-- NOTE no longer need these bindings, just use register correctly with "+
	-- vim.keymap.set(modes, "<leader>y", '"+y', { silent = true, noremap = true, desc = "Yank text to system clipboard" })
	local clear_buffer_keybinding = "<leader>bc"
	local delete_buffer_keybinding = "<leader>bq"
	local next_buffer_keybinding = "<leader>bl"
	local prev_buffer_keybinding = "<leader>bh"
	vim.keymap.set({ "n" }, clear_buffer_keybinding, function()
		-- TODO
	end, { silent = true, noremap = true, desc = "Unload other buffers" })
	vim.keymap.set({ "n" }, delete_buffer_keybinding, function()
		Snacks.bufdelete.delete()
	end, { silent = true, noremap = true, desc = "Delete current buffer" })
	vim.keymap.set({ "n" }, next_buffer_keybinding, function()
		vim.cmd("bnext")
	end, { silent = true, noremap = true, desc = "Go to next buffer" })
	vim.keymap.set({ "n" }, prev_buffer_keybinding, function()
		vim.cmd("bprev")
	end, { silent = true, noremap = true, desc = "Go to previous buffer" })
	for i = 1, 9 do
		vim.keymap.set({ "n" }, "<leader>b" .. i, function()
			vim.cmd(string.format("LualineBuffersJump %s", i))
		end, { noremap = true, silent = true, desc = string.format("Jump to buffer %s", i) })
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function(ev)
			local ok, bufferlocked = pcall(function()
				return vim.api.nvim_buf_get_var(0, "lockbuffer")
			end)

			if not ok then
				return
			end

			if not bufferlocked then
				return
			end
			vim.keymap.set({ "n" }, clear_buffer_keybinding, "<Nop>", { buffer = ev.buf })
			vim.keymap.set({ "n" }, delete_buffer_keybinding, "<Nop>", { buffer = ev.buf })
			vim.keymap.set({ "n" }, next_buffer_keybinding, "<Nop>", { buffer = ev.buf })
			vim.keymap.set({ "n" }, prev_buffer_keybinding, "<Nop>", { buffer = ev.buf })
			for i = 1, 9 do
				vim.keymap.set({ "n" }, "<leader>b" .. i, "<Nop>", { buffer = ev.buf })
			end
		end,
	})

	-- NOTE make Y consistent with how C and D behave for changing or deleting to the end of the line.
	vim.keymap.set({ "n", "x" }, "Y", "y$", {
		silent = true,
		noremap = true,
		desc = "Yank to EOL",
	})

	vim.keymap.set({ "n" }, "vv", "<C-v>", { silent = true, noremap = true, desc = "Enter Visual block mode" })

	--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
	vim.keymap.set(
		{ "i" },
		"<Esc>",
		"<Esc>`^",
		{ silent = true, noremap = true, desc = "Prevent the cursor move back when returning to normal mode" }
	)

	vim.keymap.set({ "n" }, "<leader>wv", function()
		vim.cmd("vsplit")
	end, { silent = true, noremap = true, desc = "Create a vertical split" })
	vim.keymap.set({ "n" }, "<leader>ws", function()
		vim.cmd("split")
	end, { silent = true, noremap = true, desc = "Create a horizontal split" })
	vim.keymap.set({ "n" }, "<leader>wq", function()
		vim.cmd("quit")
	end, { silent = true, noremap = true, desc = "Close a split" })
	vim.keymap.set({ "n" }, "<leader>wl", "<C-w>l", { silent = true, noremap = true, desc = "Navigate to left split" })
	vim.keymap.set({ "n" }, "<leader>wh", "<C-w>h", { silent = true, noremap = true, desc = "Navigate to right split" })
	vim.keymap.set({ "n" }, "<leader>wk", "<C-w>k", { silent = true, noremap = true, desc = "Navigate to top split" })
	vim.keymap.set(
		{ "n" },
		"<leader>wj",
		"<C-w>j",
		{ silent = true, noremap = true, desc = "Navigate to bottom split" }
	)

	vim.keymap.set({ "t" }, "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Back to normal mode" })
	vim.api.nvim_create_autocmd("TermOpen", {
		pattern = "*",
		callback = function()
			vim.api.nvim_set_option_value("number", false, { scope = "local" })
			vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
			vim.api.nvim_set_option_value("filetype", "terminal", { scope = "local" })

			local shell_cmd = vim.opt.shell:get()
			-- zsh
			local _ = shell_cmd
				-- match substring before the first space
				:match("^(%S+)")
				-- match the base"me of a path
				:match("([^/]+)$")
		end,
	})
	vim.keymap.set({ "c", "n" }, "q:", "<Nop>", { noremap = true, silent = true })
	vim.keymap.set({ "c", "n" }, "q/", "<Nop>", { noremap = true, silent = true })
	vim.keymap.set({ "c", "n" }, "q?", "<Nop>", { noremap = true, silent = true })

	vim.keymap.set({ "n" }, "<leader>tv", function()
		vim.cmd("tabnew")
	end, { silent = true, noremap = true, desc = "Create a new tab" })
	vim.keymap.set({ "n" }, "<leader>tl", "gt", {
		silent = true,
		noremap = true,
		desc = "Go to the next tab page. Wraps around from the last to the first one.",
	})
	vim.keymap.set({ "n" }, "<leader>th", "gT", {
		silent = true,
		noremap = true,
		desc = "Go to the previous tab page. Wraps around from the first one to the last one.",
	})
	vim.keymap.set({ "n" }, "<leader>tq", function()
		vim.cmd("tabclose")
	end, { silent = true, noremap = true, desc = "Close a tab" })
	for i = 1, 9 do
		vim.keymap.set({ "n" }, "<leader>t" .. i, function()
			vim.cmd(string.format("tabn %s", i))
		end, { noremap = true, silent = true, desc = string.format("Jump to tab %s", i) })
	end

	vim.keymap.set({ "v" }, "p", "pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
	vim.keymap.set({ "v" }, "P", "Pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
	vim.keymap.set({ "n" }, "[h", "[c", { noremap = true, silent = true, desc = "Jump to the previous hunk" })
	vim.keymap.set({ "n" }, "]h", "]c", { noremap = true, silent = true, desc = "Jump to the next hunk" })

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
end
M.packages = {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		requires = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.g.tokyonight_style = "moon"
			vim.cmd.colorscheme("tokyonight")
			vim.opt.wildignore:append({
				"tokyonight.lua",
				"tokyonight-night.lua",
				"tokyonight-day.lua",
			})
		end,
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
			local class_textobj_binding = "K"
			local conditional_textobj_binding = "i"
			local return_textobj_binding = "r"
			local parameter_textobj_binding = "p"
			local assignment_lhs_textobj_binding = "al"
			local assignment_rhs_textobj_binding = "ar"
			local block_textobj_binding = "b"
			local comment_textobj_binding = "c"
			-- local fold_textobj_binding = "z"
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
				-- ["@fold"] = {
				-- 	move = vim.tbl_map(function(entry)
				-- 		return {
				-- 			lhs = entry.lhs .. fold_textobj_binding,
				-- 			desc = string.format(entry.desc, "fold"),
				-- 			query_group = "folds",
				-- 		}
				-- 	end, prev_next_binding),
				-- 	select = vim.tbl_map(function(entry)
				-- 		return {
				-- 			lhs = entry.lhs .. fold_textobj_binding,
				-- 			desc = string.format(entry.desc, "fold"),
				-- 		}
				-- 	end, select_around_binding),
				-- },
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
				["@class.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. class_textobj_binding,
							desc = string.format(entry.desc, "class"),
						}
					end, select_inside_binding),
				},
				["@class.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. class_textobj_binding,
							desc = string.format(entry.desc, "class"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. class_textobj_binding,
							desc = string.format(entry.desc, "class"),
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
						keymaps = {},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next = {},
						goto_next_start = {
							-- -- ["]cd"] = {
							-- -- 	query = "@comment.documentation",
							-- -- 	query_group = "highlights",
							-- -- 	desc = "Next lua doc comment",
							-- -- },
							-- ["]ct"] = {
							-- 	query = "@comment.todo",
							-- 	desc = "Jump to next TODO comment",
							-- },
							-- -- ["]cn"] = {
							-- -- 	query = "@comment.note",
							-- -- 	query_group = "injections",
							-- -- 	desc = "Jump to next NOTE comment",
							-- -- },
						},
						goto_next_end = {},
						goto_previous = {},
						goto_previous_end = {},
						goto_previous_start = {},
					},
				},
			}
			for node, value in pairs(enabled_ts_nodes) do
				if #value.move == 2 then
					local prev = value.move[1]
					local next = value.move[2]
					config.textobjects.move.goto_previous_start[prev.lhs] =
						{ query = node, desc = prev.desc, query_group = prev.query_group }
					config.textobjects.move.goto_next_start[next.lhs] =
						{ query = node, desc = next.desc, query_group = next.query_group }
				end

				for _, item in ipairs(value.select) do
					config.textobjects.select.keymaps[item.lhs] = { query = node, desc = item.desc }
				end
			end
			require("nvim-treesitter.configs").setup(config)
			vim.api.nvim_create_autocmd("CursorHold", {
				pattern = "*",
				callback = function(ev)
					local treesitter_textobjects_modes = { "n", "x", "o" }
					local del_desc = "Not available in this language"

					local available_textobjects = require("nvim-treesitter.textobjects.shared").available_textobjects()
					pcall(function()
						for node_type, value in pairs(enabled_ts_nodes) do
							local node_label = node_type:sub(2)
							if not vim.list_contains(available_textobjects, node_label) then
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
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			vim.keymap.set(
				{ "n", "x", "o" },
				";",
				ts_repeat_move.repeat_last_move_next,
				{ noremap = true, silent = true, desc = "Repeat Treesitter motion" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				",",
				ts_repeat_move.repeat_last_move_previous,
				{ noremap = true, silent = true, desc = "Repeat Treesitter motion" }
			)
		end,
	},
}
return M

-- Set the search path for Lua, so files in .config/nvim/plugins will be loaded
package.path = package.path .. ";" .. vim.fn.getenv("HOME") .. "/.config/nvim/?.lua"

-- Use space as leader key
vim.g.mapleader = " "

local modes = { "n", "v" }

local mappings = {
	--  Disable popup for commandline
	{ "q:", "<NOP>" },
	-- yank text from neovim to system clipboard
	{ "<leader>y", '"+y' },
	-- paste text from neovim to system clipboard
	{ "<leader>p", '"+p' },
	{ "<leader>P", '"+P' },
	{ "<leader>d", '"+d' },
	{ "Y", "y$" },
	{ "S", "<NOP>" },
	{ "s", "<NOP>" },
	-- FIXME for visual block, not sure do we need this
	-- { "<Char-0xAD>", "<C-v>" },
	-- for redo
	{ "<Char-0xAE>", "<C-r>" },

	-- guide on how to use tabs, buffers and window correctly in Vim
	-- https://stackoverflow.com/questions/26708822/why-do-vim-experts-prefer-buffers-over-tabs/26710166#26710166

	-- tab is a collection of windows. A split is a window, and buffer is global. Therefore, we need to use tabs, windows and buffer to do things together
	-- cycle focus to next window, with Cmd + w + w
	{ "<Char-0xAD>w", "<C-w>w" },
	-- create a vertical split, with Cmd + w + v
	{ "<Char-0xAD>v", "<cmd>vsplit<cr>" },
	-- create a horizontal split, with Cmd + w + h
	{ "<Char-0xAD>c", "<cmd>split<cr>" },
	-- close a split, with Cmd + w + q
	{ "<Char-0xAD>q", "<cmd>quit<cr>" },
	-- navigate to left split
	{ "<Char-0xAD>l", "<C-w>l" },
	-- navigate to right split
	{ "<Char-0xAD>h", "<C-w>h" },
	-- navigate to top split
	{ "<Char-0xAD>k", "<C-w>k" },
	-- navigate to down split
	{ "<Char-0xAD>j", "<C-w>j" },

	-- -- create new tab in Oil.nvim, with Cmd + t + c
	{ "<Char-0xBA>c", "<cmd>tabnew .<cr>" },
	-- close the current tab, with Cmd + t + q
	{ "<Char-0xBA>q", "<cmd>tabclose<cr>" },
	-- cycle or navigate to specific tab
	{ "<Char-0xBA>t", "gt" },
	{ "<Char-0xBA>n", "<cmd>tabnext<cr>" },
	{ "<Char-0xBA>p", "<cmd>tabprev<cr>" },

	-- create new buffer, with Cmd + e + c
	{ "<Char-0xBB>c", "<cmd>badd .<bar>bnext<cr>" },
	-- delete current buffer and switch to prev buffer
	-- REF https://www.reddit.com/r/neovim/comments/s4jt9n/how_to_close_the_current_buffer_without_closing/
	{ "<Char-0xBB>q", "<cmd>bprevious<bar>bdelete #<cr>" },
	-- cycle between buffer
	{ "<Char-0xBB>n", "<cmd>bnext<cr>" },
	{ "<Char-0xBB>p", "<cmd>bprev<cr>" },
}

vim.api.nvim_set_keymap("i", "<Char-0xAE>", "<C-r>", { silent = true, noremap = true })
--  Prevent the cursor move back when returning to normal mode
--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
vim.api.nvim_set_keymap("i", "<Esc>", "<Esc>`^", { silent = true, noremap = true })

vim.api.nvim_set_keymap("n", "gs", ":%s/", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", "gs", ":s/", { silent = true, noremap = true })
-- Important: Paste in visual mode without copying
vim.api.nvim_set_keymap("v", "p", "pgvy", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", "P", "Pgvy", { silent = true, noremap = true })
-- Important: Revert back to previous cursor position
vim.api.nvim_set_keymap("i", "<esc>", "<esc>`^", { silent = true, noremap = true })

for _, mapping in ipairs(mappings) do
	for _, mode in ipairs(modes) do
		vim.api.nvim_set_keymap(mode, mapping[1], mapping[2], { silent = true, noremap = true })
	end
end

local all_modes = { "i", "n", "v", "c", "t", "s" }

for _, mode in pairs(all_modes) do
	-- remap escape to CMD + [
	vim.api.nvim_set_keymap(mode, "<Char-0xAA>", "<esc>", { silent = true, noremap = true })
	-- remap up and down for easy use of fzf to CMD + n and CMD + p
	vim.api.nvim_set_keymap(mode, "<Char-0xAB>", "<Up>", { silent = true, noremap = true })
	vim.api.nvim_set_keymap(mode, "<Char-0xAC>", "<Down>", { silent = true, noremap = true })
	vim.api.nvim_set_keymap(
		mode,
		"<Char-0xAF>",
		"<cmd>write<cr>",
		{ silent = true, noremap = true, desc = "Saved current file by <command-s>" }
	)
end

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")
vim.cmd("set shortmess+=c")

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
	{ "hidden", true },
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

-- Doesn't apply to newly included buffer?
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
	{
		"LazyVim/LazyVim",
		commit = "2fc7697786e72e02db91dd2242d1407f5b80856b",
		lazy = false,
		config = function()
			-- only load the autocmds modules. Reference the options module only but don't load it, it seems to be too much
			-- require("lazyvim.config.options")
			require("lazyvim.config.autocmds")
		end,
	},
	{
		"folke/tokyonight.nvim",
		commit = "c2725eb6d086c8c9624456d734bd365194660017",
		lazy = false,
		priority = 1000,
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.g.tokyonight_style = "night"
			vim.cmd("colorscheme tokyonight")

			local highlight_list = {
				-- { "Search", "Visual" },
				-- { "IncSearch", "Visual" },
				{ "CursorLineNr", "cleared" },
				-- highlight! link CursorLineNr cleared
			}

			for _, highlight in ipairs(highlight_list) do
				vim.cmd("highlight! link" .. " " .. highlight[1] .. " " .. highlight[2])
			end
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		commit = "2a5bae925481f999263d6f5ed8361baef8df4f83",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- local color
			local colors = require("tokyonight.colors").setup()
			-- print('check colors', vim.inspect(colors))
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					component_separators = "",
					section_separators = "",
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = {},
					lualine_x = {},
					lualine_y = {
						{
							"filename",
							file_status = true,
							path = 2,
							color = { fg = colors.fg, bg = colors.bg_statusline },
						},
					},
					lualine_z = {
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " " },
							color = { bg = colors.bg_statusline },
						},
						{
							-- Check if active LSP exist
							function()
								local msg = ""
								local clients = vim.lsp.get_clients()
								if #clients < 1 then
									msg = "年"
									return msg
								end
								return ""
							end,
							color = { fg = colors.fg, bg = colors.bg_statusline },
						},
					},
				},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		commit = "261a72b90d6db4ed8014f7bda976bcdc9dd7ce76",
		dependencies = "nvim-tree/nvim-web-devicons",
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
		"NeogitOrg/neogit",
		commit = "d7772bca4ac00c02282b0d02623f2f8316c21f32",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = { { "<leader>g" }, { "<leader>g", mode = "v" } },
		config = function()
			require("neogit").setup({
				disable_hint = true,
				disable_commit_confirmation = true,
				mappings = {
					status = {
						["<enter>"] = "Toggle",
					},
				},
			})
			for _, mode in ipairs({ "n", "v" }) do
				vim.api.nvim_set_keymap(
					mode,
					"<leader>g",
					"<cmd>lua require('neogit').open()<cr>",
					{ silent = true, noremap = true }
				)
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
	{
		"hrsh7th/nvim-cmp",
		commit = "ed31156aa2cc14e3bc066c59357cc91536a2bc01",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<Char-0xAC>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<Char-0xAB>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
				sorting = defaults.sorting,
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
			}
		end,
		config = function(_, opts)
			for _, source in ipairs(opts.sources) do
				source.group_index = source.group_index or 1
			end
			require("cmp").setup(opts)
		end,
	},
	{
		"mrjones2014/smart-splits.nvim",
		commit = "c8a9173d70cbbd1f6e4a414e49e31df2b32a1362",
		config = function()
			require("smart-splits").setup({
				default_amount = 10,
			})
			vim.keymap.set("n", "<Char-0xAD>L", require("smart-splits").resize_right)
			vim.keymap.set("n", "<Char-0xAD>H", require("smart-splits").resize_left)
			vim.keymap.set("n", "<Char-0xAD>K", require("smart-splits").resize_up)
			vim.keymap.set("n", "<Char-0xAD>J,", require("smart-splits").resize_down)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		commit = "5f808b5e4fef30bd8aca1b803b4e555da07fc412",
		event = "CursorHold",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"nacro90/numb.nvim",
		commit = "3f7d4a74bd456e747a1278ea1672b26116e0824d",
		event = "CmdlineEnter",
		config = function()
			require("numb").setup({})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		commit = "7871a88056f7144defca9c931e311a3134c5d509",
		event = "CursorHold",
		config = function()
			require("ibl").setup({
				indent = {
					char = "▏",
					highlight = { "IblIndent" },
				},
			})
		end,
	},
	{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = "CursorHold" },
	{
		"numToStr/Comment.nvim",
		commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
		keys = { { "<leader>c" }, { "<leader>b" }, { "<leader>c", mode = "v" }, { "<leader>b", mode = "v" } },
		config = function()
			require("Comment").setup({
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
		"smoka7/hop.nvim",
		commit = "275dcbc84e8167c7d64b4584770d837f3ce21562",
		-- keys = { { "<leader>f" }, { "<leader>F" }, { "<leader>f", mode = "v" }, { "<leader>F", mode = "v" } },
		keys = { { "f" }, { "F" }, { "f", mode = "v" }, { "F", mode = "v" } },
		config = function()
			require("hop").setup({})

			local supported_modes = { "n", "v", "o" }

			for _, mode in ipairs(supported_modes) do
				vim.api.nvim_set_keymap(mode, "f", "<cmd>HopChar1<cr>", { noremap = true, silent = true })
				vim.api.nvim_set_keymap(mode, "F", "<cmd>HopChar1<cr>", { noremap = true, silent = true })
				-- vim.api.nvim_set_keymap(mode, "<leader>f", "<cmd>HopChar1<cr>", { noremap = true, silent = true })
				-- vim.api.nvim_set_keymap(mode, "<leader>F", "<cmd>HopChar1<cr>", { noremap = true, silent = true })
			end
		end,
	},
	{
		"ibhagwan/fzf-lua",
		commit = "cd3a9cb9ef55933be6152a77e8aeb36f12a0467b",
		keys = {
			{ ",m" },
			{ ",g" },
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local actions = require("fzf-lua.actions")

			require("fzf-lua").setup({
				winopts = {
					win_height = 1,
					win_width = 1,
				},
				fzf_layout = "reverse-list",
				files = {
					prompt = "Fd❯ ",
					--  Cannot set the cmd explicitly, as fzf-lua would not customize it further for you. Default to fd anyway
					--  cmd = "fd",
					git_icons = true, -- show git icons?
					file_icons = true, -- show file icons?
					color_icons = true, -- colorize file|git icons
				},
				grep = {
					prompt = "Rg❯ ",
					actions = {
						["Enter"] = actions.file_edit,
					},
				},
			})

			for _, mode in ipairs({ "n", "v" }) do
				vim.api.nvim_set_keymap(mode, ",m", "<cmd>lua require('plugins.fzf-lua').searchFiles()<cr>", {
					silent = true,
					noremap = true,
				})

				vim.api.nvim_set_keymap(mode, ",pm", "<cmd>lua require('fzf-lua').files_resume()<cr>", {
					silent = true,
					noremap = true,
				})

				vim.api.nvim_set_keymap(mode, ",g", "<cmd>lua require('plugins.fzf-lua').liveGrep()<cr>", {
					silent = true,
					noremap = true,
				})

				vim.api.nvim_set_keymap(mode, ",pg", "<cmd>lua require('fzf-lua').live_grep_resume()<cr>", {
					silent = true,
					noremap = true,
				})

				-- NOTE not in use at the moment
				-- vim.api.nvim_set_keymap(mode, ",a", "<cmd>lua require('fzf-lua').lsp_code_actions()<cr>", {
				-- 	silent = true,
				-- 	noremap = true,
				-- })

				-- vim.api.nvim_set_keymap(mode, ",a", "<cmd>lua require('fzf-lua').lsp_code_actions()<cr>", {
				-- 	silent = true,
				-- 	noremap = true,
				-- })

				-- vim.api.nvim_set_keymap(mode, ",s", "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<cr>", {
				-- 	silent = true,
				-- 	noremap = true,
				-- })

				-- vim.api.nvim_set_keymap(mode, ",d", "<cmd>lua require('fzf-lua').lsp_workspace_diagnostics()<cr>", {
				-- 	silent = true,
				-- 	noremap = true,
				-- })
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "CursorHold",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		commit = "ad8f0a472148c3e0ae9851e26a722ee4e29b1595",
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = "CursorHold",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		commit = "9c74db656c3d0b1c4392fc89a016b1910539e7c0",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = "CursorHold",
		commit = "427a90ae70f66c2fdf2d9ad16a0f08e9697d90d9",
		build = function()
			vim.cmd("TSUpdate")
		end,
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			local installer = require("nvim-treesitter.install")
			installer.prefer_git = true

			parser_config.wast = {
				install_info = {
					branch = "main",
					url = "https://github.com/wasm-lsp/tree-sitter-wasm",
					files = { "wast/src/parser.c" },
				},
				filetype = "wast",
				used_by = { "wast" },
			}
			parser_config.wat = {
				install_info = {
					branch = "main",
					url = "https://github.com/wasm-lsp/tree-sitter-wasm",
					files = { "wat/src/parser.c" },
				},
				filetype = "wat",
				used_by = { "wat" },
			}
			parser_config.ejs = {
				install_info = {
					branch = "master",
					url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
					files = { "src/parser.c" },
				},
				filetype = "ejs",
				used_by = { "erb" },
			}
			parser_config.make = {
				install_info = {
					branch = "main",
					url = "https://github.com/alemuller/tree-sitter-make",
					files = { "src/parser.c" },
				},
				filetype = "make",
				used_by = { "make" },
			}

			for _, mode in ipairs({ "n", "v" }) do
				-- Unmap x
				vim.api.nvim_set_keymap(mode, "x", "<nop>", { silent = true, noremap = true })
			end

			treesitter.setup({
				highlight = { enable = true },
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
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["ac"] = "@call.inner",
							["ic"] = "@call.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["xf"] = "@function.outer",
							["xc"] = "@call.outer",
							["xs"] = "@parameter.inner",
							["xz"] = "@conditional.outer",
							["xv"] = "@class.outer",
						},
						goto_next_end = {
							["xF"] = "@function.outer",
							["xC"] = "@call.outer",
							["xS"] = "@parameter.inner",
							["xZ"] = "@conditional.outer",
							["xV"] = "@class.outer",
						},
						goto_previous_start = {
							["Xf"] = "@function.outer",
							["Xc"] = "@call.outer",
							["Xs"] = "@parameter.inner",
							["Xz"] = "@conditional.outer",
							["Xv"] = "@class.outer",
						},
						goto_previous_end = {
							["XF"] = "@function.outer",
							["XC"] = "@call.outer",
							["XS"] = "@parameter.inner",
							["XZ"] = "@conditional.outer",
							["XV"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup({})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"mhartington/formatter.nvim",
		commit = "34dcdfa0c75df667743b2a50dd99c84a557376f0",
		event = "BufWritePre",
		config = function()
			local function mintfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function javafmt()
				-- https://github.com/google/google-java-format
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function inifmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function nimfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function njkfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function liquidfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function dhall_format()
				return {
					exe = "dhall",
					args = { "format", "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function dhall_lint()
				return {
					exe = "dhall",
					args = { "lint", "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end

			local function styler()
				return {
					exe = "",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function swift_format()
				return {
					exe = "swift-format",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function clang_format()
				return {
					exe = "clang-format",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function prettier(opts)
				opts = opts or {}
				return function()
					return {
						exe = "prettier",
						args = { vim.api.nvim_buf_get_name(0), table.unpack(opts) },
						stdin = true,
					}
				end
			end

			local function dockfmt()
				return {
					exe = "dockfmt",
					args = { "fmt", "--", vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function hindent()
				return {
					exe = "hindent",
					-- args = {"-w", "--", vim.api.nvim_buf_get_name(0)},
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end

			local function rufo()
				return {
					exe = "rufo",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end

			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					html = { require("formatter.filetypes.javascript").prettier },
					xml = { require("formatter.filetypes.javascript").prettier },
					svg = { require("formatter.filetypes.javascript").prettier },
					css = { require("formatter.filetypes.javascript").prettier },
					scss = { require("formatter.filetypes.javascript").prettier },
					sass = { require("formatter.filetypes.javascript").prettier },
					less = { require("formatter.filetypes.javascript").prettier },
					javascript = { require("formatter.filetypes.javascript").prettier },
					typescript = { require("formatter.filetypes.javascript").prettier },
					javascriptreact = { require("formatter.filetypes.javascript").prettier },
					typescriptreact = { require("formatter.filetypes.javascript").prettier },
					["javascript.jsx"] = { require("formatter.filetypes.javascript").prettier },
					["typescript.jsx"] = { require("formatter.filetypes.javascript").prettier },
					sh = { require("formatter.filetypes.sh").shfmt },
					zsh = { require("formatter.filetypes.sh").shfmt },
					markdown = { require("formatter.filetypes.javascript").prettier },
					json = { require("formatter.filetypes.javascript").prettier },
					jsonc = { require("formatter.filetypes.javascript").prettier },
					json5 = { require("formatter.filetypes.javascript").prettier },
					yaml = {
						require("formatter.filetypes.yaml").prettier,
						-- does not work correctly
						-- require("formatter.filetypes.yaml").yamlfmt
					},
					toml = { require("formatter.filetypes.toml").taplo },
					vue = { require("formatter.filetypes.javascript").prettier },
					svelte = {
						--[[ prettier({
							"--plugin-search-dir=.",
							"--plugin=prettier-plugin-svelte",
						}), ]]
						prettier({
							"--config=$XDG_CONFIG_HOME/prettier/.prettierrc",
							-- FIXME bug of prettier, wait for 3.1 and then we can remove this
							-- https://github.com/sveltejs/prettier-plugin-svelte/pull/404
							"--plugin=prettier-plugin-svelte",
						}),
					},
					python = { require("formatter.filetypes.python").black },
					dockerfile = { dockfmt },
					-- No formatter for make
					make = {
						require("formatter.filetypes.javascript").prettier,
					},
					ruby = { rufo },
					lua = { require("formatter.filetypes.lua").stylua },
					teal = { require("formatter.filetypes.lua").stylua },
					rust = { require("formatter.filetypes.rust").rustfmt },
					nix = { require("formatter.filetypes.nix").nixfmt },
					go = { require("formatter.filetypes.go").gofmt, require("formatter.filetypes.go").goimports },
					dart = { require("formatter.filetypes.dart").dartformat },
					haskell = { hindent },
					purescript = {
						{
							exe = "purty",
							args = { "--", vim.api.nvim_buf_get_name(0) },
							stdin = true,
						},
					},
					kotlin = { require("formatter.filetypes.kotlin").ktlint },
					java = { javafmt },
					fennel = {
						{
							exe = "fnlfmt",
							args = { vim.api.nvim_buf_get_name(0) },
							stdin = true,
						},
					},
					cpp = { clang_format },
					c = { clang_format },
					cs = { clang_format },
					swift = { swift_format },
					r = { styler },
					elm = {
						{
							exe = "elm-format",
							args = { "--", vim.api.nvim_buf_get_name(0) },
							stdin = false,
						},
					},
					elixir = { require("formatter.filetypes.elixir").mixformat },
					sql = { require("formatter.filetypes.sql").pgformat },
					tf = { require("formatter.filetypes.terraform").terraformfmt },
					ini = { inifmt },
					dosini = { inifmt },
					dhall = { dhall_lint, dhall_format },
					pug = {
						prettier({
							"--plugin-search-dir=.",
							"--plugin=plugin-pug",
						}),
						--  Falling back with system plugin
						prettier({
							"--plugin-search-dir=$XDG_DATA_HOME/prettier",
							"--plugin=plugin-pug",
						}),
					},
					nunjucks = { njkfmt },
					liquid = { liquidfmt },
					mustache = {},
					wren = {},
					haml = {},
					nim = { nimfmt },
					mint = { mintfmt },
				},
			})

			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*" },
				command = "FormatWrite",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		commit = "e869c7e6af0a3c40a2b344a9765779d74dd12720",
		-- Reference the lazyload event from LazyVim
		-- REF https://github.com/LazyVim/LazyVim/blob/86ac9989ea15b7a69bb2bdf719a9a809db5ce526/lua/lazyvim/plugins/lsp/init.lua#L5
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- https://github.com/hrsh7th/nvim-cmp/issues/373
			capabilities.textDocument.completion.completionItem.snippetSupport = false

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
				"vuels",
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
				-- "rnix",
				"nixd",
				"r_language_server",
				"kotlin_language_server",
				"cmake",
				"pyright",
				"taplo",
				"cucumber_language_server",
				"regols",
				"slint_lsp",
			}

			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end

			lspconfig.elixirls.setup({
				cmd = { "elixir-ls" },
				capabilities = capabilities,
			})

			lspconfig.dockerls.setup({
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
				capabilities = capabilities,
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "Lua 5.4",
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
								"${3rd}/busted/library",
							},
						},
					})
				end,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	},
	{
		"folke/trouble.nvim",
		version = "3.6.0",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- commit = "40c5317a6e90fe3393f07b0fee580d9e93a216b4",
		config = function()
			require("trouble").setup({
				position = "bottom",
				height = 10,
				use_diagnostic_signs = true,
				indent_lines = false,
				auto_close = true,
				modes = {
					diagnostics = { auto_open = true },
				},
			})
		end,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set({ "n" }, "<leader>lt", require("trouble").toggle, { silent = true, noremap = true })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>ldt", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)
	end,
})

-- Set the search path for Lua, so files in .config/nvim/plugins will be loaded
package.path = package.path .. ";" .. vim.fn.getenv("HOME") .. "/.config/nvim/?.lua"

-- Use space as leader key
vim.g.mapleader = " "

local modes = { "n", "v" }
vim.keymap.set(modes, "q:", "<NOP>", { silent = true, noremap = true, desc = "Disable popup for commandline" })
vim.keymap.set(modes, "<leader>y", '"+y', { silent = true, noremap = true, desc = "Yank text to system clipboard" })
vim.keymap.set(modes, "<leader>p", '"+p', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
vim.keymap.set(modes, "<leader>P", '"+P', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
-- FIXME not sure why we need this in first place
-- vim.keymap.set(modes, "<leader>d", '"+d' )
--
-- make Y consistent with how C and D behave for changing or deleting to the end of the line.
vim.keymap.set(modes, "Y", "y$", {
	silent = true,
	noremap = true,
	desc = "Yanks from the cursor position to the end of the line.",
})
vim.keymap.set(modes, "S", "<NOP>", { silent = true, noremap = true, desc = "Unmap S" })
vim.keymap.set(modes, "s", "<NOP>", { silent = true, noremap = true, desc = "Unmap s" })
-- FIXME for visual block, not sure do we need this
-- vim.keymap.set(modes, "<Char-0xAD>", "<C-v>" )
vim.keymap.set({ "i", "n", "v" }, "<Char-0xAE>", "<C-r>", { silent = true, noremap = true, desc = "Redo" })

-- Binding for split
vim.keymap.set(modes, "<Char-0xAD>w", "<C-w>w", { silent = true, noremap = true, desc = "cycle focus to next split" })
vim.keymap.set(
	modes,
	"<Char-0xAD>v",
	"<cmd>vsplit<cr>",
	{ silent = true, noremap = true, desc = "Create a vertical split" }
)
vim.keymap.set(
	modes,
	"<Char-0xAD>c",
	"<cmd>split<cr>",
	{ silent = true, noremap = true, desc = "Create a horizontal split" }
)
vim.keymap.set(modes, "<Char-0xAD>q", "<cmd>quit<cr>", { silent = true, noremap = true, desc = "Close a split" })
vim.keymap.set(modes, "<Char-0xAD>l", "<C-w>l", { silent = true, noremap = true, desc = "Navigate to left split" })
vim.keymap.set(modes, "<Char-0xAD>h", "<C-w>h", { silent = true, noremap = true, desc = "Navigate to right split" })
vim.keymap.set(modes, "<Char-0xAD>k", "<C-w>k", { silent = true, noremap = true, desc = "Navigate to top split" })
vim.keymap.set(modes, "<Char-0xAD>j", "<C-w>j", { silent = true, noremap = true, desc = "Navigate to bottom split" })

-- NOTE enable this in the future, if we really need to use tab in nvim
-- vim.keymap.set(modes, "<Char-0xBA>c", "<cmd>tabnew .<cr>" )
-- vim.keymap.set(modes, "<Char-0xBA>q", "<cmd>tabclose<cr>" )
-- vim.keymap.set(modes, "<Char-0xBA>t", "gt" )
-- vim.keymap.set(modes, "<Char-0xBA>n", "<cmd>tabnext<cr>" )
-- vim.keymap.set(modes, "<Char-0xBA>p", "<cmd>tabprev<cr>" )

-- NOTE <Char-0xBB> is Cmd + e
vim.keymap.set(
	modes,
	"<Char-0xBB>q",
	"<cmd>bprevious<bar>bdelete #<cr>",
	{ silent = true, noremap = true, desc = "delete current buffer and switch to prev buffer" }
)
vim.keymap.set(
	modes,
	"<Char-0xBB>n",
	"<cmd>bprev<cr>",
	{ silent = true, noremap = true, desc = "goto previous buffer" }
)
vim.keymap.set(modes, "<Char-0xBB>p", "<cmd>bnext<cr>", { silent = true, noremap = true, desc = "goto next buffer" })

--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
vim.keymap.set(
	{ "i" },
	"<Esc>",
	"<Esc>`^",
	{ silent = true, noremap = true, desc = "Prevent the cursor move back when returning to normal mode" }
)

-- FIXME create a new keymapping that start subtitue for the highlighted word globally, and then replace these two mappings
-- vim.keymap.set("n", "gs", ":%s/", { silent = true, noremap = true })
-- vim.keymap.set("v", "gs", ":s/", { silent = true, noremap = true })

vim.keymap.set("v", "p", "pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set("v", "P", "Pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set(
	"i",
	"<esc>",
	"<esc>`^",
	{ silent = true, noremap = true, desc = "Revert back to previous cursor position" }
)

local all_modes = { "i", "n", "v", "c", "t", "s" }

vim.keymap.set(all_modes, "<Char-0xAA>", "<esc>", { silent = true, noremap = true, desc = "remap escape to CMD + [" })
vim.keymap.set(all_modes, "<Char-0xAB>", "<Up>", { silent = true, noremap = true, desc = "remap up to CMD + p" })
vim.keymap.set(all_modes, "<Char-0xAC>", "<Down>", { silent = true, noremap = true, desc = "remap down to CMD + n" })
-- vim.keymap.set(all_modes, "<Char-0xAF>", "<cmd>write<cr>", { silent = true, noremap = true, desc = "Saved current file by <command-s>" })

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
		config = function()
			vim.g.tokyonight_style = "night"
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	-- {
	-- 	"folke/persistence.nvim",
	-- 	version = "3.1.0",
	-- 	event = "BufReadPre",
	-- 	opts = {},
	-- 	config = function()
	-- 		-- load the session for the current directory
	-- 		vim.keymap.set("n", "<leader>qs", function()
	-- 			require("persistence").load()
	-- 		end)
	--
	-- 		-- select a session to load
	-- 		vim.keymap.set("n", "<leader>qS", function()
	-- 			require("persistence").select()
	-- 		end)
	--
	-- 		-- load the last session
	-- 		vim.keymap.set("n", "<leader>ql", function()
	-- 			require("persistence").load({ last = true })
	-- 		end)
	--
	-- 		-- stop Persistence => session won't be saved on exit
	-- 		vim.keymap.set("n", "<leader>qd", function()
	-- 			require("persistence").stop()
	-- 		end)
	-- 	end,
	-- },
	{
		{
			"linrongbin16/lsp-progress.nvim",
			version = "1.0.13",
			event = { "BufReadPre", "BufNewFile" },
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
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch" },
					lualine_c = { "location" },
					lualine_x = {},
					lualine_y = {
						-- {
						-- 	"filename",
						-- 	file_status = true,
						-- 	path = 2,
						-- 	color = { fg = colors.fg, bg = colors.bg_statusline },
						-- },
					},
					lualine_z = {
						{
							"diagnostics",
							sources = { "nvim_lsp" },
							symbols = { error = " ", warn = " ", info = " " },
							color = { bg = colors.bg_statusline },
						},
						{
							function()
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
											return " LSP:" .. client_count .. " " .. table.concat(client_names, " ")
										end
									end,
								})
							end,
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
		"NeogitOrg/neogit",
		commit = "d7772bca4ac00c02282b0d02623f2f8316c21f32",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = { { "<leader>g" }, { "<leader>g", mode = "v" } },
		opts = {
			disable_hint = true,
			disable_commit_confirmation = true,
			kind = "floating",
			integrations = {
				fzf_lua = true,
			},
			mappings = {
				status = {
					["<enter>"] = "Toggle",
				},
			},
		},
		config = function()
			vim.keymap.set(
				{ "n" },
				"<leader>g",
				"<cmd>lua require('neogit').open()<cr>",
				{ silent = true, noremap = true, desc = "open Neogit panel" }
			)
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		version = "3.14.1",
		opts = {
			preset = "helix",
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
		version = "1.7.0",
		keys = {
			{
				"<Char-0xAD>L",
				function()
					require("smart-splits").resize_right()
				end,
				mode = "n",
				silent = true,
				desc = "resize split to right",
			},
			{
				"<Char-0xAD>H",
				function()
					require("smart-splits").resize_left()
				end,
				mode = "n",
				silent = true,
				desc = "resize split to left",
			},
			{
				"<Char-0xAD>K",
				function()
					require("smart-splits").resize_up()
				end,
				mode = "n",
				silent = true,
				desc = "resize split to top",
			},
			{
				"<Char-0xAD>J",
				function()
					require("smart-splits").resize_down()
				end,
				mode = "n",
				silent = true,
				desc = "resize split to bottom",
			},
		},
		opts = {
			default_amount = 10,
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		version = "0.9.0",
		event = "CursorHold",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nacro90/numb.nvim",
		commit = "3f7d4a74bd456e747a1278ea1672b26116e0824d",
		event = "CmdlineEnter",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		version = "3.8.6",
		event = "CursorHold",
		opts = {
			indent = {
				char = "▏",
				highlight = { "IblIndent" },
			},
		},
	},
	{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = "CursorHold" },
	{
		"numToStr/Comment.nvim",
		commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
		keys = { { "<leader>c" }, { "<leader>b" }, { "<leader>c", mode = "v" }, { "<leader>b", mode = "v" } },
		opts = {
			toggler = {
				line = "<leader>cc",
				block = "<leader>bc",
			},
			opleader = {
				line = "<leader>c",
				block = "<leader>b",
			},
		},
	},
	{
		"smoka7/hop.nvim",
		version = "2.7.2",
		keys = { { "f" }, { "F" }, { "f", mode = "v" }, { "F", mode = "v" } },
		config = function()
			require("hop").setup({})

			local supported_modes = { "n", "v", "o" }

			vim.keymap.set(
				supported_modes,
				"f",
				"<cmd>HopChar1<cr>",
				{ noremap = true, silent = true, desc = "find 1 character forward" }
			)
			vim.keymap.set(
				supported_modes,
				"F",
				"<cmd>HopChar1<cr>",
				{ noremap = true, silent = true, desc = "find 1 character backward" }
			)
		end,
	},
	{
		"ibhagwan/fzf-lua",
		commit = "cd3a9cb9ef55933be6152a77e8aeb36f12a0467b",
		keys = {
			-- for fd
			{ ",m" },
			-- for rg
			{ ",f" },
			-- for git related search
			{ ",gc" },
			{ ",gs" },
			-- for lsp search
			{ ",la" },
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
				},
				grep = {
					prompt = "Rg❯ ",
				},
			})

			local supported_modes = { "n", "v" }

			vim.keymap.set(supported_modes, ",m", "<cmd>lua require('fzf-lua').files()<cr>", {
				silent = true,
				noremap = true,
				desc = "search files",
			})

			vim.keymap.set(supported_modes, ",f", "<cmd>lua require('fzf-lua').live_grep_resume()<cr>", {
				silent = true,
				noremap = true,
				desc = "search text in files",
			})

			vim.keymap.set(supported_modes, ",gc", "<cmd>lua require('fzf-lua').git_commits()<cr>", {
				silent = true,
				noremap = true,
				desc = "search text in git commits",
			})

			vim.keymap.set(supported_modes, ",gs", "<cmd>lua require('fzf-lua').git_stash()<cr>", {
				silent = true,
				noremap = true,
				desc = "search text in git stash",
			})

			vim.keymap.set(supported_modes, ",la", "<cmd>lua require('fzf-lua').lsp_code_actions()<cr>", {
				silent = true,
				noremap = true,
				desc = "search lsp code actions",
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
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
		"nvim-treesitter/nvim-treesitter",
		commit = "427a90ae70f66c2fdf2d9ad16a0f08e9697d90d9",
		build = function()
			vim.cmd("TSUpdate")
		end,
		opts = {
			ensure_installed = "all",
			auto_install = false,
			incremental_selection = { enable = true },
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
						-- ["af"] = "@function.outer",
						-- ["if"] = "@function.inner",
						-- ["ai"] = "@conditional.outer",
						-- ["ii"] = "@conditional.inner",
						-- ["ac"] = "@call.inner",
						-- ["ic"] = "@call.outer",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					-- goto_next_start = {
					-- 	["xf"] = "@function.outer",
					-- 	["xc"] = "@call.outer",
					-- 	["xs"] = "@parameter.inner",
					-- 	["xz"] = "@conditional.outer",
					-- 	["xv"] = "@class.outer",
					-- },
					-- goto_next_end = {
					-- 	["xF"] = "@function.outer",
					-- 	["xC"] = "@call.outer",
					-- 	["xS"] = "@parameter.inner",
					-- 	["xZ"] = "@conditional.outer",
					-- 	["xV"] = "@class.outer",
					-- },
					-- goto_previous_start = {
					-- 	["Xf"] = "@function.outer",
					-- 	["Xc"] = "@call.outer",
					-- 	["Xs"] = "@parameter.inner",
					-- 	["Xz"] = "@conditional.outer",
					-- 	["Xv"] = "@class.outer",
					-- },
					-- goto_previous_end = {
					-- 	["XF"] = "@function.outer",
					-- 	["XC"] = "@call.outer",
					-- 	["XS"] = "@parameter.inner",
					-- 	["XZ"] = "@conditional.outer",
					-- 	["XV"] = "@class.outer",
					-- },
				},
			},
		},
		opts_extend = { "ensure_installed" },
		event = "CursorHold",
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			-- local treesitter = require("nvim-treesitter.configs")
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

			vim.keymap.set({ "n", "v" }, "x", "<nop>", { silent = true, noremap = true, desc = "Unmap x" })
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			-- {
			-- 	"s",
			-- 	mode = { "n", "x", "o" },
			-- 	function()
			-- 		require("flash").jump()
			-- 	end,
			-- 	desc = "Flash",
			-- },
			-- {
			-- 	"S",
			-- 	mode = { "n", "x", "o" },
			-- 	function()
			-- 		require("flash").treesitter()
			-- 	end,
			-- 	desc = "Flash Treesitter",
			-- },
			-- {
			-- 	"r",
			-- 	mode = "o",
			-- 	function()
			-- 		require("flash").remote()
			-- 	end,
			-- 	desc = "Remote Flash",
			-- },
			-- {
			-- 	"R",
			-- 	mode = { "o", "x" },
			-- 	function()
			-- 		require("flash").treesitter_search()
			-- 	end,
			-- 	desc = "Treesitter Search",
			-- },
			-- {
			-- 	"<c-s>",
			-- 	mode = { "c" },
			-- 	function()
			-- 		require("flash").toggle()
			-- 	end,
			-- 	desc = "Toggle Flash Search",
			-- },
		},
	},
	{
		"stevearc/oil.nvim",
		version = "2.13.0",
		config = function()
			require("oil").setup({
				columns = {
					"icon",
					"permissions",
					"size",
					"mtime",
				},
				keymaps = {
					-- TODO
				},
				use_default_keymaps = false,
				view_options = {
					show_hidden = true,
				},
			})
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
			local function kulala_fmt()
				return {
					exe = "kulala-fmt",
					args = { "--", vim.api.nvim_buf_get_name(0) },
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
					},
					http = { kulala_fmt },
					rest = { kulala_fmt },
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
				"slint_lsp",
				"regal",
				"snyk-ls",
				"ballerina",
				"bitbake_ls",
				"ltex",
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

			lspconfig.kulala_ls.setup({
				capabilities = capabilities,
				filetypes = { "http", "rest" },
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
				diagnostics = {
					underline = true,
					update_in_insert = false,
					severity_sort = true,
				},
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
							version = "Lua 5.4",
						},
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
		"folke/trouble.nvim",
		version = "3.6.0",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
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
		local supported_modes = { "n", "v" }
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		vim.keymap.set(supported_modes, "<leader>lt", require("trouble").toggle, { silent = true, noremap = true })
		vim.keymap.set(
			supported_modes,
			"<leader>li",
			vim.lsp.buf.implementation,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Jump to implementation" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>lh",
			vim.lsp.buf.hover,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Show hover tips" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>ld",
			vim.lsp.buf.definition,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Jump to definition" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>ldt",
			vim.lsp.buf.type_definition,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Jump to type definition" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>lr",
			vim.lsp.buf.rename,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Rename variable" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>la",
			vim.lsp.buf.code_action,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Apply code action" }
		)
		-- Remove default keybinding added by lspconfig
		-- REF https://neovim.io/doc/user/lsp.html#lsp-config
		vim.keymap.del({ "n" }, "K", { buffer = ev.buf })
	end,
})

-- Set the search path for Lua, so files in .config/nvim/plugins will be loaded
package.path = package.path .. ";" .. vim.fn.getenv("HOME") .. "/.config/nvim/?.lua"

--Sensible default mapping

-- Use space as leader key
vim.g.mapleader = " "

local modes = { "n", "v" }

local mappings = {
	--  Disable popup for commandline
	{ "q:", "<NOP>" },
	{ "<leader>y", '"+y' },
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
	vim.api.nvim_set_option(option[1], option[2])
end

local window_options = {
	{ "wrap", true },
	{ "linebreak", true },
	{ "number", true },
	{ "relativenumber", true },
	{ "signcolumn", "yes" },
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

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({
		"folke/trouble.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		cmd = { "Trouble" },
		commit = "f1168feada93c0154ede4d1fe9183bf69bac54ea",
		config = function()
			require("trouble").setup({
				icons = true,
				position = "bottom",
				-- width = 30,
				-- height = 10,
				use_diagnostic_signs = true,
				indent_lines = false,
				auto_open = true,
				auto_close = true,
			})
		end,
	})
	use({
		"folke/tokyonight.nvim",
		commit = "d1025023b00c6563823dbb5b77951d7b5e9a1a31",
		event = "BufEnter",
		requires = { "kyazdani42/nvim-web-devicons" },
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
	})
	use({
		"lewis6991/gitsigns.nvim",
		event = "CursorHold",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = {
						hl = "GitSignsAdd",
						text = "│",
						numhl = "GitSignsAddNr",
						linehl = "GitSignsAddLn",
					},
					change = {
						hl = "GitSignsChange",
						text = "│",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
					delete = {
						hl = "GitSignsDelete",
						text = "│",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					topdelete = {
						hl = "GitSignsDelete",
						text = "│",
						numhl = "GitSignsDeleteNr",
						linehl = "GitSignsDeleteLn",
					},
					changedelete = {
						hl = "GitSignsChange",
						text = "│",
						numhl = "GitSignsChangeNr",
						linehl = "GitSignsChangeLn",
					},
				},
				current_line_blame = true,
			})
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		commit = "2248ef254d0a1488a72041cfb45ca9caada6d994",
		after = "tokyonight.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
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
							-- color_error = colors.red,
							-- color_warn = colors.yellow,
							-- color_info = colors.cyan,
							color = { bg = colors.bg_statusline },
						},
						{
							-- Check if active LSP exist
							function()
								local msg = ""
								local clients = vim.lsp.get_active_clients()
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
	})
	require("plugins.treesitter").init(use)
	require("plugins.lspconfig").init(use)
	require("plugins.fzf-lua").init(use)
	use({
		"nacro90/numb.nvim",
		commit = "3f7d4a74bd456e747a1278ea1672b26116e0824d",
		config = function()
			require("numb").setup({})
		end,
	})
	-- require("plugins.which-key").init(use)
	require("plugins.hop").init(use)
	use({
		"lukas-reineke/indent-blankline.nvim",
		commit = "29be0919b91fb59eca9e90690d76014233392bef",
		config = function()
			-- vim.g.indent_blankline_use_treesitter = true
			-- vim.g.indent_blankline_char = "│"
			-- vim.g.indent_blankline_space_char = "."

			require("ibl").setup()
		end,
	})
	require("plugins.smart-number").init()
	use({
		"numToStr/Comment.nvim",
		commit = "0236521ea582747b58869cb72f70ccfa967d2e89",
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
	})
	-- require("plugins.quickfix").init(use)
	-- require("plugins.magit").init(use)
	require("plugins.formatter").init(use)
	-- require("plugins.completion").init(use)
	-- require("plugins.range-highlight").init(use)
	-- -- require("plugins.lightspeed").init(use)
	-- require("plugins.better-O").init(use)
	-- -- require('plugins.reverse-J').init(use)
	-- require("plugins.bufferline").init(use)
	-- -- require("plugins.suitcase").init(use)
	-- -- require('plugins.nvim_context_vt').init(use)
end)

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
		{ import = "plugins.cord" },
		{ import = "plugins.operators" },
		{ import = "plugins.flash" },
		{ import = "plugins.oil" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.snacks" },
		{ import = "plugins.which-key" },
		{ import = "plugins.highlight" },
		{ import = "plugins.nvim-lspconfig" },
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

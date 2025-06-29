local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local ERROR_ICON = " "
local WARNING_ICON = " "
local INFO_ICON = " "
local HINT_ICON = "󰌶 "
return {
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
			local should_show_dropbar = function()
				local ok, is_diff_buf = pcall(function()
					return vim.api.nvim_buf_get_var(0, "isdiffbuf")
				end)

				if ok then
					return not is_diff_buf
				end

				return true
			end
			local utility_filetypes = {
				"terminal",
				"snacks_terminal",
				"oil",
				-- "qf",
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
							-- see if we need this again in the future
							-- fmt = function(name, context)
							-- 	local ok, result = pcall(function()
							-- 		return vim.api.nvim_tabpage_get_var(context.tabnr, "tabtitle")
							-- 	end)
							--
							-- 	local tab_title = ""
							--
							-- 	if ok then
							-- 		tab_title = result
							-- 	end
							--
							-- 	if tab_title ~= "" then
							-- 		return tab_title
							-- 	end
							--
							-- 	return vim.fn.getcwd(-1, context.tabnr)
							-- end,
						},
					},
					lualine_y = {},
					lualine_z = {},
				},
				winbar = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							function()
								return _G.dropbar()
							end,
							cond = should_show_dropbar,
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
							function()
								return _G.dropbar()
							end,
							cond = should_show_dropbar,
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
					lualine_b = {
						"branch",
						{
							function()
								return require("grapple").name_or_index()
							end,
							cond = function()
								return package.loaded["grapple"] and require("grapple").exists()
							end,
						},
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
							color = "lualine_c_normal",
							cond = function()
								return not vim.list_contains(utility_filetypes, vim.bo.filetype)
							end,
						},
						{
							"lsp_status",
							icon = "",
							symbols = {
								spinner = spinner,
								done = "",
								separator = " ",
							},
							ignore_lsp = {},
							cond = function()
								return not vim.list_contains(utility_filetypes, vim.bo.filetype)
							end,
							color = "lualine_c_normal",
						},
					},
				},
			})
		end,
	},
}

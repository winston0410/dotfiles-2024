local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local ERROR_ICON = " "
local WARNING_ICON = " "
local INFO_ICON = " "
local HINT_ICON = "󰌶 "

return {
	{
		"rebelot/heirline.nvim",
		event = { "VeryLazy" },
		enabled = true,
		init = function()
			vim.o.showtabline = 2
			vim.o.laststatus = 3
		end,
		config = function()
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")

			local FileEncoding = {
				provider = function()
					return vim.opt.fileencoding:get()
				end,
			}

			local Ruler = {
				provider = function()
					local line = vim.fn.line(".")
					local col = vim.fn.charcol(".")
					return string.format("%d:%-d", line, col)
				end,
			}

			local FileSize = {
				provider = function()
					local suffix = { "B", "kB", "MB", "GB", "TB", "PB", "EB" }
					local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
					size = (size < 0 and 0) or size

					if size < 1000 then
						return size .. suffix[1]
					end

					local i = math.floor(math.log(size) / math.log(1000))
					return string.format("%.2g%s", size / (1000 ^ i), suffix[i + 1])
				end,
			}

			local Tabpage = {
				provider = function(self)
					return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
				end,
				hl = function(self)
					if not self.is_active then
						return "lualine_x_tabs_inactive"
					else
						return "lualine_x_tabs_active"
					end
				end,
			}

			local TabPages = {
				condition = function()
					return true
				end,
				{ provider = "%=" },
				utils.make_tablist(Tabpage),
			}

			local Git = {
				condition = conditions.is_git_repo,

				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
					self.has_changes = self.status_dict.added ~= 0
						or self.status_dict.removed ~= 0
						or self.status_dict.changed ~= 0
				end,

				{
					provider = function(self)
						return " " .. self.status_dict.head
					end,
					hl = { bold = true },
				},
			}

			local ModeNames = {
				["n"] = "NORMAL",
				["no"] = "O-PENDING",
				["nov"] = "O-PENDING",
				["noV"] = "O-PENDING",
				["no\22"] = "O-PENDING",
				["niI"] = "NORMAL",
				["niR"] = "NORMAL",
				["niV"] = "NORMAL",
				["nt"] = "NORMAL",
				["ntT"] = "NORMAL",
				["v"] = "VISUAL",
				["vs"] = "VISUAL",
				["V"] = "V-LINE",
				["Vs"] = "V-LINE",
				["\22"] = "V-BLOCK",
				["\22s"] = "V-BLOCK",
				["s"] = "SELECT",
				["S"] = "S-LINE",
				["\19"] = "S-BLOCK",
				["i"] = "INSERT",
				["ic"] = "INSERT",
				["ix"] = "INSERT",
				["R"] = "REPLACE",
				["Rc"] = "REPLACE",
				["Rx"] = "REPLACE",
				["Rv"] = "V-REPLACE",
				["Rvc"] = "V-REPLACE",
				["Rvx"] = "V-REPLACE",
				["c"] = "COMMAND",
				["cv"] = "EX",
				["ce"] = "EX",
				["r"] = "REPLACE",
				["rm"] = "MORE",
				["r?"] = "CONFIRM",
				["!"] = "SHELL",
				["t"] = "TERMINAL",
			}

			local ModeHighlights = {
				-- NORMAL = { fg = "normal_fg1", bg = "normal_bg1" },
				-- ["O-PENDING"] = { fg = "normal_fg1", bg = "normal_bg1" },
				-- INSERT = { fg = "insert_fg", bg = "insert_bg" },
				-- VISUAL = { fg = "visual_fg", bg = "visual_bg" },
				-- ["V-LINE"] = { fg = "visual_fg", bg = "visual_bg" },
				-- ["V-BLOCK"] = { fg = "visual_fg", bg = "visual_bg" },
				-- SELECT = { fg = "visual_fg", bg = "visual_bg" },
				-- ["S-LINE"] = { fg = "visual_fg", bg = "visual_bg" },
				-- ["S-BLOCK"] = { fg = "visual_fg", bg = "visual_bg" },
				-- REPLACE = { fg = "replace_fg", bg = "replace_bg" },
				-- MORE = { fg = "replace_fg", bg = "replace_bg" },
				-- ["V-REPLACE"] = { fg = "replace_fg", bg = "replace_bg" },
				-- COMMAND = { fg = "command_fg", bg = "command_bg" },
				-- EX = { fg = "command_fg", bg = "command_bg" },
				-- CONFIRM = { fg = "command_fg", bg = "command_bg" },
				-- SHELL = { fg = "command_fg", bg = "command_bg" },
				-- TERMINAL = { fg = "command_fg", bg = "command_bg" },
			}

			local function GetModeName(mode)
				return ModeNames[mode] or "???"
			end

			local Mode = {
				init = function(self)
					self.mode = vim.fn.mode(1)
				end,
				hl = function(self)
					local mode_name = GetModeName(self.mode)
					local mode_hl = ModeHighlights[mode_name] or ModeHighlights.NORMAL
					return { bold = true }
				end,
				{
					provider = function(self)
						return GetModeName(self.mode) .. " "
					end,
				},
			}

			local Diagnostics = {
				condition = conditions.has_diagnostics,
				-- Fetching custom diagnostic icons
				-- error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR],
				-- warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN],
				-- info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO],
				-- hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT],
				--
				init = function(self)
					self.error_icon = ERROR_ICON
					self.warn_icon = WARNING_ICON
					self.info_icon = INFO_ICON
					self.hint_icon = HINT_ICON

					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,

				update = { "DiagnosticChanged", "CursorHold", "BufEnter" },

				{
					provider = function(self)
						-- 0 is just another output, we can decide to print it or not!
						return self.errors > 0 and (self.error_icon .. self.errors .. " ")
					end,
				},
				{
					provider = function(self)
						return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
					end,
				},
				{
					provider = function(self)
						return self.info > 0 and (self.info_icon .. self.info .. " ")
					end,
				},
				{
					provider = function(self)
						return self.hints > 0 and (self.hint_icon .. self.hints)
					end,
				},
			}
			require("heirline").setup({
				statusline = {
					Mode,
					Git,
					{ provider = " " },
					Ruler,
					{ provider = " " },
					FileEncoding,
					{ provider = " " },
					FileSize,
					{ provider = "%=" },
					Diagnostics,
				},
				winbar = {
					{
						provider = function()
							return _G.dropbar()
						end,
					},
				},
				-- statuscolumn = {},
				tabline = { TabPages },
				opts = {
					disable_winbar_cb = function(args)
						return require("heirline.conditions").buffer_matches({
							-- buftype = { "nofile", "prompt", "help", "quickfix" },
							-- filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
							buftype = { "nofile", "help", "quickfix" },
							filetype = { "dashboard" },
						}, args.buf)
					end,
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = { "VeryLazy" },
		enabled = false,
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
				"k8s_pods",
				"terminal",
				"snacks_terminal",
				"oil",
				"qf",
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
						--
						-- {
						-- 	"buffers",
						-- 	mode = 0,
						-- 	icons_enabled = true,
						-- 	max_length = function()
						-- 		return vim.o.columns / 2
						-- 	end,
						-- 	filetype_names = {
						-- 		checkhealth = "Healthcheck",
						-- 		qf = "Quickfix",
						-- 	},
						-- 	symbols = {
						-- 		modified = "[+]",
						-- 		alternate_file = "",
						-- 	},
						-- 	cond = should_show_buffers,
						-- },
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
					},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{
							"searchcount",
							maxcount = 999,
							timeout = 500,
						},
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
						-- {
						-- 	"lsp_status",
						-- 	icon = "",
						-- 	symbols = {
						-- 		spinner = spinner,
						-- 		done = "",
						-- 		separator = " ",
						-- 	},
						-- 	ignore_lsp = {},
						-- 	cond = function()
						-- 		return not vim.list_contains(utility_filetypes, vim.bo.filetype)
						-- 	end,
						-- 	color = "lualine_c_normal",
						-- },
					},
				},
			})
		end,
	},
}

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

return {
	{
		"rebelot/heirline.nvim",
		priority = 9998,
		dependencies = {
			{
				"Zeioth/heirline-components.nvim",
				version = "3.x",
				dependencies = { "lewis6991/gitsigns.nvim" },
				opts = {
					icons = {
						GitBranch = "",
					},
				},
			},
			{
				"stevearc/aerial.nvim",
				opts = {},
				enabled = false,
				dependencies = {
					"nvim-treesitter/nvim-treesitter",
					"nvim-tree/nvim-web-devicons",
				},
			},
			{
				"Bekaboo/dropbar.nvim",
				version = "12.x",
				lazy = false,
				dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
				keys = {
					{
						"<leader>ps",
						function()
							require("dropbar.api").pick()
						end,
						mode = { "n" },
						silent = true,
						noremap = true,
						expr = true,
						desc = "Search symobls",
					},
				},
				init = function()
					vim.o.mousemoveevent = true
				end,
				config = function()
					require("dropbar").setup({
						bar = {
							---@type dropbar_source_t[]|fun(buf: integer, win: integer): dropbar_source_t[]
							sources = function(buf, _)
								local sources = require("dropbar.sources")
								if vim.bo[buf].buftype == "terminal" then
									return {
										sources.terminal,
									}
								end

								return {
									sources.path,
								}
							end,
						},

						sources = {
							path = {
								modified = function(sym)
									return sym:merge({
										name = sym.name .. "[+]",
									})
								end,
							},
							lsp = {
								valid_symbols = {
									"File",
									"Module",
									"Namespace",
									"Package",
									"Class",
									"Method",
									"Property",
									"Field",
									"Constructor",
									"Enum",
									"Interface",
									"Function",
									"Object",
									"Keyword",
									"EnumMember",
									"Struct",
									"Event",
									"Operator",
									"TypeParameter",
									-- NOTE exclude all primitive variables
									-- "Variable",
									-- "Constant",
									-- "String",
									-- "Number",
									-- "Boolean",
									-- "Array",
									-- "Null",
								},
							},
							treesitter = {
								valid_types = {
									"block_mapping_pair",
									"array",
									"break_statement",
									"call",
									"case_statement",
									"class",
									"constant",
									"constructor",
									"continue_statement",
									"delete",
									"do_statement",
									"element",
									"enum",
									"enum_member",
									"event",
									"for_statement",
									"function",
									"goto_statement",
									"h1_marker",
									"h2_marker",
									"h3_marker",
									"h4_marker",
									"h5_marker",
									"h6_marker",
									"if_statement",
									"interface",
									"keyword",
									"macro",
									"method",
									"module",
									"namespace",
									"operator",
									"package",
									"pair",
									"property",
									"reference",
									"repeat",
									"return_statement",
									"rule_set",
									"scope",
									"specifier",
									"struct",
									"switch_statement",
									"table",
									"type",
									"type_parameter",
									"unit",
									"while_statement",
									"declaration",
									"field",
									"identifier",
									"object",
									"statement",
									-- NOTE exclude all primitive variables
									-- "value",
									-- "variable",
									-- "null",
									-- "boolean",
									-- "number",
								},
							},
						},
					})
				end,
			},
		},
		enabled = true,
		init = function()
			vim.o.showtabline = 2
			vim.o.laststatus = 3
		end,
		config = function()
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")
			local heirline = require("heirline")
			local heirline_components = require("heirline-components.all")
			local hydra_statusline = require("hydra.statusline")

			heirline_components.init.subscribe_to_events()
			-- FIXME heirline-compoments would reload color after colorscheme has changed, we need to set our custom color again as well
			heirline.load_colors(heirline_components.hl.get_colors())

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
						return "TabLine"
					else
						return "TabLineFill"
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

			local dmode_enabled = false
			vim.api.nvim_create_autocmd("User", {
				pattern = "DebugModeChanged",
				callback = function(args)
					dmode_enabled = args.data.enabled
				end,
			})

			local Mode = heirline_components.component.builder({
				{
					provider = function()
						local text = heirline_components.env.modes[vim.fn.mode()][1]
						local hydra_mode = hydra_statusline.get_name()
						if hydra_mode ~= nil then
							text = string.format(" %s ", hydra_mode:upper())
						end
						-- print(hydra_statusline.get_color())
						-- if dmode_enabled then
						-- 	text = "DEBUG"
						-- end
						local opts = {}
						return heirline_components.utils.stylize(text, opts)
					end,
				},
				surround = {
					separator = "left",
					color = function()
						local hydra_mode = hydra_statusline.get_name()
						if hydra_mode ~= nil then
							return string.format("hydra_%s", hydra_mode:lower())
						end
						local hl = heirline_components.hl.mode_bg()
						return hl
					end,
				},
				hl = heirline_components.hl.get_attributes("mode"),
			})

			require("heirline").setup({
				statusline = {
					Mode,
                    -- FIXME no idea why its position is fixed
                    -- heirline_components.component.git_diff(),
					heirline_components.component.git_branch({}),
					heirline_components.component.file_encoding({
						file_format = { padding = { left = 0, right = 0 } },
					}),
					{ provider = " " },
					FileSize,
					{ provider = "%=" },
					heirline_components.component.diagnostics(),
					heirline_components.component.cmd_info(),
					heirline_components.component.nav({ percentage = false }),
				},
				winbar = {
					{
						provider = function()
							return _G.dropbar()
						end,
					},
				},
				statuscolumn = {
					heirline_components.component.numbercolumn(),
					heirline_components.component.signcolumn(),
					{
						provider = "%C",
					},
				},
				tabline = { TabPages },
				opts = {
					colors = {
						hydra_window = utils.get_highlight("Constant").fg,
						hydra_treewalk = utils.get_highlight("@comment.info").fg,
						hydra_surround = utils.get_highlight("@comment.info").fg,
						hydra_exchange = utils.get_highlight("@comment.info").fg,
					},
					disable_winbar_cb = function(args)
						return require("heirline.conditions").buffer_matches({
							buftype = { "nofile", "help", "quickfix" },
							filetype = {
								"OverseerForm",
								"dashboard",
								"^k8s_*",
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
							},
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

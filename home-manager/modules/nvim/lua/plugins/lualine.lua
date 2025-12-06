local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local godot = require("custom.godot")

return {
	{
		"rebelot/heirline.nvim",
		event = { "VeryLazy" },
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
                    -- NOTE this doesn't work at all
					-- {
					-- 	"<leader>ps",
					-- 	function()
					-- 		require("dropbar.api").pick()
					-- 	end,
					-- 	mode = { "n" },
					-- 	silent = true,
					-- 	noremap = true,
					-- 	expr = true,
					-- 	desc = "Search symobls",
					-- },
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
			-- local hydra_statusline = require("hydra.statusline")

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
            
            local GoDotExternalEditor = {
				condition = function()
                    return vim.tbl_contains(vim.fn.serverlist(), godot.GODOT_EXTERNAL_EDITOR_PIPE)
				end,
                provider = function()
                    return " Godot"
                end,
            }

			require("heirline").setup({
				statusline = {
                    heirline_components.component.mode({ mode_text = {} }),
					-- Mode,
                    -- FIXME no idea why its position is fixed
                    -- heirline_components.component.git_diff(),
					heirline_components.component.git_branch({}),
					heirline_components.component.file_encoding({
						file_format = { padding = { left = 0, right = 0 } },
					}),
					{ provider = " " },
					FileSize,
					{ provider = " " },
                    GoDotExternalEditor,
                    heirline_components.component.fill(),
                    heirline_components.component.lsp({ lsp_client_names = false }),
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
					heirline_components.component.signcolumn(),
					heirline_components.component.numbercolumn(),
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
						hydra_kulala = utils.get_highlight("@comment.info").fg,
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
}

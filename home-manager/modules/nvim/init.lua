-- # Config principle
-- 1. When defining mappings are related with operators and textobjects, follow the verb -> noun convention, so we don't have to go into visual mode all the time to get things done like in Helix
-- 2. When defining mappings that are not related with operators and textobjects, follow the noun -> verb convention, as there could be conflicting actions between different topics, making mappings definition difficult
-- 3. Following the default Vim's mapping semantic and enhance it

-- ## Operators
-- REF https://neovim.io/doc/user/motion.html#operator
-- We only use c, d, y, p, >, <, <leader>c, gq and ~ operator for manipulating textobjects.
-- And finally gx for opening url in neovim.
-- For compound operators, for example change surround, the topic specific operator should precede generic operator( i.e. we should use sc instead of cs. ), so that we will not confuse the topic speicifc operator with textobjects.

-- ## Register
-- for deleting without polluting the current register, use blackhold register _, for example "_dd
require("custom.essential")
local utils = require("custom.utils")
if vim.g.enable_session == nil then
	vim.g.enable_session = true
end
local ERROR_ICON = " "
local WARNING_ICON = " "
local INFO_ICON = " "
local HINT_ICON = "󰌶 "

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

-- REF https://unix.stackexchange.com/a/637223/467987

-- vim.keymap.set({ "n" }, "[z", "zj", { silent = true, noremap = true, desc = "Jump to previous fold" })
-- vim.keymap.set({ "n" }, "]z", "zk", { silent = true, noremap = true, desc = "Jump to next fold" })

-- TODO how can I always open helpfiles in a tab?

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
			"martineausimon/nvim-lilypond-suite",
			cmd = { "LilyPlayer", "LilyCmp", "LilyDebug" },
			config = function()
				require("nvls").setup({})
			end,
		},
		{
			"nvim-neorg/neorg",
			ft = { "norg" },
			enabled = false,
			dependencies = { "pysan3/pathlib.nvim", "nvim-neorg/lua-utils.nvim", "nvim-neotest/nvim-nio" },
			version = "9.x",
			config = function()
				-- NOTE https://github.com/nvim-neorg/neorg/blob/53714b1783d4bb5fa154e2a5428b086fb5f3d8a5/res/wiki/static/Setup-Guide.md
				require("neorg").setup({
					load = {
						["core.defaults"] = {},
						["core.concealer"] = {},
					},
				})
			end,
		},
		{
			"Shatur/neovim-session-manager",
			dependencies = { "nvim-lua/plenary.nvim" },
			lazy = false,
			priority = 998,
			enabled = vim.g.enable_session,
			config = function()
				local config = require("session_manager.config")
				require("session_manager").setup({
					autoload_mode = {
						config.AutoloadMode.GitSession,
						config.AutoloadMode.CurrentDir,
						config.AutoloadMode.Disabled,
					},
					autosave_last_session = true,
					autosave_ignore_not_normal = true,
					autosave_ignore_filetypes = {
						"gitcommit",
						"gitrebase",
					},
				})
			end,
		},
		{
			"Apeiros-46B/qalc.nvim",
			ft = { "qalc" },
			cmd = { "Qalc" },
			config = function()
				require("qalc").setup({})
			end,
		},
		{
			"Bekaboo/dropbar.nvim",
			version = "12.x",
			-- FIXME dropbar pick does not work, after recovering from a session
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
					sources = {
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
		{
			"jackplus-xyz/player-one.nvim",
			enabled = false,
			opts = {
				is_enabled = true,
				debug = true,
			},
		},
		{
			"cbochs/grapple.nvim",
			dependencies = {
				{ "nvim-tree/nvim-web-devicons", lazy = true },
			},
			config = function()
				-- TODO wait for tag_hook to be documented, and we can override it to change keymapping inside tag windows
				require("grapple").setup({
					scope = "git_branch",
				})
			end,
			event = { "BufReadPost", "BufNewFile" },
			cmd = "Grapple",
			keys = {
				-- {
				-- 	"<leader>mm",
				-- 	function()
				-- 		require("grapple").toggle({})
				-- 	end,
				-- 	desc = "Grapple toggle tag",
				-- },
				{
					"<leader>p<leader>m",
					function()
						require("grapple").toggle_tags({})
					end,
					silent = true,
					noremap = true,
					desc = "Grapple toggle tags window",
				},
				{
					"<leader>mi",
					function()
						require("grapple").cycle_tags("next")
					end,
					silent = true,
					noremap = true,
					desc = "Grapple cycle next tag",
				},
				{
					"<leader>mo",
					function()
						require("grapple").cycle_tags("prev")
					end,
					silent = true,
					noremap = true,
					desc = "Grapple cycle previous tag",
				},
				{
					"<leader>mv",
					function()
						vim.ui.input({ prompt = "Grapple tag name" }, function(input)
							if input == nil then
								return
							end
							require("grapple").tag({ name = input })
							vim.notify("Grapple tag created", vim.log.levels.INFO)
						end)
					end,
					silent = true,
					noremap = true,
					desc = "Grapple add tag",
				},
				{
					"<leader>mq",
					function()
						require("grapple").untag()
						vim.notify("Grapple tag removed", vim.log.levels.INFO)
					end,
					silent = true,
					noremap = true,
					desc = "Grapple delete tag",
				},
			},
		},
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			version = "2.x",
			config = function()
				---@type Flash.Config
				require("flash").setup({
					highlight = {
						backdrop = false,
						matches = true,
					},
					---@type table<string, Flash.Config>
					modes = {
						search = {
							enabled = false,
						},
						char = {
							enabled = true,
							highlight = {
								backdrop = false,
							},
						},
					},
				})
			end,
			keys = {
				{
					"<leader>f",
					mode = { "n", "x", "o" },
					function()
						require("flash").jump({
							remote_op = {
								restore = true,
								motion = true,
							},
						})
					end,
					noremap = true,
					desc = "Flash",
				},
			},
		},
		{
			"olimorris/codecompanion.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				{
					"ravitemer/mcphub.nvim",
					dependencies = {
						"nvim-lua/plenary.nvim",
					},
					version = "5.x",
					cmd = { "MCPHub" },
					build = "bundled_build.lua",
					config = function()
						require("mcphub").setup({
							auto_approve = true,
							use_bundled_binary = true,
							port = 3000,
							config = vim.fn.expand("~/.config/mcphub/servers.json"),
							log = {
								level = vim.log.levels.WARN,
								to_file = false,
								file_path = nil,
								prefix = "MCPHub",
							},
						})
					end,
				},
				{
					"MeanderingProgrammer/render-markdown.nvim",
					version = "8.x",
					ft = { "markdown", "codecompanion" },
				},
				{
					"HakonHarnes/img-clip.nvim",
					version = "0.x",
					event = "VeryLazy",
					opts = {
						filetypes = {
							codecompanion = {
								prompt_for_file_name = false,
								template = "[Image]($FILE_PATH)",
								use_absolute_path = true,
							},
						},
					},
				},
			},
			cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
			event = { "VeryLazy" },
			version = "15.x",
			config = function()
				require("codecompanion").setup({
					auto_approve = true,
					-- https://codecompanion.olimorris.dev/configuration/adapters.html#changing-a-model
					adapters = {
						gemini = function()
							return require("codecompanion.adapters").extend("gemini", {
								env = {
									api_key = "cmd:bw get password GEMINI_API_KEY | xargs",
								},
								schema = {
									model = {
										default = "gemini-2.0-flash",
									},
								},
							})
						end,
					},
					extensions = {
						mcphub = {
							callback = "mcphub.extensions.codecompanion",
							opts = {
								show_result_in_chat = true,
								make_vars = true,
								make_slash_commands = true,
							},
						},
					},
					strategies = {
						chat = {
							adapter = "gemini",
						},
						inline = {
							adapter = "gemini",
							keymaps = {
								accept_change = {
									modes = { n = "do" },
									description = "Accept the suggested change",
								},
								reject_change = {
									modes = { n = "dp" },
									description = "Reject the suggested change",
								},
							},
						},
					},
					display = {
						diff = {
							enabled = true,
							layout = "vertical",
							provider = "default",
						},
					},
				})
			end,
		},
		{
			"zeioth/garbage-day.nvim",
			dependencies = {},
			event = { "VeryLazy" },
			opts = {
				wakeup_delay = 250,
				grace_period = 60 * 10,
			},
		},
		{
			"sphamba/smear-cursor.nvim",
			enabled = false,
			cmd = { "SmearCursorToggle" },
			event = { "CursorHold" },
			opts = {},
		},
		{
			"nacro90/numb.nvim",
			enabled = true,
			event = { "CmdlineEnter" },
			config = function()
				require("numb").setup()
			end,
		},
		{
			"winston0410/range-highlight.nvim",
			event = { "CmdlineEnter" },
			opts = {},
		},
		{
			"winston0410/encoding.nvim",
			keys = {
				{
					"<leader>ee1",
					function()
						require("encoding").base64_encode()
					end,

					mode = { "n", "x" },
					silent = true,
					noremap = true,
					desc = "Base64 encode",
				},
				{
					"<leader>ee2",
					function()
						require("encoding").uri_encode()
					end,

					mode = { "n", "x" },
					silent = true,
					noremap = true,
					desc = "URI encode",
				},

				{
					"<leader>ed1",
					function()
						require("encoding").base64_decode()
					end,

					mode = { "n", "x" },
					silent = true,
					noremap = true,
					desc = "Base64 decode",
				},
				{
					"<leader>ed2",
					function()
						require("encoding").uri_decode()
					end,

					mode = { "n", "x" },
					silent = true,
					noremap = true,
					desc = "URI decode",
				},
			},
			opts = {},
		},
		{
			"saghen/blink.cmp",
			event = "InsertEnter",
			dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
			version = "1.x",
			opts = {
				keymap = {
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<CR>"] = { "select_and_accept", "fallback" },
					["<Tab>"] = {
						function(cmp)
							if cmp.snippet_active() then
								return cmp.accept()
							else
								return cmp.select_and_accept()
							end
						end,
						"snippet_forward",
						"fallback",
					},
					["<S-Tab>"] = { "snippet_backward", "fallback" },
				},

				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},

				snippets = { preset = "luasnip" },

				sources = {
					default = { "lsp", "path", "snippets", "buffer", "omni" },
					per_filetype = {
						codecompanion = { inherit_defaults = false, "codecompanion" },
					},
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
						auto_show_delay_ms = 400,
					},
					ghost_text = { enabled = true, show_with_menu = false },
				},
				signature = { enabled = true },
				fuzzy = { implementation = "prefer_rust_with_warning" },
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
		{
			"s1n7ax/nvim-window-picker",
			name = "window-picker",
			event = "VeryLazy",
			version = "2.*",
			keys = {
				{
					"<leader>p<leader>w",
					function()
						local picked_window_id = require("window-picker").pick_window()
						if picked_window_id == nil then
							return
						end
						vim.api.nvim_set_current_win(picked_window_id)
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Pick window",
				},
				{
					"x<leader>w",
					function()
						local to_win_id = require("window-picker").pick_window()
						if to_win_id == nil then
							return
						end

						local from_win_id = vim.api.nvim_get_current_win()
						if from_win_id == to_win_id then
							return
						end

						local from_buf = vim.api.nvim_win_get_buf(from_win_id)
						local to_buf = vim.api.nvim_win_get_buf(to_win_id)

						local original_cursor_pos = vim.api.nvim_win_get_cursor(from_win_id)

						vim.api.nvim_win_set_buf(from_win_id, to_buf)
						vim.api.nvim_win_set_buf(to_win_id, from_buf)

						local cur_buf_after_swap = vim.api.nvim_get_current_buf()
						if cur_buf_after_swap == from_buf then
							return
						end

						vim.api.nvim_win_set_cursor(to_win_id, original_cursor_pos)
						vim.api.nvim_set_current_win(to_win_id)
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Swap buffer between windows",
				},
			},
			config = function()
				require("window-picker").setup({
					show_prompt = false,
					hint = "floating-big-letter",
				})
			end,
		},
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				-- TODO revisit this plugin, once we switch to 0.11
				-- { "igorlfs/nvim-dap-view", opts = {} },
				{
					"mfussenegger/nvim-dap-python",
					ft = { "python" },
					config = function()
						-- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#usage
						require("dap-python").setup("uv")
					end,
				},
				{
					"suketa/nvim-dap-ruby",
					ft = { "ruby" },
					config = function()
						require("dap-ruby").setup()
					end,
				},

				{
					"leoluz/nvim-dap-go",
					ft = { "go" },
					config = function()
						require("dap-go").setup({
							dap_configurations = {
								{
									type = "go",
									name = "Attach remote",
									mode = "remote",
									request = "attach",
								},
							},
							delve = {
								path = "dlv",
								initialize_timeout_sec = 20,
								port = "${port}",
								args = {},
								build_flags = {},
								detached = vim.fn.has("win32") == 0,
								cwd = nil,
							},
							tests = {
								verbose = false,
							},
						})
					end,
				},
			},
			config = function()
				local dap = require("dap")
				--             local dv = require("dap-view")
				-- dap.listeners.before.attach["dap-view-config"] = function()
				-- 	dv.open()
				-- end
				-- dap.listeners.before.launch["dap-view-config"] = function()
				-- 	dv.open()
				-- end
				-- dap.listeners.before.event_terminated["dap-view-config"] = function()
				-- 	dv.close()
				-- end
				-- dap.listeners.before.event_exited["dap-view-config"] = function()
				-- 	dv.close()
				-- end
				-- REF https://www.compart.com/en/unicode/search?q=circle#characters
				vim.fn.sign_define(
					"DapBreakpoint",
					{ text = "●", texthl = "DapUIStop", linehl = "", numhl = "", priority = 90 }
				)
				vim.fn.sign_define(
					"DapBreakpointCondition",
					{ text = "⊜", texthl = "DapUIStop", linehl = "", numhl = "", priority = 91 }
				)
				vim.fn.sign_define(
					"DapStopped",
					{ text = "→", texthl = "", linehl = "DapUIPlayPause", numhl = "", priority = 99 }
				)

				dap.adapters.dart = {
					type = "executable",
					command = "dart",
					args = { "debug_adapter" },
					options = {
						detached = true,
					},
				}
				dap.adapters.kotlin = {
					type = "executable",
					command = "kotlin-debug-adapter",
					options = { auto_continue_if_many_stopped = false },
				}
				dap.adapters.ocamlearlybird = {
					type = "executable",
					command = "ocamlearlybird",
					args = { "debug" },
				}
				dap.adapters.mix_task = {
					type = "executable",
					command = "elixir-debug-adapter",
					args = {},
				}
				dap.adapters.coreclr = {
					type = "executable",
					command = "netcoredbg",
					args = { "--interpreter=vscode" },
				}
				dap.configurations.cs = {
					{
						type = "coreclr",
						name = "launch - netcoredbg",
						request = "launch",
						program = function()
							return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
						end,
					},
				}
				dap.adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "js-debug",
						args = { "${port}" },
					},
				}
				dap.configurations.javascript = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
				}
			end,
			keys = {
				{
					"<leader>db",
					function()
						require("dap").toggle_breakpoint()
					end,
					silent = true,
					noremap = true,
					desc = "Toggle breakpoint",
				},
				{
					"<leader>dc",
					function()
						require("dap").continue()
					end,
					desc = "Continue",
				},

				-- {
				-- 	"<leader>dC",
				-- 	function()
				-- 		require("dap").run_to_cursor()
				-- 	end,
				-- 	desc = "Run to Cursor",
				-- },

				{
					"<leader>dt",
					function()
						require("dap").terminate()
					end,
					desc = "Terminate debug session",
				},
			},
		},

		{
			"chentoast/marks.nvim",
			event = { "VeryLazy" },
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
					"codecompanion",
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
		-- TODO set up this colorpicker
		{
			"nvzone/minty",
			enabled = false,
			cmd = { "Shades", "Huefy" },
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
					view = {
						default = {
							layout = "diff2_horizontal",
						},
						merge_tool = {
							layout = "diff3_mixed",
						},
						file_history = {
							layout = "diff2_horizontal",
						},
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
							-- {
							-- 	"n",
							-- 	"<leader>ed",
							-- 	actions.cycle_layout,
							-- 	{ desc = "Cycle through available layouts." },
							-- },
							{
								"n",
								"<leader>pf",
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

				local autocmd_callback = function(ev)
					vim.api.nvim_set_option_value("foldenable", false, { scope = "local" })
					vim.api.nvim_set_option_value("foldcolumn", "0", { scope = "local" })
					vim.api.nvim_set_option_value("wrap", false, { scope = "local" })

					vim.keymap.set(
						"n",
						"[h",
						"[c",
						{ noremap = true, silent = true, desc = "Jump to the previous hunk" }
					)
					vim.keymap.set("n", "]h", "]c", { noremap = true, silent = true, desc = "Jump to the next hunk" })

					vim.api.nvim_buf_set_var(ev.buf, "isdiffbuf", true)
					vim.api.nvim_buf_set_var(ev.buf, "lockbuffer", true)
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
					callback = function(ev)
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFileHistory")
						vim.api.nvim_tabpage_set_var(tab_id, "lockbuffer", true)
						vim.api.nvim_buf_set_var(ev.buf, "lockbuffer", true)
					end,
				})
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "DiffviewFiles",
					callback = function(ev)
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFiles")
						vim.api.nvim_buf_set_var(ev.buf, "lockbuffer", true)
						vim.api.nvim_tabpage_set_var(tab_id, "lockbuffer", true)
					end,
				})
			end,
		},
		{
			"chrisgrieser/nvim-recorder",
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
					"<leader>gg",
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
				-- FIXME range diffing is not working correctly, cannot select the target of "to"
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
			"mrjones2014/smart-splits.nvim",
			version = "1.x",
			keys = {
				{
					"<leader>w>",
					function()
						require("smart-splits").resize_right()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to right",
				},
				{
					"<C-w>>",
					function()
						require("smart-splits").resize_right()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to right",
				},
				{
					"<C-w><",
					function()
						require("smart-splits").resize_left()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to left",
				},
				{
					"<leader>w<",
					function()
						require("smart-splits").resize_left()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to left",
				},
				{
					"<leader>w+",
					function()
						require("smart-splits").resize_up()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to top",
				},
				{
					"<C-w>+",
					function()
						require("smart-splits").resize_up()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to top",
				},
				{
					"<leader>w-",
					function()
						require("smart-splits").resize_down()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to bottom",
				},
				{
					"<C-w>-",
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
			event = { "VeryLazy" },
			opts = {
				render = "virtual",
				enable_tailwind = true,
				exclude_filetypes = {
					"lazy",
					"checkhealth",
					"qf",
					"snacks_dashboard",
					"snacks_picker_list",
					"snacks_picker_input",
				},
				exclude_buftypes = {},
			},
		},
		{
			"lewis6991/gitsigns.nvim",
			version = "0.9.0",
			event = { "VeryLazy" },
			keys = {
				-- TODO how to select local diff hunk?????
				{
					"gh",
					function()
						require("gitsigns").select_hunk()
					end,
					mode = { "o", "x" },
					silent = true,
					noremap = true,
					desc = "Git hunk",
				},
				{
					"agh",
					function()
						require("gitsigns").select_hunk()
					end,
					mode = { "o", "x" },
					silent = true,
					noremap = true,
					desc = "Git hunk",
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
				linehl = false,
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
			version = "1.x",
			cmd = { "Kubectl", "Kubectx", "Kubens" },
			keys = {
				{
					"<leader>K",
					function()
						require("kubectl").toggle({ tab = true })
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "kubectl.nvim panel",
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
			version = "5.x",
			ft = { "http", "rest" },
			opts = {
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
		{
			"mcauley-penney/visual-whitespace.nvim",
			-- this plugin is too intrusive
			enabled = false,
			opts = {},
		},
		{
			"NStefan002/screenkey.nvim",
			lazy = false,
			version = "*",
			config = function()
				require("screenkey").setup({})
			end,
		},

		{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = { "VeryLazy" } },
		{ import = "plugins.operators" },
		{ import = "plugins.themes" },
		{ import = "plugins.nvim-lspconfig" },
		{ import = "plugins.flash" },
		{ import = "plugins.oil" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.snacks" },
		{ import = "plugins.which-key" },
		{ import = "plugins.conform" },
		{
			"tzachar/highlight-undo.nvim",
			enabled = true,
			event = "VeryLazy",
			opts = {
				hlgroup = "Visual",
				duration = 500,
				pattern = { "*" },
				ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "snacks_dashboard" },
			},
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
			ft = { "qf" },
			keys = {
				{
					"<leader>kk",
					function()
						require("quicker").toggle()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open quickfix list",
				},
			},
			config = function()
				require("quicker").setup({
					keys = {},
					borders = {
						vert = "│",
					},
					opts = {
						buflisted = false,
						number = false,
						relativenumber = false,
						signcolumn = "no",
						winfixheight = true,
						wrap = false,
					},
					follow = {
						enabled = false,
					},
				})
			end,
		},
		{
			"folke/edgy.nvim",
			version = "1.x",
			event = "VeryLazy",
			enabled = false,
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
			version = "3.x",
			event = { "BufReadPre", "BufNewFile" },
			enabled = false,
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

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		local qflist_id = 1
		local diagnostics = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
		local items = vim.diagnostic.toqflist(diagnostics)
		vim.fn.setqflist({}, "r", { id = qflist_id, title = "Diagnostics", items = items })
	end,
})

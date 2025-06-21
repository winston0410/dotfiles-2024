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
		-- Where to check themes
		-- https://vimcolorschemes.com/i/trending/b.dark
		-- https://github.com/mcchrish/vim-no-color-collections
		-- Too high constrast, but seems to have a good design theory
		{
			"nuvic/flexoki-nvim",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"flexoki.lua",
					-- don't look good in dark theme
					"flexoki-moon.lua",
				})
			end,
		},
		{ "miikanissi/modus-themes.nvim", lazy = true, enabled = false },
		-- comment is too dark when using lackluster
		{
			"slugbyte/lackluster.nvim",
			enabled = false,
			lazy = true,
		},
		{
			"AlexvZyl/nordic.nvim",
			lazy = true,
		},
		{
			"thesimonho/kanagawa-paper.nvim",
			lazy = true,
		},
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
			"wnkz/monoglow.nvim",
			init = function()
				vim.opt.wildignore:append({
					"monoglow.lua",
					"monoglow-void.lua",
					"monoglow-lack.lua",
				})
			end,
			config = function()
				require("monoglow").setup({
					on_colors = function() end,
					on_highlights = function() end,
				})
			end,
			lazy = true,
		},
		{
			"alexxGmZ/e-ink.nvim",
			lazy = true,
			init = function()
				vim.opt.background = "dark"
			end,
			config = function()
				-- NOTE somehow defining in init does not work, defining again
				vim.opt.background = "dark"
				require("e-ink").setup()
			end,
		},
		{
			"rose-pine/neovim",
			name = "rose-pine",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"rose-pine.lua",
					"rose-pine-dawn.lua",
				})
			end,
		},
		{
			"projekt0n/github-nvim-theme",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"github_dark.vim",
					"github_dark_default.vim",
					"github_dark_tritanopia.vim",
					"github_dark_high_contrast.vim",
					"github_dark_dimmed.vim",
					"github_light.vim",
					"github_light_default.vim",
					"github_light_tritanopia.vim",
					"github_light_colorblind.vim",
					"github_light_high_contrast.vim",
				})
			end,
		},
		{
			"EdenEast/nightfox.nvim",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"dawnfox.vim",
					"dayfox.vim",
					"nightfox.vim",
				})
			end,
		},

		{
			"ecthelionvi/NeoComposer.nvim",
			event = { "VeryLazy" },
			dependencies = { "kkharji/sqlite.lua" },
			init = function()
				vim.opt.shortmess:append("q")
			end,
			opts = {
				keymaps = {
					play_macro = "Q",
					yank_macro = false,
					stop_macro = false,
					toggle_record = "q",
					cycle_next = false,
					cycle_prev = false,
					toggle_macro_menu = "<leader>q",
				},
			},
		},
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
			"nvimtools/none-ls.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "ckolkey/ts-node-action", "ThePrimeagen/refactoring.nvim" },
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local null_ls = require("null-ls")

				null_ls.setup({
					sources = {
						null_ls.builtins.diagnostics.checkmake,
						null_ls.builtins.diagnostics.fish,
						null_ls.builtins.diagnostics.haml_lint,
						null_ls.builtins.diagnostics.terraform_validate,
						null_ls.builtins.diagnostics.tidy,
						null_ls.builtins.diagnostics.hadolint,
						null_ls.builtins.diagnostics.golangci_lint,
						null_ls.builtins.diagnostics.opacheck,
						null_ls.builtins.code_actions.refactoring,
						null_ls.builtins.code_actions.ts_node_action,
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
			"kylechui/nvim-surround",
			version = "*",
			-- NOTE By default, s is a useless synonym of cc, therefore we remap that
			keys = {
				{ "s", mode = "n" },
				{ "ss", mode = "n" },
				{ "cs", mode = "n" },
				{ "ds", mode = "n" },
				{ "s", mode = "x" },
			},
			config = function()
				require("nvim-surround").setup({
					keymaps = {
						insert = false,
						insert_line = false,
						normal = "s",
						normal_cur = "ss",
						normal_line = false,
						normal_cur_line = false,
						visual = "s",
						visual_line = false,
						delete = "ds",
						change = "cs",
						change_line = false,
					},
					aliases = {},
				})
			end,
		},
		{
			"gbprod/substitute.nvim",
			keys = {
				-- Use <esc> to cancel an exchange
				{
					"x",
					function()
						require("substitute.exchange").operator()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Exchange",
				},
				{
					"x",
					function()
						require("substitute.exchange").visual()
					end,
					mode = { "x" },
					silent = true,
					noremap = true,
					desc = "Exchange",
				},
				{
					"xx",
					function()
						require("substitute.exchange").line()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Exchange line",
				},
			},
			config = function()
				require("substitute").setup()
				vim.api.nvim_set_hl(0, "SubstituteSubstituted", { link = "Visual" })
				vim.api.nvim_set_hl(0, "SubstituteRange", { link = "Visual" })
				vim.api.nvim_set_hl(0, "SubstituteExchange", { link = "Visual" })
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
			},
			config = function()
				require("window-picker").setup({
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
			"chrisgrieser/nvim-spider",
			keys = {
				{
					"W",
					function()
						require("spider").motion("w")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to word",
				},
				{
					"w",
					function()
						require("spider").motion("w")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to word",
				},
				{
					"e",
					function()
						require("spider").motion("e")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to end of word",
				},
				{
					"E",
					function()
						require("spider").motion("e")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to end of word",
				},
				{
					"b",
					function()
						require("spider").motion("b")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump backward to word",
				},
				{
					"B",
					function()
						require("spider").motion("b")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump backward to word",
				},
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
					"trouble",
					-- "qf",
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
							{ require("NeoComposer.ui").status_recording },
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
			"folke/which-key.nvim",
			event = "VeryLazy",
			version = "3.x",
			keys = {
				{
					"?",
					function()
						require("which-key").show({ global = true, loop = true })
					end,
					silent = true,
					noremap = true,
					desc = "Show local keymaps",
				},
			},
			config = function()
				local wk = require("which-key")
				local ignored_bindings = {
					"z<CR>",
					"z=",
					"zH",
					"zL",
					"zb",
					"ze",
					"zg",
					"zs",
					"zt",
					"zv",
					"zw",
					"zz",
					-- NOTE ignored as we don't use regular f,t
					",",
					";",
					-- NOTE ignored as this is a synonym
					"&",
					-- NOTE default binding set by neovim that does not use treesitter
					"[m",
					"]m",
					"[M",
					"]M",
					-- NOTE for checking misspelled word, we can use latex-lsp to highlight, and then jump with [d and ]d
					"[s",
					"]s",
					-- NOTE <Nop> default keybinding
					"q:",
					"q/",
					"q?",
					-- NOTE not really that useful, explore later
					"ge",
					"gu",
					"gU",
				}

				wk.setup({
					preset = "helix",
					---@param mapping wk.Mapping
					filter = function(mapping)
						return not vim.list_contains(ignored_bindings, mapping.lhs)
					end,
					plugins = {
						marks = true,
						registers = true,
						spelling = {
							enabled = false,
							suggestions = 20,
						},
						presets = {
							operators = true,
							motions = true,
							text_objects = true,
							windows = true,
							nav = true,
							z = true,
							g = true,
						},
					},
					keys = {
						scroll_down = "<c-n>",
						scroll_up = "<c-p>",
					},
				})
				wk.add({
					{ "<leader>c", group = "Comment management" },
					{ "<leader>z", group = "Fold management" },
					{ "<leader>s", group = "LSP and Treesitter" },
					{ "<leader>t", group = "Tabs management" },
					{ "<leader>w", group = "Windows management" },
					{ "<leader>b", group = "Buffers management" },
					{ "<leader>g", group = "Git management" },
					{ "<leader>k", group = "Quickfix management" },
					{ "<leader>p", group = "Picker" },
					{ "<leader>pg", group = "Search Git" },
					{ "<leader>ph", group = "Search utils history" },
					{ "<leader>e", group = "Encoding and decoding" },
					{ "<leader>ee", group = "Encode" },
					{ "<leader>ed", group = "Decode" },
					{ "x", group = "Exchange" },
					{ "gh", desc = "Enter Select mode" },
				})
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
		{
			"folke/snacks.nvim",
			version = "2.x",
			priority = 1000,
			lazy = false,
			dependencies = {},
			keys = {
				{
					-- mnemonic of note
					"<leader>n",
					function()
						Snacks.scratch()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Toggle Scratch Buffer",
				},
				{
					"<leader>p<leader>n",
					function()
						Snacks.scratch.select()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Select Scratch Buffer",
				},
				{
					"<leader>phj",
					function()
						Snacks.picker.jumps()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search jumplist history",
				},
				{
					"<leader>phu",
					function()
						Snacks.picker.undo()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search undo history",
				},
				{
					"<leader>phn",
					function()
						Snacks.picker.notifications({
							confirm = { "copy", "close" },
						})
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search notifications history",
				},
				{
					"<leader>phc",
					function()
						Snacks.picker.command_history()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search command history",
				},
				{
					"<leader>pb",
					function()
						Snacks.picker.buffers()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search buffers",
				},
				{
					"<leader>pc",
					function()
						Snacks.picker.colorschemes()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search colorschemes",
				},
				{
					"<leader>pd",
					function()
						Snacks.picker.diagnostics()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search diagnostics",
				},
				{
					"<leader>pl",
					function()
						Snacks.picker.lines()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search lines in buffer",
				},
				{
					"<leader>pgs",
					function()
						Snacks.picker.git_stash()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git Stash",
				},
				{
					"<leader>pgh",
					function()
						Snacks.picker.git_diff()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git Hunks",
				},
				{
					"<leader>pw",
					function()
						Snacks.picker.grep()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Grep in files",
				},

				{
					"<leader>pgb",
					function()
						Snacks.picker.git_branches()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git branches",
				},
				{
					"<leader>pgl",
					function()
						Snacks.picker.git_log()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git log",
				},
				{
					"<leader>go",
					function()
						Snacks.gitbrowse.open()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Browse files in remote Git server",
				},
				{
					"<leader>pr",
					function()
						Snacks.picker.resume()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Resume last picker",
				},
				{
					"<leader>pf",
					function()
						Snacks.picker.explorer({
							auto_close = false,
							jump = { close = false },
							win = {
								list = {
									keys = {
										["-"] = "explorer_up",
										["+"] = "explorer_focus",
										["<CR>"] = "confirm",
										["zc"] = "explorer_close",
										["zC"] = "explorer_close_all",
										-- NOTE Missing action that would open all directories, and we should assign zo and zO to it
										["d"] = "explorer_del",
										["c"] = "explorer_rename",
										["y"] = { "explorer_yank", mode = { "n", "x" } },
										["p"] = "explorer_paste",
										-- Use copy here, until there is a new action allows creating a new empty files or dir
										["o"] = "explorer_copy",
										["gx"] = "explorer_open",
										["<a-i>"] = "toggle_ignored",
										["<a-h>"] = "toggle_hidden",
										["]gh"] = "explorer_git_next",
										["[gh"] = "explorer_git_prev",
										["]d"] = "explorer_diagnostic_next",
										["[d"] = "explorer_diagnostic_prev",
										-- NOTE / is searching for files, not sure if we need grep at specific dir
										-- ["<leader>/"] = "picker_grep",
										["<leader>~"] = "tcd",
										-- TODO not sure how to deal with these actions yet
										-- ["m"] = "explorer_move",
									},
								},
							},
						})
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Explore files",
				},
			},
			config = function()
				local picker_keys = {
					["<2-LeftMouse>"] = "confirm",
					["<leader>k"] = { "qflist", mode = { "i", "n" } },
					["<CR>"] = { "confirm", mode = { "n", "i" } },
					["<Down>"] = { "list_down", mode = { "i", "n" } },
					["<Up>"] = { "list_up", mode = { "i", "n" } },
					["<Esc>"] = "close",
					["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
					["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
					["G"] = "list_bottom",
					["gg"] = "list_top",
					["j"] = "list_down",
					["k"] = "list_up",
					["q"] = "close",
					["?"] = function()
						require("which-key").show({ global = false, loop = true })
					end,
				}
				local config_dir = vim.fn.stdpath("config")
				---@cast config_dir string
				require("snacks").setup({
					toggle = { enabled = true },
					gitbrowse = { enabled = true },
					bigfile = { enabled = true },
					scratch = { enabled = true },
					image = { enabled = true },
					dashboard = {
						enabled = true,
						sections = {
							{
								section = "terminal",
								cmd = string.format(
									"chafa %s --format symbols --symbols block --size 60x17",
									vim.fs.joinpath(config_dir, "assets", "flag_of_british_hk.png")
								),
								height = 17,
								padding = 1,
							},
							{
								pane = 2,
								{
									icon = " ",
									title = "Recent Files",
									section = "recent_files",
									limit = 3,
									indent = 2,
									padding = { 2, 2 },
								},
								{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
								{ section = "startup" },
							},
						},
					},
					picker = {
						enabled = true,
						ui_select = true,
						layout = {
							cycle = true,
							preset = function()
								return vim.o.columns >= 120 and "default" or "vertical"
							end,
						},
						win = {
							input = {
								keys = picker_keys,
							},
							list = {
								keys = picker_keys,
							},
						},
					},
					scroll = {
						enabled = true,
						animate = {
							duration = { step = 10, total = 100 },
							easing = "linear",
						},
					},
					input = {
						enabled = true,
					},
					notifier = {
						enabled = true,
						style = "fancy",
						level = vim.log.levels.INFO,
					},
					indent = {
						enabled = true,
					},
					words = { enabled = false },
					styles = {
						notification = {
							wo = {
								wrap = true,
							},
						},
					},
				})
			end,
		},
		{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = { "VeryLazy" } },
		{
			"folke/ts-comments.nvim",
			opts = {},
			event = "VeryLazy",
			enabled = vim.fn.has("nvim-0.10.0") == 1,
			config = function() end,
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

						local available_textobjects =
							require("nvim-treesitter.textobjects.shared").available_textobjects()
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

		-- TODO see if we can turn these into treesitter's dependencies, and config with its setup function
		{
			"nvim-treesitter/nvim-treesitter-context",
			-- replaced this plugin with dropbar.nvim, as it occupies less estate on screen
			enabled = false,
			opts = {
				max_lines = 5,
			},
			event = { "VeryLazy" },
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			event = { "VeryLazy" },
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
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
			"aaronik/treewalker.nvim",
			event = "CursorHold",
			-- NOTE not really that accurate
			enabled = false,
			opts = {
				highlight = false,
			},
			keys = {
				{
					"<leader>sh",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Left")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move left to a Treesitter node",
				},
				{
					"<leader>sl",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Right")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move right to a Treesitter node",
				},
				{
					"<leader>sk",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Up")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move upward to a Treesitter node",
				},
				{
					"<leader>sj",
					function()
						local count = vim.v.count1
						for _ = 1, count do
							vim.cmd("Treewalker Down")
						end
					end,
					mode = { "n", "v" },
					noremap = true,
					silent = true,
					desc = "Move downward to a Treesitter node",
				},
			},
		},
		{
			"rlane/pounce.nvim",
			--NOTE relying the default f and treesitter textbobject seems to be enough
			enabled = false,
			commit = "2e36399ac09b517770c459f1a123e6b4b4c1c171",
			keys = {
				{
					"f",
					function()
						require("pounce").pounce()
					end,
					mode = { "n", "v", "o" },
					noremap = true,
					silent = true,
					desc = "Find 1 character forward",
				},
				{
					"F",
					function()
						require("pounce").pounce()
					end,
					mode = { "n", "v", "o" },
					noremap = true,
					silent = true,
					desc = "Find 1 character backward",
				},
			},
			config = function()
				-- wait for tokyonight to support these highlight group
				-- using https://github.com/folke/tokyonight.nvim/blob/355e2842291dbf51b2c5878e9e37281bbef09783/lua/tokyonight/groups/hop.lua#L5
				local c = require("tokyonight.colors").setup()
				vim.api.nvim_set_hl(0, "PounceMatch", {
					link = "Search",
				})
				vim.api.nvim_set_hl(0, "PounceAcceptBest", {
					fg = c.magenta2,
					bg = "none",
					bold = true,
				})
				vim.api.nvim_set_hl(0, "PounceAccept", {
					fg = c.blue2,
					bg = "none",
					bold = true,
				})
				vim.api.nvim_set_hl(0, "PounceUnmatched", {
					fg = c.dark3,
				})
				vim.api.nvim_set_hl(0, "PounceGap", {
					fg = c.dark3,
				})
			end,
		},
		{
			"stevearc/oil.nvim",
			version = "2.x",
			lazy = false,
			cmd = { "Oil" },
			keys = {
				{
					"<leader>o",
					function()
						utils.smart_open(function()
							vim.cmd("Oil")
						end, {
							filetype = "oil",
						})
					end,
					mode = { "n" },
					noremap = true,
					silent = true,
					desc = "Open Oil.nvim panel",
				},
			},
			config = function()
				local show_detail = false
				local default_columns = {
					"icon",
					"permissions",
				}
				local detail_columns = vim.list_extend(vim.list_slice(default_columns), { "size", "mtime" })
				require("oil").setup({
					columns = default_columns,
					constrain_cursor = "editable",
					watch_for_changes = true,
					keymaps = {
						["<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false },
							desc = "Select a file",
						},
						["<leader>t<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false, tab = true },
							desc = "Select a file and open in a new tab",
						},
						["<leader>wv<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false, vertical = true },
							desc = "Select a file and open in a vertical split",
						},
						["<leader>ws<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false, horizontal = true },
							desc = "Select a file and open in a horizontal split",
						},
						["~"] = { "actions.cd", mode = "n", desc = "Change current directory of NeoVim" },
						["<a-m>"] = {
							callback = function()
								show_detail = not show_detail
								if show_detail then
									require("oil").set_columns(detail_columns)
								else
									require("oil").set_columns(default_columns)
								end
							end,
							mode = "n",
							desc = "Toggle file detail",
						},
						["<a-h>"] = {
							"actions.toggle_hidden",
							mode = "n",
							desc = "Toggle hidden files",
						},
						["<a-s>"] = { "actions.change_sort", mode = "n" },
						["-"] = { "actions.parent", mode = "n", desc = "Go to parent directory" },
						["gx"] = { "actions.open_external", mode = "n", desc = "Open in external application" },
					},
					use_default_keymaps = false,
					win_options = {
						wrap = true,
					},
					view_options = {
						show_hidden = true,
					},
					skip_confirm_for_simple_edits = true,
				})
				-- REF https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
				vim.api.nvim_create_autocmd("User", {
					pattern = "OilActionsPost",
					callback = function(event)
						if event.data.actions.type == "move" then
							Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
						end
					end,
				})
			end,
			dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
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
			"stevearc/conform.nvim",
			version = "9.x",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			config = function()
				-- TODO add a key binding for formatting operator
				-- TODO jump to specific kind of comments, for example TODO
				local prettier = { "biome", "prettierd", "prettier", stop_after_first = true }
				require("conform").setup({
					formatters_by_ft = {
						ember = {},
						apex = {},
						astro = {},
						bibtex = {},
						cuda = {},
						foam = {},
						fish = {},
						glsl = {},
						hack = {},
						inko = {},
						julia = {},
						odin = {},
						tact = {},
						nasm = {},
						slang = {},
						perl = {},
						wgsl = {},
						html = prettier,
						xml = prettier,
						svg = prettier,
						css = prettier,
						scss = prettier,
						sass = prettier,
						less = prettier,
						javascript = prettier,
						javascriptreact = prettier,
						["javascript.jsx"] = prettier,
						typescript = prettier,
						typescriptreact = prettier,
						["typescript.jsx"] = prettier,
						sh = { "shfmt" },
						zsh = { "shfmt" },
						bash = { "shfmt" },
						markdown = prettier,
						json = prettier,
						jsonl = prettier,
						jsonc = prettier,
						json5 = prettier,
						yaml = prettier,
						vue = prettier,
						http = { "kulala-fmt" },
						rest = { "kulala-fmt" },
						toml = { "taplo" },
						lua = { "stylua" },
						teal = { "stylua" },
						python = function(bufnr)
							if require("conform").get_formatter_info("ruff_format", bufnr).available then
								return { "ruff_format" }
							else
								return { "isort", "black" }
							end
						end,
						rust = { "rustfmt", lsp_format = "fallback" },
						go = { "goimports", "gofmt" },
						nix = { "nixfmt" },
						nginx = { "nginxfmt" },
						ruby = { "rufo" },
						dart = { "dart_format" },
						haskell = { "hindent" },
						kotlin = { "ktlint" },
						cpp = { "clang_format" },
						c = { "clang_format" },
						cs = { "clang_format" },
						swift = { "swift_format" },
						r = { "styler" },
						elm = { "elm_format" },
						elixir = { "mix" },
						sql = { "pg_format" },
						tf = { "hcl" },
						ini = { "inifmt" },
						dosini = { "inifmt" },
						dhall = { "dhall_format" },
						fennel = { "fnlfmt" },
						svelte = prettier,
						pug = prettier,
						nunjucks = { "njkfmt" },
						liquid = { "liquidfmt" },
						nim = { "nimpretty" },
						mint = { "mintfmt" },
						kdl = { "kdlfmt" },
						just = { "just" },
						erb = { "erb_format" },
						ql = { "codeql" },
						d2 = { "d2" },
						erlang = { "efmt" },
						awk = { "gawk" },
						gleam = { "gleam" },
						rego = { "opa_fmt" },
						zig = { "zigfmt" },
					},
					default_format_opts = {
						lsp_format = "fallback",
					},
					format_on_save = function(bufnr)
						if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
							return
						end
						return { timeout_ms = 500, lsp_format = "fallback" }
					end,
					formatters = {},
				})
				vim.api.nvim_create_user_command("FormatDisable", function(args)
					if args.bang then
						-- FormatDisable! will disable formatting just for this buffer
						vim.b.disable_autoformat = true
					else
						vim.g.disable_autoformat = true
					end
				end, {
					desc = "Disable autoformat-on-save",
					bang = true,
				})
				vim.api.nvim_create_user_command("FormatEnable", function()
					vim.b.disable_autoformat = false
					vim.g.disable_autoformat = false
				end, {
					desc = "Re-enable autoformat-on-save",
				})
			end,
			init = function()
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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
			"neovim/nvim-lspconfig",
			enabled = true,
			version = "2.x",
			-- Reference the lazyload event from LazyVim
			-- REF https://github.com/LazyVim/LazyVim/blob/86ac9989ea15b7a69bb2bdf719a9a809db5ce526/lua/lazyvim/plugins/lsp/init.lua#L5
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local lspconfig = require("lspconfig")
				local util = require("lspconfig.util")

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
				capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

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
					"graphql",
					"elmls",
					"ocamlls",
					"puppet",
					"serve_d",
					"gdscript",
					"scry",
					"biome",
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
					"vimls",
					"nixd",
					"r_language_server",
					"kotlin_language_server",
					"cmake",
					"pyright",
					"taplo",
					"cucumber_language_server",
					"slint_lsp",
					"regal",
					"ballerina",
					"bitbake_ls",
					"ltex",
					"csharp_ls",
					"vue_ls",
					"tsp_server",
				}

				for _, server in ipairs(servers) do
					lspconfig[server].setup({
						on_init = function(client)
							-- NOTE use only Treesitter for syntax highlight
							client.server_capabilities.semanticTokensProvider = nil
						end,
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
					capabilities = capabilities,
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

				local ok, vue_language_server_path = pcall(function()
					local res = vim.system({ "which", "vue-language-server" }, { text = true }):wait()
					if res.code ~= 0 then
						return error(res.stdout)
					end
					res.stdout = res.stdout:gsub("\n", "")
					res = vim.system({ "nix", "path-info", res.stdout }, { text = true }):wait()

					if res.code ~= 0 then
						return error(res.stdout)
					end
					return res.stdout:gsub("\n", "")
				end)

				local ts_ls_plugins = {}

				if ok then
					table.insert(ts_ls_plugins, {
						name = "@vue/typescript-plugin",
						location = vim.fs.joinpath(
							vue_language_server_path,
							"node_modules",
							"@vue",
							"typescript-plugin"
						),
						languages = { "javascript", "typescript", "vue" },
					})
				else
					vim.notify(
						string.format("Failed to set up @vue/typescript-plugin: %s", vue_language_server_path),
						vim.log.levels.WARN
					)
				end

				lspconfig.ts_ls.setup({
					init_options = {
						plugins = ts_ls_plugins,
					},
					filetypes = {
						"javascript",
						"typescript",
						"vue",
					},
				})
				lspconfig.denols.setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("deno.json", "deno.jsonc"),
				})
				lspconfig.lua_ls.setup({
					diagnostics = {
						underline = true,
						update_in_insert = true,
						severity_sort = true,
					},
					capabilities = capabilities,
					on_init = function(client)
						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (
									vim.loop.fs_stat(path .. "/.luarc.json")
									or vim.loop.fs_stat(path .. "/.luarc.jsonc")
								)
							then
								return
							end
						end
					end,
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {},
							},
							diagnostics = {
								globals = {},
							},
							telemetry = {
								enable = false,
							},
							hint = { enable = true },
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
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local supported_modes = { "n" }
		-- vim.keymap.set(supported_modes, "]de", function()
		-- 	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
		-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to next error" })
		-- vim.keymap.set(supported_modes, "[de", function()
		-- 	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
		-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to previous error" })
		--
		-- vim.keymap.set(supported_modes, "]dw", function()
		-- 	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
		-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to next warning" })
		-- vim.keymap.set(supported_modes, "[dw", function()
		-- 	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
		-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to previous warning" })
		vim.keymap.set(supported_modes, "<leader>ss", function()
			-- if we call twice, we will enter the hover windows immediately after running the keybinding
			vim.lsp.buf.hover()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show hover tips" })
		vim.keymap.set(supported_modes, "<leader>sd", function()
			vim.diagnostic.open_float()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show diagnostics message" })
		-- TODO combine all these functions, using Snacks.picker
		vim.keymap.set(supported_modes, "<leader>s1", function()
			Snacks.picker.lsp_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to definition" })
		vim.keymap.set(supported_modes, "<leader>s2", function()
			Snacks.picker.lsp_type_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to type definition" })
		vim.keymap.set(supported_modes, "<leader>s3", function()
			Snacks.picker.lsp_implementations()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to implementation" })
		vim.keymap.set(supported_modes, "<leader>s4", function()
			Snacks.picker.lsp_references()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to references", nowait = true })
		vim.keymap.set(
			{ "n", "x" },
			"<leader>s5",
			vim.lsp.buf.rename,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Rename variable" }
		)
		vim.keymap.set(
			{ "n", "x" },
			"<leader>s6",
			vim.lsp.buf.code_action,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Apply code action" }
		)
		pcall(function()
			-- Remove default keybinding added by lspconfig
			-- REF https://neovim.io/doc/user/lsp.html#lsp-config
			vim.keymap.del({ "n" }, "K", { buffer = ev.buf })
		end)

		vim.diagnostic.config({
			underline = true,
			virtual_text = false,
			virtual_lines = { current_line = true },
			signs = {
				text = {
					-- FIXME: cannot customize the icon, without not showing it in signcolumn
					-- [vim.diagnostic.severity.ERROR] = ERROR_ICON,
					-- [vim.diagnostic.severity.WARN] = WARNING_ICON,
					-- [vim.diagnostic.severity.INFO] = INFO_ICON,
					-- [vim.diagnostic.severity.HINT] = HINT_ICON,
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
			update_in_insert = true,
		})
	end,
})

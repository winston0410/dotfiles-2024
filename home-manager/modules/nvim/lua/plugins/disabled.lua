return {
	{
		"artemave/workspace-diagnostics.nvim",
		-- TODO enable this later, as there is no way to disable the warning message, and it can only help with existing LSP client. It doesn't trigger LSP to start automatically.
		enabled = false,
		event = { "LspAttach" },
		config = function()
			require("workspace-diagnostics").setup({})
		end,
	},
    -- NOTE enable this plugin after 0.12 using vim.pack, and disable it by default. Trigger it with usercmd when needed, so to reduce the noise in code
	{
		"oribarilan/lensline.nvim",
		enabled = false,
		version = "2.x",
		event = { "LspAttach" },
		config = function()
			require("lensline").setup()
		end,
	},
	{
		"nvimtools/none-ls.nvim",
        enabled = false,
		dependencies = { "nvim-lua/plenary.nvim", "ckolkey/ts-node-action", "ThePrimeagen/refactoring.nvim" },
		event = lspconfig_load_event,
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.gdlint,
					null_ls.builtins.diagnostics.checkmake,
					null_ls.builtins.diagnostics.haml_lint,
					null_ls.builtins.diagnostics.terraform_validate,
					null_ls.builtins.diagnostics.tidy,
					null_ls.builtins.diagnostics.opacheck,
					null_ls.builtins.code_actions.refactoring,
					null_ls.builtins.code_actions.ts_node_action,
				},
			})
		end,
	},
	{
		"kosayoda/nvim-lightbulb",
		enabled = false,
		version = "1.x",
		event = { "LspAttach" },
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
				ignore = {
					clients = { "null-ls" },
					ft = {},
					actions_without_kind = false,
				},
			})
		end,
	},    
	{
		"tzachar/highlight-undo.nvim",
		-- Using u and <C-r> seems to be enough for me
		enabled = false,
		event = "VeryLazy",
		opts = {
			hlgroup = "Visual",
			duration = 500,
			pattern = { "*" },
			ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "snacks_dashboard" },
		},
	},
	{
		"mrjones2014/smart-splits.nvim",
		version = "1.x",
		enabled = false,
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
		"chrisgrieser/nvim-recorder",
		enabled = false,
		opts = {},
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
		"mcauley-penney/visual-whitespace.nvim",
		-- this plugin is too intrusive
		enabled = false,
		opts = {},
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
}

-- {
-- 	-- FIXME it does not download the kubectl_client???
-- 	"ramilito/kubectl.nvim",
-- 	version = "2.x",
-- 	cmd = { "Kubectl", "Kubectx", "Kubens" },
-- 	dependencies = { "saghen/blink.download" },
-- 	keys = {
-- 		{
-- 			"<leader>K",
-- 			function()
-- 				require("kubectl").toggle({ tab = true })
-- 			end,
-- 			mode = { "n" },
-- 			silent = true,
-- 			noremap = true,
-- 			desc = "kubectl.nvim panel",
-- 		},
-- 	},
-- 	config = function()
-- 		require("kubectl").setup({
-- 			log_level = vim.log.levels.INFO,
-- 			diff = {
-- 				bin = "kubediff",
-- 			},
-- 		})
-- 		-- local group = vim.api.nvim_create_augroup("kubectl_mappings", { clear = true })
-- 		-- vim.api.nvim_create_autocmd("FileType", {
-- 		-- 	group = group,
-- 		-- 	pattern = "k8s_*",
-- 		-- 	callback = function()
-- 		-- 		local tab_id = vim.api.nvim_get_current_tabpage()
-- 		-- 		vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "Kubectl")
-- 		-- 	end,
-- 		-- })
-- 	end,
-- },
--
-- vim.pack.add({
-- 	{ src = "https://github.com/nvim-lua/plenary.nvim" },
-- 	{ src = "https://github.com/NeogitOrg/neogit", version = "master" },
-- }, { confirm = false })
-- require("neogit").setup({
-- 	-- FIXME range diffing is not working correctly, cannot select the target of "to"
-- 	disable_hint = true,
-- 	disable_commit_confirmation = true,
-- 	graph_style = "unicode",
-- 	kind = "tab",
-- 	integrations = {
-- 		diffview = true,
-- 		snacks = true,
-- 	},
-- 	-- NOTE setting it to false is buggy right now
-- 	-- use_default_keymaps = true,
-- 	mappings = {
-- 		commit_editor_I = {
-- 			["<c-c><c-c>"] = "Submit",
-- 			["<c-c><c-k>"] = "Abort",
-- 		},
-- 		rebase_editor_I = {
-- 			["<c-c><c-c>"] = "Submit",
-- 			["<c-c><c-k>"] = "Abort",
-- 		},
-- 		popup = {
-- 			["?"] = "HelpPopup",
-- 			["c"] = "CommitPopup",
-- 			["b"] = "BranchPopup",
-- 			["B"] = "BisectPopup",
-- 			["A"] = false,
-- 			["d"] = false,
-- 			["M"] = false,
-- 			["P"] = false,
-- 			["X"] = false,
-- 			["Z"] = false,
-- 			["i"] = false,
-- 			["t"] = false,
-- 			["w"] = false,
-- 			["f"] = false,
-- 			["l"] = false,
-- 			["m"] = false,
-- 			["p"] = false,
-- 			["r"] = false,
-- 			["v"] = false,
-- 			["L"] = false,
-- 		},
-- 		status = {
--             ["$"] = false,
--             ["I"] = false,
-- 			["Q"] = false,
--         },
-- 		finder = {},
-- 		commit_editor = {},
-- 		rebase_editor = {},
-- 	},
-- })
-- vim.keymap.set({ "n" }, "<leader>gg", function()
-- 	require("neogit").open()
-- end, { silent = true, noremap = true, desc = "Open Neogit status" })
--
-- -- FIXME https://github.com/mistricky/codesnap.nvim/issues/162
-- vim.pack.add({
-- 	{ src = "https://github.com/mistweaverco/snap.nvim.git", version = vim.version.range("1.x") },
-- }, { confirm = false })
--
-- require("snap").setup({ })
-- -- improve structure here
-- vim.api.nvim_create_autocmd("CursorHold", {
--     once = true,
--     callback = function()
--         -- really optional plugins
--         vim.pack.add({
--             { src = "https://github.com/vyfor/cord.nvim",                    version = vim.version.range("2.x") },
--             { src = "https://github.com/michaelb/sniprun",                   version = "v1.3.20" },
--             { src = "https://github.com/nvim-lua/plenary.nvim" },
--             { src = "https://github.com/mistweaverco/kulala.nvim",           version = vim.version.range("5.x") },
--             { src = "https://github.com/martineausimon/nvim-lilypond-suite", },
--             { src = "https://github.com/Ramilito/kubectl.nvim",              version = vim.version.range("2.x") },
--         }, { confirm = false })
--
--         require("cord").setup({
--             timestamp = {
--                 enabled = true,
--                 reset_on_idle = false,
--                 reset_on_change = false,
--             },
--             editor = {
--                 client = "neovim",
--                 tooltip = "Hugo's ultimate editor",
--             },
--         })
--         require("sniprun").setup({
--             binary_path = "sniprun",
--             selected_interpreters = { "Python3_fifo" },
--             repl_enable = { "Python3_fifo" },
--             interpreter_options = {
--                 CSharp_original = {
--                     compiler = "csc",
--                 },
--                 TypeScript_original = {
--                     interpreter = "node",
--                 },
--             },
--             snipruncolors = {
--                 SniprunVirtualTextOk = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextInfo" }),
--                 SniprunVirtualWinOk = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextInfo" }),
--                 SniprunVirtualTextErr = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }),
--                 SniprunVirtualWinErr = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }),
--             },
--         })
--
--         require("kulala").setup({
--             global_keymaps = false,
--             display_mode = "split",
--             split_direction = "vertical",
--             debug = false,
--             default_view = "headers_body",
--             winbar = true,
--             default_winbar_panes = { "headers_body", "verbose", "script_output", "report" },
--             vscode_rest_client_environmentvars = true,
--             disable_script_print_output = false,
--             environment_scope = "b",
--             urlencode = "always",
--             -- show_variable_info_text = "float",
--             show_variable_info_text = false,
--             ui = {
--                 -- 10Mb
--                 max_response_size = 1024 * 1024 * 10,
--                 disable_news_popup = true,
--             },
--         })
--         vim.keymap.set({ "n" }, "<leader>ri", function()
--             -- inspect a request for result interpolation
--             require("kulala").inspect()
--         end, { remap = true, silent = true, desc = "Inspect request" })
--         vim.keymap.set({ "x" }, "<leader>r<CR>", function()
--             require("kulala").run()
--         end, { remap = true, silent = true, desc = "Execute selected requests" })
--         vim.keymap.set({ "n" }, "<leader>r<CR>", function()
--             require("kulala").run()
--         end, { remap = true, silent = true, desc = "Execute a request" })
--
--         vim.keymap.set({ "n" }, "<leader>ry", function()
--             require("kulala").copy()
--         end, { remap = true, silent = true, desc = "Copy a request as Curl" })
--         vim.keymap.set({ "n" }, "<leader>rp", function()
--             require("kulala").from_curl()
--         end, { remap = true, silent = true, desc = "Paste a request from Curl" })
--         vim.keymap.set({ "n" }, "<leader>r/", function()
--             require("kulala").search()
--         end, { remap = true, silent = true, desc = "Find a request" })
--         vim.keymap.set({ "n" }, "]<leader>r", function()
--             require("kulala").jump_next()
--         end, { remap = true, silent = true, desc = "Jump to next request" })
--         vim.keymap.set({ "n" }, "[<leader>r", function()
--             require("kulala").jump_prev()
--         end, { remap = true, silent = true, desc = "Jump to previous request" })
--         vim.keymap.set({ "n" }, "<leader>rg", function()
--             require("kulala").download_graphql_schema()
--         end, { remap = true, silent = true, desc = "Download GraphQL schema" })
--
--         require("nvls").setup({})
--         require("kubectl").setup({
--             log_level = vim.log.levels.INFO,
--             diff = {
--                 bin = "kubediff",
--             },
--         })
--     end,
-- })

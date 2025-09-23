return {
	{
		"martineausimon/nvim-lilypond-suite",
		cmd = { "LilyPlayer", "LilyCmp", "LilyDebug" },
		config = function()
			require("nvls").setup({})
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
		-- FIXME it does not download the kubectl_client???
		"ramilito/kubectl.nvim",
		version = "v2.7.12",
		cmd = { "Kubectl", "Kubectx", "Kubens" },
		dependencies = { "saghen/blink.download" },
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
		config = function()
			require("kubectl").setup({
				log_level = vim.log.levels.INFO,
				diff = {
					bin = "kubediff",
				},
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
		event = { "VeryLazy" },
		config = function()
			require("kulala").setup({
				global_keymaps = false,
				display_mode = "split",
				split_direction = "vertical",
				debug = false,
				winbar = true,
				vscode_rest_client_environmentvars = true,
				disable_script_print_output = false,
				environment_scope = "b",
				urlencode = "always",
				-- show_variable_info_text = "float",
				show_variable_info_text = false
			})
			local hydra = require("hydra")
			hydra({
				name = "Kulala",
				mode = { "n", "x" },
				body = "<leader>r",
				config = {
					hint = false,
				},
				heads = {
					{
						"<CR>",
						function()
							require("kulala").run()
						end,
						{
							mode = { "n", "v" },
							noremap = true,
							silent = true,
							desc = "Execute a request",
						},
					},
					{
						"<M-h>",
						function()
							require("kulala").toggle_view()
						end,
						{
							mode = { "n", "v" },
							noremap = true,
							silent = true,
							desc = "Toggle headers and body",
						},
					},
				},
			})
		end,
	},
}

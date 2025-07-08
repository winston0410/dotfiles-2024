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
		"ramilito/kubectl.nvim",
		version = "2.x",
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
				headers = {
					enabled = false,
				},
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
}

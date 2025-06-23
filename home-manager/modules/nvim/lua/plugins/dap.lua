return {
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
}

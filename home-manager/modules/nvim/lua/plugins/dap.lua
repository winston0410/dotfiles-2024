vim.api.nvim_create_autocmd("CursorHold", {
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/mfussenegger/nvim-dap", version = "master"},
			{ src = "https://github.com/mfussenegger/nvim-dap-python" },
			{ src = "https://github.com/suketa/nvim-dap-ruby" },
			{ src = "https://github.com/leoluz/nvim-dap-go" },
			{ src = "https://github.com/igorlfs/nvim-dap-view" },
		})

		require("dap-python").setup("uv")
		require("dap-ruby").setup()
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

		local dap = require("dap")
		-- REF https://www.compart.com/en/unicode/search?q=circle#characters
		-- NOTE we are defining the highlight group here, because we are not using nvim-dap-ui
		vim.api.nvim_set_hl(0, "DapUIStop", { link = "PreProc" })
		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "●", texthl = "DapUIStop", linehl = "", numhl = "", priority = 90 }
		)
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "⊜", texthl = "DapUIStop", linehl = "", numhl = "", priority = 91 }
		)
		vim.api.nvim_set_hl(0, "DapUIPlayPause", { link = "Repeat" })
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
		dap.adapters.godot = {
			type = "server",
			host = "127.0.0.1",
			port = 6006,
		}
		dap.configurations.gdscript = {
			{
				type = "godot",
				request = "launch",
				name = "Launch scene",
				project = "${workspaceFolder}",
			},
		}
		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { "/path/to/vscode-php-debug/out/phpDebug.js" },
		}
		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for Xdebug",
				port = 9003,
			},
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

        vim.keymap.set("n", "<leader>db", function()
            require("dap").toggle_breakpoint()
        end, {
            silent = true,
            noremap = true,
            desc = "Toggle breakpoint",
        })

        vim.keymap.set("n", "<leader>dc", function()
            require("dap").continue()
        end, {
            desc = "Continue",
        })

        vim.keymap.set("n", "<leader>dC", function()
        	require("dap").run_to_cursor()
        end, {
        	desc = "Run to Cursor",
        })

        vim.keymap.set("n", "<leader>dt", function()
            require("dap").terminate()
        end, {
            desc = "Terminate debug session",
        })
	end,
})

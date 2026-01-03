vim.api.nvim_create_autocmd("CursorHold", {
	once = true,
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/nvim-neotest/neotest" },

			{ src = "https://github.com/nvim-neotest/nvim-nio" },
			{ src = "https://github.com/nvim-lua/plenary.nvim" },

			{ src = "https://github.com/Issafalcon/neotest-dotnet" },
			{ src = "https://github.com/thenbe/neotest-playwright" },
			{ src = "https://github.com/fredrikaverpil/neotest-golang", version = vim.version.range("2.x") },
			{ src = "https://github.com/nvim-neotest/neotest-python" },
			{ src = "https://github.com/nvim-neotest/neotest-go" },
			{ src = "https://github.com/nvim-neotest/neotest-jest" },
			{ src = "https://github.com/nvim-neotest/neotest-plenary" },
			{ src = "https://github.com/nsidorenco/neotest-vstest" },
			{ src = "https://github.com/jfpedroza/neotest-elixir" },
			{ src = "https://github.com/olimorris/neotest-rspec" },
			{ src = "https://github.com/rcasia/neotest-bash" },
			{ src = "https://github.com/olimorris/neotest-phpunit" },
		}, { confirm = false })

		require("neotest").setup({
			log_level = vim.log.levels.WARN,
			consumers = {},
			highlights = {},
			floating = {},
			default_strategy = "integrated",
			adapters = {
				require("neotest-dotnet"),
				require("neotest-phpunit"),
				require("neotest-plenary"),
				require("neotest-bash"),
				require("neotest-rspec"),
				require("neotest-jest")({
					jestCommand = "npm test --",
					jestConfigFile = "custom.jest.config.ts",
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
				require("neotest-elixir"),
				require("neotest-vstest"),
				require("neotest-python"),
				require("neotest-go"),
				require("neotest-playwright").adapter({
					options = {
						persist_project_selection = true,
						enable_dynamic_test_discovery = true,
					},
				}),
			},
		})
	end,
})

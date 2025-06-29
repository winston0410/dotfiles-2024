return {
	{
		"nvim-neotest/neotest",
		cmd = { "Neotest" },
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- neotest integration
			"thenbe/neotest-playwright",
			{ "fredrikaverpil/neotest-golang", version = "*" },
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-go",
			"nvim-neotest/neotest-jest",
			"nvim-neotest/neotest-plenary",
			"nsidorenco/neotest-vstest",
			"jfpedroza/neotest-elixir",
			"olimorris/neotest-rspec",
			"rcasia/neotest-bash",
			"olimorris/neotest-phpunit",
		},
		config = function()
			require("neotest").setup({
				log_level = vim.log.levels.WARN,
				consumers = {},
				highlights = {},
				floating = {},
				default_strategy = "integrated",
				adapters = {
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
	},
}

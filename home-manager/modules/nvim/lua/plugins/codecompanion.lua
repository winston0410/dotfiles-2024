return {
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
}

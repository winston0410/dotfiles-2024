local render_markdown_ft = { "markdown", "codecompanion" }

local get_api_key = function(key)
	if vim.env.BW_SESSION == nil then
		local uname = vim.loop.os_uname()
		local master_pwd

		if uname.sysname == "Linux" then
			local res = vim.system({
				"secret-tool",
				"lookup",
				"service",
				"vaultwarden.28281428.xyz",
			}, { text = true }):wait()

			if res.code ~= 0 then
				vim.notify(
					string.format("Failed to get master password for Bitwarden: %s", res.stderr),
					vim.log.levels.ERROR
				)
				return
			end
			master_pwd = vim.trim(res.stdout)
		elseif uname.sysname == "Darwin" then
			local res = vim.system({
				"security",
				"find-internet-password",
				"-s",
				"vaultwarden.28281428.xyz",
				"-w",
			}, { text = true }):wait()

			if res.code ~= 0 then
				vim.notify(
					string.format("Failed to get master password for Bitwarden: %s", res.stderr),
					vim.log.levels.ERROR
				)
				return
			end
			master_pwd = vim.trim(res.stdout)
		else
			vim.notify(
				"Unknown OS detected when getting API key for CodeCompanion: " .. uname.sysname,
				vim.log.levels.ERROR
			)
			return
		end

		local unlock_res = vim.system({
			"bw",
			"unlock",
			master_pwd,
			"--raw",
		}, { text = true }):wait()

		local session_key = vim.trim(unlock_res.stdout)
		vim.env.BW_SESSION = session_key
	end

	local pwd_res = vim.system({
		"bw",
		"get",
		"password",
		key,
	}, {
		text = true,
	}):wait()

	return pwd_res.stdout
end
return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim",
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
				ft = render_markdown_ft,
				opts = {
					completions = { blink = { enabled = true } },
					file_types = render_markdown_ft,
				},
			},
			{
				"HakonHarnes/img-clip.nvim",
				version = "0.x",
				cmd = { "PasteImage" },
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
		version = "17.x",
		config = function()
			require("codecompanion").setup({
				auto_approve = true,
				-- https://codecompanion.olimorris.dev/configuration/adapters.html#changing-a-model
				adapters = {
					gemini = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = {
								api_key = get_api_key("GEMINI_API_KEY"),
							},
							schema = {
								model = {
									default = "gemini-2.5-flash",
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
					history = {
						enabled = true,
						opts = {
							picker = "snacks",
						},
					},
				},
				strategies = {
					chat = {
						adapter = "gemini",
						opts = {
							completion_provider = "blink",
						},
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

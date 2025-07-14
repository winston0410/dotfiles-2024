local render_markdown_ft = { "markdown", "codecompanion" }

local get_api_key = function(key)
	if vim.env[key] ~= nil then
		return vim.env[key]
	end

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

	local pwd = pwd_res.stdout
	vim.env[key] = pwd

	return pwd
end
return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- {
			-- 	"Davidyz/VectorCode",
			-- 	version = "*",
			-- 	dependencies = { "nvim-lua/plenary.nvim" },
			-- 	cmd = "VectorCode",
			-- },
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
						auto_approve = false,
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
		keys = {
			{
				"<leader>p<leader>a",
				function()
					vim.cmd("CodeCompanionActions")
				end,
				mode = "n",
				silent = true,
				desc = "Pick CodeCompanion actions",
			},
		},
		cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
		version = "17.x",
		config = function()
			require("codecompanion").setup({
				auto_approve = true,
				adapters = {
					copilot = function()
						return require("codecompanion.adapters").extend("copilot", {
							env = {
								api_key = get_api_key("COPILOT_API_KEY"),
							},
						})
					end,
					tavily = function()
						return require("codecompanion.adapters").extend("gemini", {
							env = {
								api_key = get_api_key("TAVILY_API_KEY"),
							},
							schema = {
								model = {
									default = "gemini-2.5-flash",
								},
							},
						})
					end,
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
							expiration_days = 30,
						},
					},
					-- vectorcode = {},
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
				prompt_library = {
					["Commit Message"] = {
						strategy = "inline",
						description = "Generate a commit message",
						opts = {
							short_name = "commit_message",
							auto_submit = true,
							placement = "before",
						},
						prompts = {
							{
								role = "user",
								content = function()
									return string.format(
										[[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:

` ` `diff
%s
` ` `

When unsure about the module names to use in the commit message, you can refer to the last 20 commit messages in this repository:

` ` `
%s
` ` `

Output only the commit message without any explanations and follow-up suggestions.
]],
										vim.fn.system("git diff --no-ext-diff --staged"),
										vim.fn.system('git log --pretty=format:"%s" -n 20')
									)
								end,
								opts = {
									contains_code = true,
								},
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
				opts = {
					log_level = "INFO",
					send_code = true,
				},
			})
		end,
	},
}

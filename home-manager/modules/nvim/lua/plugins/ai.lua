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

	-- NOTE we have to manually sync, otherwise it will always use the old data and we might not be able to find our password
	vim.system({
		"bw",
		"sync",
	}, {
		text = true,
	}):wait()

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

vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		vim.pack.add({
			{ src = "https://github.com/github/copilot.vim", version = vim.version.range("1.x") },
		})
		-- REF https://github.com/fang2hou/blink-copilot
		vim.g.copilot_no_maps = true

		-- Block the normal Copilot suggestions
		vim.api.nvim_create_augroup("github_copilot", { clear = true })
		vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
			group = "github_copilot",
			callback = function(args)
				vim.fn["copilot#On" .. args.event]()
			end,
		})
		vim.fn["copilot#OnFileType"]()
	end,
})

vim.pack.add({
	{ src = "https://github.com/hakonharnes/img-clip.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/ravitemer/codecompanion-history.nvim", version = "main" },
	{ src = "https://github.com/olimorris/codecompanion.nvim", version = vim.version.range("18.x") },
	{ src = "https://github.com/franco-ruggeri/codecompanion-spinner.nvim", version = "main" },
	-- { src = "https://github.com/ravitemer/mcphub.nvim", version = vim.version.range("6.x") },
})

require("codecompanion").setup({
	auto_approve = true,
	adapters = {
		http = {
			jina = function()
				return require("codecompanion.adapters").extend("jina", {
					env = {
						api_key = get_api_key("JINA_API_KEY"),
					},
				})
			end,
			tavily = function()
				return require("codecompanion.adapters").extend("tavily", {
					env = {
						api_key = get_api_key("TAVILY_API_KEY"),
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
	},
	extensions = {
		spinner = {},
		-- mcphub = {
		-- 	callback = "mcphub.extensions.codecompanion",
		-- 	opts = {
		-- 		show_result_in_chat = true,
		-- 		make_vars = true,
		-- 		make_slash_commands = true,
		-- 	},
		-- },
		history = {
			enabled = true,
			opts = {
				picker = "snacks",
				continue_last_chat = true,
				expiration_days = 30,
				title_generation_opts = {
					refresh_every_n_prompts = 5,
					max_refreshes = 3,
				},
			},
		},
	},
	strategies = {
		chat = {
			adapter = "copilot",
			-- slash_commands = {
			-- 	vs_import = require("vs-code-companion").import_slash_command,
			-- 	vs_select = require("vs-code-companion").select_slash_command,
			-- },
			opts = {
				completion_provider = "blink",
				-- REF https://codecompanion.olimorris.dev/configuration/chat-buffer.html#prompt-decorator
				---Decorate the user message before it's sent to the LLM
				---@param message string
				---@param adapter CodeCompanion.Adapter
				---@param context table
				---@return string
				prompt_decorator = function(message, adapter, context)
					return string.format([[<prompt>%s</prompt>]], message)
				end,
			},
			tools = {
				opts = {
					default_tools = {
						-- do not use full_stack_dev directly, as we don't have the api key for websearching
						"full_stack_dev",
						"mcp",
						-- "cmd_runner",
						-- "list_code_usages",
						-- "fetch_webpage",
						-- "search_web",
						-- "files",
						"next_edit_suggestion",
					},
				},
			},
			keymaps = {
				options = {
					modes = { n = "?" },
					callback = function()
						require("which-key").show({ global = false, loop = true })
					end,
				},
			},
		},
		inline = {
			adapter = "copilot",
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
		-- REF https://github.com/olimorris/codecompanion.nvim/blob/4bec50da26b411e52accdabd358e7c00ff94d2d3/lua/codecompanion/config.lua#L624C7-L624C32
		-- Not sure how to remove this default prompt. Replace it instead
		["Generate a Commit Message"] = {
			strategy = "inline",
			opts = {
				placement = "before",
			},
			prompts = {
				{
					role = "user",
					content = function()
						return string.format(
							[[You are an expert at following the Conventional Commit specification. Please generate a commit message for me.

` ` `diff
%s
` ` `
]],
							vim.fn.system("git diff --no-ext-diff --staged")
						)
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
		-- REF https://github.com/lazymaniac/nvim-ide/blob/f1b64adb39df3264165ae219c2358c8fcdf6aa62/lua/plugins/ai.lua#L141
		["Suggest Refactoring"] = {
			strategy = "chat",
			description = "Suggest refactoring for provided piece of code.",
			opts = {
				modes = { "v" },
				short_name = "refactor",
				auto_submit = false,
				is_slash_command = false,
				is_default = true,
				stop_context_insertion = true,
				user_prompt = false,
			},
			prompts = {
				{
					role = "system",
					content = function(_)
						return [[ Your task is to suggest refactoring of a specified piece of code to improve its efficiency, readability, and maintainability without altering its functionality. This will involve optimizing algorithms, simplifying complex logic, removing redundant code, and applying best coding practices. Check every aspect of the code, including variable names, function structures, and overall design patterns. Your goal is to provide a cleaner, more efficient version of the code that adheres to modern coding standards. ]]
					end,
				},
				{
					role = "user",
					content = function(context)
						local text =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
						return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
	},
	display = {
		chat = {
			intro_message = "Welcome to CodeCompanion!",
			start_in_insert_mode = true,
		},
		action_palette = {
			provider = "snacks",
		},
		diff = {
            enabled = true,
            provider = "split",
			provider_opts = {
				split = {
					close_chat_at = 240,
					layout = "vertical",
					opts = {
						"internal",
						"filler",
						"closeoff",
						"algorithm:histogram",
						"indent-heuristic",
						"followwrap",
						"linematch:120",
					},
				},
			},
		},
	},
	opts = {
		log_level = "INFO",
		send_code = true,
	},
})

require("img-clip").setup({
	filetypes = {
		codecompanion = {
			prompt_for_file_name = false,
			template = "[Image]($FILE_PATH)",
			use_absolute_path = true,
		},
	},
})
-- require("mcphub").setup({
-- 	auto_approve = false,
-- 	use_bundled_binary = true,
-- 	port = 3000,
-- 	config = vim.fn.expand("~/.config/mcphub/servers.json"),
-- 	global_env = {
-- 		["input:ado_org"] = "trintech-coe",
-- 	},
-- 	log = {
-- 		level = vim.log.levels.WARN,
-- 		to_file = false,
-- 		file_path = nil,
-- 		prefix = "MCPHub",
-- 	},
-- })
vim.keymap.set({ "n" }, "<leader>p<leader>a", function()
	vim.cmd("CodeCompanionActions")
end, { noremap = true, silent = true, desc = "Pick CodeCompanion actions" })

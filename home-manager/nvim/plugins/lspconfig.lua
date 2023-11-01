local function init(use)
	use({
		"neovim/nvim-lspconfig",
        commit = "d0467b9574b48429debf83f8248d8cee79562586",
		-- event = "CursorHold",
		config = function()
			local root_dir = function()
				return vim.fn.getcwd()
			end

			local on_attach = function(client)
				-- require("plugins.smart_hover").setup(client)
			end

			local lspconfig = require("lspconfig")

			local capabilities = vim.lsp.protocol.make_client_capabilities()

			capabilities.textDocument.completion.completionItem.snippetSupport = true

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })

			local Config = { root_dir = root_dir, capabilities = capabilities, on_attach = on_attach }
			Config.__index = Config

			function Config:new(opts)
				return setmetatable((opts or {}), Config)
			end

			local servers = {
                "als",
                "solang",
				"solargraph",
				"theme_check",
                "taplo",
				"mint",
				"bicep",
				"ansiblels",
				"vala_ls",
				"jdtls",
				"groovyls",
                --  for xml
                "lemminx",
				"html",
				"cssls",
				"jsonls",
				"leanls",
				"dhall_lsp_server",
				"hls",
				"dartls",
				"terraformls",
				"texlab",
				"ccls",
				"svelte",
				"vuels",
				"sqlls",
				"graphql",
				"elmls",
				"ocamlls",
				"puppet",
				"serve_d",
				"gdscript",
				"scry",
                --  Comment this out as they are not used at all
				--  "ember",
				--  "angularls",
				"bashls",
				"prismals",
				"tsserver",
				-- "denols"
				"dockerls",
				"nimls",
				"metals",
				"julials",
				"purescriptls",
				"rescriptls",
				"racket_langserver",
                "pasls",
				"yamlls",
				"vimls",
				"rnix",
                "r_language_server",
                "kotlin_language_server"
			}

			for _, server in ipairs(servers) do
                -- TOFIX: passing on_attach function here again, as somehow the on_attach function passed in metatable doesn't work
				lspconfig[server].setup(Config:new({ on_attach = on_attach}))
			end

			lspconfig.elixirls.setup(Config:new({
				cmd = { "elixir-ls" },
			}))
			lspconfig.rust_analyzer.setup(Config:new({
				checkOnSave = {
					allFeatures = true,
					-- overrideCommand = {
					-- "cargo",
					-- "clippy",
					-- "--workspace",
					-- "--message-format=json",
					-- "--all-targets",
					-- "--all-features",
					-- },
				},
			}))
			-- lspconfig.zeta_note.setup({ on_attach = on_attach, root_dir = root_dir })
			lspconfig.cmake.setup(Config:new({
				cmd = { "cmake-language-server" },
				filetypes = { "cmake" },
			}))

			lspconfig.pyright.setup(Config:new({
				cmd = { "pyright-langserver", "--stdio" },
			}))

			lspconfig.lua_ls.setup {
				on_init = function(client)
				  local path = client.workspace_folders[1].name
				  if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
					client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
					  Lua = {
						runtime = {
						  -- Tell the language server which version of Lua you're using
						  -- (most likely LuaJIT in the case of Neovim)
						  version = 'LuaJIT'
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
						  checkThirdParty = false,
						  library = {
							vim.env.VIMRUNTIME
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						  }
						  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						  -- library = vim.api.nvim_get_runtime_file("", true)
						}
					  }
					})
			  
					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				  end
				  return true
				end
			}

			-- local efm_config = Config:new({
			-- 	settings = {
			-- 		languages = require("plugins.efm"),
			-- 	},
			-- })

			-- efm_config.filetypes = vim.tbl_keys(efm_config.settings.languages)

			-- lspconfig.efm.setup(efm_config)

			lspconfig.gopls.setup(Config:new({
				cmd = { "gopls", "serve" },
				settings = {
					gopls = { analyses = { unusedparams = true }, staticcheck = true },
				},
			}))
		end,
	})

	use({
		"folke/trouble.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		after = "nvim-lspconfig",
		cmd = { "Trouble" },
		commit = "f1168feada93c0154ede4d1fe9183bf69bac54ea",
		config = function()
			require("trouble").setup({
				icons = true,
				position = "bottom",
				height = 10,
				use_diagnostic_signs = true,
				indent_lines = false,
				auto_open = true,
				auto_close = true,
			})

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					require("trouble").open()
				end,
			})
		end,
	})
end

return { init = init }
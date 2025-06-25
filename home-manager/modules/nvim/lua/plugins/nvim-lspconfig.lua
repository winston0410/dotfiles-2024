return {
	{
		"zeioth/garbage-day.nvim",
		dependencies = {},
		event = { "VeryLazy" },
		opts = {
			wakeup_delay = 250,
			grace_period = 60 * 10,
		},
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "ckolkey/ts-node-action", "ThePrimeagen/refactoring.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.commitlint,
					null_ls.builtins.diagnostics.checkmake,
					null_ls.builtins.diagnostics.fish,
					null_ls.builtins.diagnostics.haml_lint,
					null_ls.builtins.diagnostics.terraform_validate,
					null_ls.builtins.diagnostics.tidy,
					null_ls.builtins.diagnostics.hadolint,
					null_ls.builtins.diagnostics.golangci_lint,
					null_ls.builtins.diagnostics.opacheck,
					null_ls.builtins.code_actions.refactoring,
					null_ls.builtins.code_actions.ts_node_action,
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		enabled = true,
		version = "2.x",
		-- Reference the lazyload event from LazyVim
		-- REF https://github.com/LazyVim/LazyVim/blob/86ac9989ea15b7a69bb2bdf719a9a809db5ce526/lua/lazyvim/plugins/lsp/init.lua#L5
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

			local servers = {
				"azure_pipelines_ls",
				"pest_ls",
				"nxls",
				"nushell",
				"rust_analyzer",
				"nginx_language_server",
				"astro",
				"beancount",
				"solang",
				"solargraph",
				"theme_check",
				"taplo",
				"templ",
				"vacuum",
				"unocss",
				"mint",
				"bicep",
				"ansiblels",
				"vala_ls",
				"jdtls",
				"groovyls",
				"lemminx",
				"html",
				"cssls",
				"jsonls",
				"jsonnet_ls",
				"leanls",
				"dhall_lsp_server",
				"hls",
				"dartls",
				"terraformls",
				"texlab",
				"tilt_ls",
				"ccls",
				"svelte",
				"graphql",
				"elmls",
				"ocamlls",
				"puppet",
				"serve_d",
				"gdscript",
				"scry",
				"biome",
				"eslint",
				"angularls",
				"bashls",
				"hhvm",
				"prismals",
				"gopls",
				"docker_compose_language_service",
				"glsl_analyzer",
				"gradle_ls",
				"nimls",
				"metals",
				"julials",
				"purescriptls",
				"rescriptls",
				"racket_langserver",
				"pasls",
				"postgres_lsp",
				"vimls",
				"nixd",
				"r_language_server",
				"kotlin_language_server",
				"cmake",
				"pyright",
				"taplo",
				"cucumber_language_server",
				"slint_lsp",
				"regal",
				"ballerina",
				"bitbake_ls",
				"ltex",
				"csharp_ls",
				"tsp_server",
			}

			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					on_init = function(client)
						-- NOTE use only Treesitter for syntax highlight
						client.server_capabilities.semanticTokensProvider = nil
					end,
					capabilities = capabilities,
				})
			end

			vim.lsp.config("yamlls", {
				settings = {
					redhat = {
						telemetry = {
							enabled = false,
						},
					},
				},
			})

			lspconfig.elixirls.setup({
				cmd = { "elixir-ls" },
				capabilities = capabilities,
			})

			lspconfig.kulala_ls.setup({
				capabilities = capabilities,
				filetypes = { "http", "rest" },
			})

			lspconfig.dockerls.setup({
				capabilities = capabilities,
				settings = {
					docker = {
						languageserver = {
							formatter = {
								ignoreMultilineInstructions = true,
							},
						},
					},
				},
			})

			local ok, vue_language_server_path = pcall(function()
				local res = vim.system({ "which", "vue-language-server" }, { text = true }):wait()
				if res.code ~= 0 then
					return error(res.stdout)
				end
				res.stdout = res.stdout:gsub("\n", "")
				res = vim.system({ "nix", "path-info", res.stdout }, { text = true }):wait()

				if res.code ~= 0 then
					return error(res.stdout)
				end
				return res.stdout:gsub("\n", "")
			end)

			local ts_ls_plugins = {}

			if ok then
				table.insert(ts_ls_plugins, {
					name = "@vue/typescript-plugin",
					location = vim.fs.joinpath(vue_language_server_path, "node_modules", "@vue", "typescript-plugin"),
					languages = { "javascript", "typescript", "vue" },
				})
			else
				vim.notify(
					string.format("Failed to set up @vue/typescript-plugin: %s", vue_language_server_path),
					vim.log.levels.WARN
				)
			end

			lspconfig.ts_ls.setup({
				init_options = {
					plugins = ts_ls_plugins,
				},
				filetypes = {
					"javascript",
					"typescript",
					"vue",
				},
			})
			lspconfig.denols.setup({
				capabilities = capabilities,
				root_dir = util.root_pattern("deno.json", "deno.jsonc"),
			})
			lspconfig.lua_ls.setup({
				diagnostics = {
					underline = true,
					update_in_insert = true,
					severity_sort = true,
				},
				capabilities = capabilities,
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end
				end,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						workspace = {
							checkThirdParty = false,
							library = {},
						},
						diagnostics = {
							globals = {},
						},
						telemetry = {
							enable = false,
						},
						hint = { enable = true },
					},
				},
				inlay_hints = {
					enabled = true,
					exclude = {},
				},
				codelens = {
					enabled = true,
				},
				document_highlight = {
					enabled = true,
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local supported_modes = { "n" }
					-- vim.keymap.set(supported_modes, "]de", function()
					-- 	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
					-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to next error" })
					-- vim.keymap.set(supported_modes, "[de", function()
					-- 	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
					-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to previous error" })
					--
					-- vim.keymap.set(supported_modes, "]dw", function()
					-- 	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
					-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to next warning" })
					-- vim.keymap.set(supported_modes, "[dw", function()
					-- 	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
					-- end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to previous warning" })
					vim.keymap.set(supported_modes, "<leader>ss", function()
						-- if we call twice, we will enter the hover windows immediately after running the keybinding
						vim.lsp.buf.hover()
					end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show hover tips" })
					vim.keymap.set(supported_modes, "<leader>sd", function()
						vim.diagnostic.open_float()
					end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show diagnostics message" })
					-- TODO combine all these functions, using Snacks.picker
					vim.keymap.set(supported_modes, "<leader>s1", function()
						Snacks.picker.lsp_definitions()
					end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to definition" })
					vim.keymap.set(supported_modes, "<leader>s2", function()
						Snacks.picker.lsp_type_definitions()
					end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to type definition" })
					vim.keymap.set(supported_modes, "<leader>s3", function()
						Snacks.picker.lsp_implementations()
					end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to implementation" })
					vim.keymap.set(supported_modes, "<leader>s4", function()
						Snacks.picker.lsp_references()
					end, {
						silent = true,
						noremap = true,
						buffer = ev.buf,
						desc = "Jump to references",
						nowait = true,
					})
					vim.keymap.set(
						{ "n", "x" },
						"<leader>s5",
						vim.lsp.buf.rename,
						{ silent = true, noremap = true, buffer = ev.buf, desc = "Rename variable" }
					)
					vim.keymap.set(
						{ "n", "x" },
						"<leader>s6",
						vim.lsp.buf.code_action,
						{ silent = true, noremap = true, buffer = ev.buf, desc = "Apply code action" }
					)
					pcall(function()
						-- Remove default keybinding added by lspconfig
						-- REF https://neovim.io/doc/user/lsp.html#lsp-config
						vim.keymap.del({ "n" }, "K", { buffer = ev.buf })
					end)

					vim.diagnostic.config({
						underline = true,
						virtual_text = false,
						virtual_lines = { current_line = true },
						signs = {
							text = {
								-- FIXME: cannot customize the icon, without not showing it in signcolumn
								-- [vim.diagnostic.severity.ERROR] = ERROR_ICON,
								-- [vim.diagnostic.severity.WARN] = WARNING_ICON,
								-- [vim.diagnostic.severity.INFO] = INFO_ICON,
								-- [vim.diagnostic.severity.HINT] = HINT_ICON,
								[vim.diagnostic.severity.ERROR] = "",
								[vim.diagnostic.severity.WARN] = "",
								[vim.diagnostic.severity.INFO] = "",
								[vim.diagnostic.severity.HINT] = "",
							},
						},
						update_in_insert = true,
					})
				end,
			})
		end,
	},
}

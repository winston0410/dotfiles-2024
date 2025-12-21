local function setup_lspconfig()
	vim.pack.add({
		{ src = "https://github.com/neovim/nvim-lspconfig", version = vim.version.range("2.x") },
	})

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
	capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

	vim.lsp.config("*", {
		capabilities = capabilities,
	})

	-- REF https://github.com/AkisArou/npm-workspaces-lsp package this with Nix
	vim.lsp.config("npmls", {
		cmd = { "npm-workspaces-lsp", "--stdio" },
		filetypes = { "json" },
		root_markers = { "package.json" },
		workspace_required = true,
	})
	vim.lsp.config("elixirls", {
		cmd = { "elixir-ls" },
	})

	vim.lsp.config("denols", {
		workspace_required = true,
		root_markers = { "deno.json", "deno.jsonc" },
	})
	vim.lsp.config("angularls", {
		workspace_required = true,
		root_markers = { "angular.json" },
	})

	vim.lsp.config("kulala_ls", {
		filetypes = { "http", "rest" },
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

	-- TODO set up vue support later
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
	vim.lsp.config("docker_language_server", {
		cmd = { "docker-language-server", "start", "--stdio" },
		filetypes = { "yaml.docker-compose", "dockerfile" },
	})
    -- NOTE not very useful
	-- vim.lsp.config("config_lsp", {
	-- 	cmd = { "config-lsp" },
	-- 	filetypes = {
	-- 		"sshconfig",
	-- 		"sshdconfig",
	-- 		"fstab",
	-- 		"aliases",
	-- 		"mailaliases",
	-- 		-- Matches wireguard configs and /etc/hosts
	-- 		"conf",
	-- 	},
	-- })

	-- REF https://github.com/b0o/SchemaStore.nvim
	vim.lsp.config("yamlls", {
		settings = {
			yaml = {
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	})
	vim.lsp.config("jsonls", {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	})
	vim.lsp.config("ltex_plus", {
		settings = {
			ltex = {
				language = "en-GB",
			},
		},
	})
	vim.lsp.config("lua_ls", {
		diagnostics = {
			underline = true,
			update_in_insert = true,
			severity_sort = true,
		},
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
				hint = { enable = true, arrayIndex = "Disable" },
			},
		},
	})

	local servers = {
		"visualforce_ls",
		"apex_ls",
		"lwc_ls",
		"air",
		"contextive",
		"codeqlls",
		"denols",
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
		"roslyn_ls",
		"bicep",
		"ansiblels",
		"vala_ls",
		"jdtls",
		"groovyls",
		"lemminx",
		"html",
		"cssls",
		"tailwindcss",
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
		"awk_ls",
		"hyprls",
		"gleam",
		"ast_grep",
		"gnls",
		"eslint",
		"angularls",
		"bashls",
		"hhvm",
		"prismals",
		"gopls",
		-- "docker_compose_language_service",
		-- "dockerls",
		"docker_language_server",
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
		"atopile",
		"basedpyright",
		-- TODO replace basedpyright with ty or zuban, once it is ready
		-- zuban 0.23 would panic immediately after starting up
		-- "ty",
		-- TODO switch over from pyright to tv, once it is more stable
		-- "tv",
		"gdscript",
		"ruff-lsp",
		"taplo",
		"cucumber_language_server",
		"slint_lsp",
		"regal",
		"ballerina",
		"bitbake_ls",
		"ltex_plus",
		"tsp_server",
		"yamlls",
		"kulala_ls",
		"ts_ls",
		"tsgo",
		"earthlyls",
		"elixirls",
		"lua_ls",
		"v-analyzer",
		-- TODO check if this server is more mature now.This is fast but does not provide enough configuration
		-- "emmylua_ls",
		-- "config_lsp",
		"systemd_lsp",
		"openscad_lsp",
		"ziggy_schema",
		"ziggy",
		"cypher_ls",
		"npmls",
		"typos_lsp",
		"powershell_es",
		"protols",
		"ts_query_ls",
		"clojure_lsp",
		"teal_ls",
		"tclsp",
		"uiua",
		"veryl_ls",
		"wasm_language_tools",
		"marko-js",
		"cue",
		"aiken",
		"arduino_language_server",
		"erg_language_server",
	}
	vim.lsp.enable(servers, true)
end

local autocmd_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
	once = true,
	group = autocmd_group,
	callback = function()
		setup_lspconfig()
	end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	once = true,
	group = autocmd_group,
	callback = function()
		setup_lspconfig()
	end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	once = true,
	group = autocmd_group,
	callback = function()
		setup_lspconfig()
	end,
})

vim.pack.add({
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = autocmd_group,
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
		vim.keymap.set(supported_modes, "<leader>sgd", function()
			Snacks.picker.lsp_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to definition" })
		vim.keymap.set(supported_modes, "<leader>sgt", function()
			Snacks.picker.lsp_type_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to type definition" })
		vim.keymap.set(supported_modes, "<leader>sgi", function()
			Snacks.picker.lsp_implementations()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to implementation" })
		vim.keymap.set(supported_modes, "<leader>sgr", function()
			Snacks.picker.lsp_references()
		end, {
			silent = true,
			noremap = true,
			buffer = ev.buf,
			desc = "Jump to references",
			nowait = true,
		})
		vim.keymap.set({ "n" }, "<leader>sgc", function()
			Snacks.picker.lsp_incoming_calls()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Incoming calls" })
		vim.keymap.set({ "n" }, "<leader>sgC", function()
			Snacks.picker.lsp_outgoing_calls()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Outgoing calls" })
		vim.keymap.set({ "n" }, "<leader>s<leader>q", function()
			vim.diagnostic.setqflist({
				severity = { min = vim.diagnostic.severity.WARN },
			})
			vim.cmd.copen()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Push diagnostics into Quickfix" })
		vim.keymap.set(
			{ "n", "x" },
			"<leader>sr",
			vim.lsp.buf.rename,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Rename variable" }
		)
		vim.keymap.set({ "n", "x" }, "<leader>sR", function()
			require("tiny-code-action").code_action({})
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Apply code action" })

		vim.diagnostic.config({
			underline = true,
			virtual_text = false,
			virtual_lines = false,
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

		vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client == nil then
			return
		end
		client.server_capabilities.semanticTokensProvider = nil
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = autocmd_group,
	once = true,
	callback = function(ev)
		vim.pack.add({
			{ src = "https://github.com/dmmulroy/ts-error-translator.nvim", version = vim.version.range("2.x") },
			{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
			{ src = "https://github.com/rachartier/tiny-code-action.nvim" },
			{ src = "https://github.com/AbysmalBiscuit/insert-inlay-hints.nvim" },
			{ src = "https://github.com/jmbuhr/otter.nvim", version = vim.version.range("2.x") },
            { src = "https://github.com/nvim-lua/plenary.nvim" },
			{ src = "https://github.com/nvimtools/none-ls.nvim" },
			{ src = "https://github.com/ThePrimeagen/refactoring.nvim" },
		})

		require("ts-error-translator").setup({
			auto_attach = true,
		})
		require("tiny-inline-diagnostic").setup({
			options = {
				show_source = {
					enabled = true,
				},
				show_related = {
					enabled = true,
					max_count = 3,
				},
			},
		})
		vim.diagnostic.config({ virtual_text = false })
		vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float

		require("tiny-code-action").setup({
			backend = "vim",
			picker = "snacks",
		})

		local host_languages =
			vim.list_extend(require("syringe").get_supported_host_languages(), { "markdown", "markdown_inline" })
		local otter = require("otter")
		otter.setup({
			lsp = {
				diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
			},
		})
		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			callback = function(ev)
				local main_lang = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
				if not vim.tbl_contains(host_languages, main_lang) then
					return
				end

				local parsername = vim.treesitter.language.get_lang(main_lang)
				if not parsername then
					return
				end
				local ok, parser = pcall(function()
					local parser = vim.treesitter.get_parser(ev.buf, parsername)
					return parser
				end)
				if not ok or not parser then
					return
				end
				otter.activate()
			end,
		})

		vim.keymap.set("n", "<leader>si", function()
			require("insert-inlay-hints").closest()
		end, { silent = true, noremap = true, desc = "Insert the closest inline hint as code." })

		vim.keymap.set(
			"x",
			"<leader>si",
			function()
				require("insert-inlay-hints").visual()
			end,
			{ silent = true, noremap = true, desc = "Insert all inlay hints in the current visual selection as code." }
		)

		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.code_actions.refactoring,
			},
		})
	end,
})

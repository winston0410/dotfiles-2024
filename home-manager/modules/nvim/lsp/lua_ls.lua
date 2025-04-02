return {
	diagnostics = {
		underline = true,
		update_in_insert = true,
		severity_sort = true,
	},
	on_init = function(client)
		-- FIXME seems to be able to prevent LSP from highlighting
		client.server_capabilities.semanticTokensProvider = nil

		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {},
			},
		})
	end,
	settings = {
		Lua = {
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
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
}

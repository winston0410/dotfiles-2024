return {
	root_markers = { ".luarc.json", ".luarc.jsonc" },
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

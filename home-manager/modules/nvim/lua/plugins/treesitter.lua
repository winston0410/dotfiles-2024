
local ts_deps = { "nvim-treesitter/nvim-treesitter", branch = "main" }
return {
	-- keep using this until d2 filetype and treesitter grammar is supported by neovim out of the box
	{
		"ravsii/tree-sitter-d2",
		dependencies = ts_deps,
		version = "*",
		build = "make nvim-install",
	},
}

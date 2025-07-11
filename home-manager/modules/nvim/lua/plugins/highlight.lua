return {
	{
		"tzachar/highlight-undo.nvim",
		-- Using u and <C-r> seems to be enough for me
		enabled = false,
		event = "VeryLazy",
		opts = {
			hlgroup = "Visual",
			duration = 500,
			pattern = { "*" },
			ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "snacks_dashboard" },
		},
	},
}

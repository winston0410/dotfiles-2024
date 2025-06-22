return {
	{
		"tzachar/highlight-undo.nvim",
		enabled = true,
		event = "VeryLazy",
		opts = {
			hlgroup = "Visual",
			duration = 500,
			pattern = { "*" },
			ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "snacks_dashboard" },
		},
	},
}

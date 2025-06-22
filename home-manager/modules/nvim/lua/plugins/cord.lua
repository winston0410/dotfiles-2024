return {
	{
		"vyfor/cord.nvim",
		event = "VeryLazy",
		build = ":Cord update",
		opts = {
			timestamp = {
				enabled = true,
				reset_on_idle = false,
				reset_on_change = false,
			},
			editor = {
				client = "neovim",
				tooltip = "Hugo's ultimate editor",
			},
		},
	},
}

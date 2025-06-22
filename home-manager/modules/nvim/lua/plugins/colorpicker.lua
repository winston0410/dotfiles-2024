return {
	-- TODO set up this colorpicker
	{
		"nvzone/minty",
		enabled = false,
		cmd = { "Shades", "Huefy" },
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "VeryLazy" },
		opts = {
			render = "virtual",
			enable_tailwind = true,
			exclude_filetypes = {
				"lazy",
				"checkhealth",
				"qf",
				"snacks_dashboard",
				"snacks_picker_list",
				"snacks_picker_input",
			},
			exclude_buftypes = {},
		},
	},
}

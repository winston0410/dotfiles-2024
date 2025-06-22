return {
	{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = { "VeryLazy" } },
	{
		"nacro90/numb.nvim",
		enabled = true,
		event = { "CmdlineEnter" },
		config = function()
			require("numb").setup()
		end,
	},
	{
		"winston0410/range-highlight.nvim",
		event = { "CmdlineEnter" },
		opts = {},
	},
}

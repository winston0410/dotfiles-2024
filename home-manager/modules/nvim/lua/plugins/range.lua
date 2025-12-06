return {
	{ "sitiom/nvim-numbertoggle", commit = "c469e0e588a54895591047f94c9f9ff5a1d658aa", event = { "VeryLazy" } },
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

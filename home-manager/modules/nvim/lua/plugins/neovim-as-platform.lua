return {
	{
		"martineausimon/nvim-lilypond-suite",
		cmd = { "LilyPlayer", "LilyCmp", "LilyDebug" },
		config = function()
			require("nvls").setup({})
		end,
	},
	{
		"Apeiros-46B/qalc.nvim",
		ft = { "qalc" },
		cmd = { "Qalc" },
		config = function()
			require("qalc").setup({})
		end,
	},
	{
		"xemptuous/sqlua.nvim",
		cmd = "SQLua",
		config = function()
			require("sqlua").setup({
				keybinds = {
					execute_query = "<cr>",
					activate_db = "<cr>",
				},
			})
		end,
	},
}

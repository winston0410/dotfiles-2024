return {
	{
		"sphamba/smear-cursor.nvim",
		cmd = { "SmearCursorToggle" },
		event = { "CursorHold" },
		config = function()
			require("smear_cursor").setup({})
			require("smear_cursor").enabled = false
		end,
	},
}

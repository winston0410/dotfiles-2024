vim.pack.add({
	{ src = "https://github.com/NickvanDyke/opencode.nvim", version = "main" },
}, { confirm = false })

vim.g.opencode_opts = {
	provider = {
		enabled = "wezterm",
		wezterm = {},
	},
}

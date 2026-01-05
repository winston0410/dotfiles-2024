vim.pack.add({
	{ src = "https://github.com/NickvanDyke/opencode.nvim", version = "main" },
}, { confirm = false })

vim.g.opencode_opts = {
	provider = {
		enabled = "terminal",
		wezterm = {
			direction = "right",
			percent = 33,
		},
	},
}

vim.keymap.set({ "n", "x" }, "<leader>p<leader>c", function()
	require("opencode").select()
end, { desc = "Explore Opencode action" })

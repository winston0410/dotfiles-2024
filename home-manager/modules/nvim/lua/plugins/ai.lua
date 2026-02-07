vim.pack.add({
    -- pin to this version for now, as it is buggy afterwards
	{ src = "https://github.com/NickvanDyke/opencode.nvim", version = "v0.1.0" },
}, { confirm = false })

vim.g.opencode_opts = {
	provider = {
		enabled = "terminal",
		wezterm = {
			direction = "right",
			percent = 33,
		},
        -- always start a new session, but optionally opt into an existing session
        -- cmd = 'opencode --continue'
	},
}

vim.keymap.set({ "n", "x" }, "<leader>p<leader>c", function()
	require("opencode").select()
end, { desc = "Explore Opencode action" })

vim.pack.add({
    -- pin to this version for now, as it is buggy afterwards
	{ src = "https://github.com/NickvanDyke/opencode.nvim", version = "e83a9eb1e24aad925769cc7451ba6c2fbe54b400" },
}, { confirm = false })

vim.g.opencode_opts = {
	provider = {
		enabled = "terminal",
        terminal = {
            number = false,
            relativenumber = false
        },
		wezterm = {
			direction = "right",
			percent = 33,
		},
        cmd = 'opencode --continue'
	},
}

vim.keymap.set({ "n", "x" }, "<leader>p<leader>c", function()
	require("opencode").select()
end, { desc = "Explore Opencode action" })

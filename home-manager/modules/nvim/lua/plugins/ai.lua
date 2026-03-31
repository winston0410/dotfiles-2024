vim.pack.add({
    -- pin to this version for now, as it is buggy afterwards
	{ src = "https://github.com/NickvanDyke/opencode.nvim", version = "v0.6.0" },
}, { confirm = false })

vim.keymap.set({ "n", "x" }, "<leader>p<leader>c", function()
	require("opencode").select()
end, { desc = "Explore Opencode action" })

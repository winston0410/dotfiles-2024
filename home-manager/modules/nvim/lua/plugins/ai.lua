vim.pack.add({
	-- pin to this version for now, as it is buggy afterwards
	{ src = "https://github.com/NickvanDyke/opencode.nvim", version = "v0.6.0" },
	{ src = "https://github.com/coder/claudecode.nvim", version = "v0.3.0" },
}, { confirm = false })

vim.keymap.set({ "n", "x" }, "<leader>p<leader>c", function()
	require("opencode").select()
end, { desc = "Explore Opencode action" })

vim.keymap.set({ "n", "x" }, "<leader>c", function()
	return require("opencode").operator("@this ")
end, { desc = "Add range to opencode", expr = true })

require("claudecode").setup({})

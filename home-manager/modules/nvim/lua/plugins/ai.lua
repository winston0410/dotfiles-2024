vim.pack.add({
	{ src = "https://github.com/carlos-algms/agentic.nvim" },
}, { confirm = false })

require("agentic").setup({
	provider = "codex-acp",
})

vim.keymap.set({ "n", "v", "i" }, "<C-\\>", function()
	require("agentic").toggle()
end, { desc = "Toggle Agentic Chat" })

vim.keymap.set({ "n", "v" }, "<C-'>", function()
	require("agentic").add_selection_or_file_to_context()
end, { desc = "Add file or selection to context" })

vim.pack.add({
	{ src = "https://github.com/stevearc/overseer.nvim", version = vim.version.range("2.x") },
})
local overseer = require("overseer")
overseer.setup({
	bundles = {
		autostart_on_load = false,
	},
})
vim.keymap.set({ "n" }, "<leader>e", function()
	require("overseer").toggle()
end, { silent = true, noremap = true, desc = "Toggle Overseer" })
vim.keymap.set({ "n" }, "<leader>p<leader>e", function()
	vim.cmd("OverseerRun")
end, { silent = true, noremap = true, desc = "Trigger tasks" })

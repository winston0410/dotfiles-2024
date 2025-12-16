vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
})
require("neogit").setup({
	-- FIXME range diffing is not working correctly, cannot select the target of "to"
	disable_hint = true,
	disable_commit_confirmation = true,
	graph_style = "unicode",
	kind = "tab",
	integrations = {
		diffview = true,
		snacks = true,
	},
	mappings = {
		status = {
			["<enter>"] = "Toggle",
		},
	},
})
vim.keymap.set({ "n" }, "<leader>gg", function()
	require("neogit").open()
end, { silent = true, noremap = true, desc = "Open Neogit status" })

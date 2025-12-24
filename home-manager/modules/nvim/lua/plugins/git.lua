vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit", version = "master" },
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
	-- NOTE setting it to false is buggy right now
	-- use_default_keymaps = true,
	mappings = {
		commit_editor_I = {
			["<c-c><c-c>"] = "Submit",
			["<c-c><c-k>"] = "Abort",
		},
		rebase_editor_I = {
			["<c-c><c-c>"] = "Submit",
			["<c-c><c-k>"] = "Abort",
		},
		popup = {
			["?"] = "HelpPopup",
			["c"] = "CommitPopup",
			["b"] = "BranchPopup",
			["B"] = "BisectPopup",
			["A"] = false,
			["d"] = false,
			["M"] = false,
			["P"] = false,
			["X"] = false,
			["Z"] = false,
			["i"] = false,
			["t"] = false,
			["w"] = false,
			["f"] = false,
			["l"] = false,
			["m"] = false,
			["p"] = false,
			["r"] = false,
			["v"] = false,
			["L"] = false,
		},
		status = {
            ["$"] = false,
            ["I"] = false,
			["Q"] = false,
        },
		finder = {},
		commit_editor = {},
		rebase_editor = {},
	},
})
vim.keymap.set({ "n" }, "<leader>gg", function()
	require("neogit").open()
end, { silent = true, noremap = true, desc = "Open Neogit status" })

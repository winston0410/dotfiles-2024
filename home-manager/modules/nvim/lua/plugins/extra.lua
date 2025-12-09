-- really optional plugins
vim.pack.add({
	{ src = "https://github.com/vyfor/cord.nvim", version = vim.version.range("2.0") },
	{ src = "https://github.com/michaelb/sniprun", version = "v1.3.20"},
})
require("cord").setup({
	timestamp = {
		enabled = true,
		reset_on_idle = false,
		reset_on_change = false,
	},
	editor = {
		client = "neovim",
		tooltip = "Hugo's ultimate editor",
	},
})
require("sniprun").setup({
	binary_path = "sniprun",
	selected_interpreters = { "Python3_fifo" },
	repl_enable = { "Python3_fifo" },
	interpreter_options = {
		CSharp_original = {
			compiler = "csc",
		},
		TypeScript_original = {
			interpreter = "node",
		},
	},
	snipruncolors = {
		SniprunVirtualTextOk = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextInfo" }),
		SniprunVirtualWinOk = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextInfo" }),
		SniprunVirtualTextErr = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }),
		SniprunVirtualWinErr = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }),
	},
})

-- plugins that would help with motion and textobjects
vim.pack.add({
	{ src = "https://github.com/folke/flash.nvim", version = vim.version.range("2.0") },
	-- { src = "https://github.com/winston0410/syringe.nvim", version = "main" },
	{ src = "https://github.com/winston0410/range-highlight.nvim", version = "master" },
	{ src = "https://github.com/nacro90/numb.nvim", version = "master" },
	{ src = "https://github.com/sitiom/nvim-numbertoggle" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	{ src = "https://github.com/NStefan002/screenkey.nvim", version = "main" },
	{ src = "http://github.com/winston0410/sops.nvim", version = "main" },
	{ src = "https://github.com/folke/which-key.nvim", version = vim.version.range("3.0") },
	{ src = "https://github.com/chrisgrieser/nvim-various-textobjs" },
	{ src = "https://github.com/chrisgrieser/nvim-spider" },
	{ src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("3.0") },
	{ src = "https://github.com/sphamba/smear-cursor.nvim", version = vim.version.range("0.6") },
	{ src = "https://github.com/s1n7ax/nvim-window-picker", version = vim.version.range("2.0") },
})
-- require("syringe").setup({})
require("numb").setup()
require("nvim-highlight-colors").setup({
	render = "virtual",
	enable_tailwind = true,
	exclude_filetypes = {
		"lazy",
		"checkhealth",
		"qf",
		"snacks_dashboard",
		"snacks_picker_list",
		"snacks_picker_input",
	},
	exclude_buftypes = {},
})

vim.b.sops_auto_transform = true
vim.g.sops_auto_transform = true

require("various-textobjs").setup({
	keymaps = {
		useDefaults = false,
	},
})
vim.keymap.set({ "o", "x" }, "ad", function()
	require("various-textobjs").diagnostic()
end, { silent = true, noremap = true, desc = "Around diagnostic" })
vim.keymap.set({ "o", "x" }, "au", function()
	require("various-textobjs").url()
end, { silent = true, noremap = true, desc = "Around URL" })
vim.keymap.set({ "o", "x" }, "aw", function()
	require("various-textobjs").subword("outer")
end, { silent = true, noremap = true, desc = "Around subword" })
vim.keymap.set({ "o", "x" }, "iw", function()
	require("various-textobjs").subword("inner")
end, { silent = true, noremap = true, desc = "Inside subword" })
require("nvim-surround").setup({
	keymaps = {
		insert = "<C-g>s",
		insert_line = "<C-g>S",
		normal = "s",
		normal_cur = "ss",
		normal_line = "S",
		normal_cur_line = "SS",
		visual = "s",
		visual_line = "gS",
		delete = "ds",
		change = "cs",
		change_line = "cS",
	},
	aliases = {},
})

vim.keymap.set({ "n", "o", "x" }, "w", function()
	require("spider").motion("w")
end, { silent = true, noremap = true, desc = "Jump forward to word" })
vim.keymap.set({ "n", "o", "x" }, "e", function()
	require("spider").motion("e")
end, { silent = true, noremap = true, desc = "Jump forward to end of word" })
vim.keymap.set({ "n", "o", "x" }, "ge", function()
	require("spider").motion("ge")
end, { silent = true, noremap = true, desc = "Jump backward to previous end of word" })
vim.keymap.set({ "n", "o", "x" }, "b", function()
	require("spider").motion("b")
end, { silent = true, noremap = true, desc = "Jump backward to word" })

local wk = require("which-key")

wk.setup({
	preset = "helix",
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = false,
			suggestions = 20,
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	keys = {
		scroll_down = "<c-n>",
		scroll_up = "<c-p>",
	},
})

vim.keymap.set({ "n" }, "<leader>b?", function()
	wk.show({ global = false, loop = true })
end, { noremap = true, silent = true, desc = "Show local keymaps" })

vim.keymap.set({ "n" }, "<leader>b?", function()
	wk.show({ global = true, loop = true })
end, { noremap = true, silent = true, desc = "Show global keymaps" })

require("smear_cursor").setup({})
require("smear_cursor").enabled = false
require("flash").setup({
	highlight = {
		backdrop = false,
		matches = true,
	},
	---@type table<string, Flash.Config>
	modes = {
		search = {
			enabled = false,
		},
		char = {
			enabled = false,
			highlight = {
				backdrop = false,
			},
		},
	},
})

vim.keymap.set({ "n", "x", "o" }, "<leader>/", function()
	require("flash").jump({
		remote_op = {
			restore = true,
			motion = true,
		},
	})
end, { noremap = true, silent = true, desc = "Flash" })

require("window-picker").setup({
	show_prompt = false,
	hint = "floating-big-letter",
})

vim.keymap.set({ "n" }, "<C-w>x", function()
	local picked_window_id = require("window-picker").pick_window()
	if picked_window_id == nil then
		return
	end

	local picked_buf_id = vim.api.nvim_win_get_buf(picked_window_id)

	local cur_win_id = vim.api.nvim_get_current_win()
	local cur_buf_id = vim.api.nvim_win_get_buf(cur_win_id)

	vim.api.nvim_win_set_buf(picked_window_id, cur_buf_id)
	vim.api.nvim_win_set_buf(cur_win_id, picked_buf_id)
end, { noremap = true, silent = true, desc = "Swap window" })

vim.keymap.set({ "n" }, "<leader>p<C-w>", function()
	local picked_window_id = require("window-picker").pick_window()
	if picked_window_id == nil then
		return
	end
	vim.api.nvim_set_current_win(picked_window_id)
end, { noremap = true, silent = true, desc = "Pick window" })

-- # Config principle
-- 1. When defining mappings are related with operators and textobjects, follow the verb -> noun convention, so we don't have to go into visual mode all the time to get things done like in Helix
-- 2. When defining mappings that are not related with operators and textobjects, follow the noun -> verb convention, as there could be conflicting actions between different topics, making mappings definition difficult
-- 3. Following the default Vim's mapping semantic and enhance it

-- ## Operators
-- REF https://neovim.io/doc/user/motion.html#operator
-- We only use c, d, y, p, >, <, <leader>c, gq and ~ operator for manipulating textobjects.
-- And finally gx for opening url in neovim.
-- For compound operators, for example change surround, the topic specific operator should precede generic operator( i.e. we should use sc instead of cs. ), so that we will not confuse the topic speicifc operator with textobjects.

-- ## Register
-- for deleting without polluting the current register, use blackhold register _, for example "_dd
require("custom.essential")
local godot = require("custom.godot")

-- REF https://unix.stackexchange.com/a/637223/467987

-- vim.keymap.set({ "n" }, "[z", "zj", { silent = true, noremap = true, desc = "Jump to previous fold" })
-- vim.keymap.set({ "n" }, "]z", "zk", { silent = true, noremap = true, desc = "Jump to next fold" })

-- TODO how can I always open helpfiles in a tab?

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.pack.add({
	{ src = "https://github.com/mcauley-penney/visual-whitespace.nvim", version = "main" },
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function(event)
		local comment_hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
		local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
		require("visual-whitespace").setup({
			highlight = { fg = comment_hl.fg, bg = visual_hl.bg },
		})
	end,
})

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/e-ink-colorscheme/e-ink.nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
	{ src = "https://github.com/thesimonho/kanagawa-paper.nvim" },
	{ src = "https://github.com/kyza0d/xeno.nvim" },
	{ src = "https://github.com/AlexvZyl/nordic.nvim" },
	{ src = "https://github.com/jnz/studio98" },
})

vim.g.tokyonight_style = "moon"
vim.cmd.colorscheme("tokyonight")
vim.opt.wildignore:append({
	"tokyonight.lua",
	"tokyonight-night.lua",
	"tokyonight-day.lua",
	"rose-pine.lua",
	"rose-pine-main.lua",
	"rose-pine-dawn.lua",
})
local xeno = require("xeno")
xeno.config({
	transparent = true,
	contrast = 0.1,
})

xeno.new_theme("xeno-lilypad", {
	base = "#1E1E1E",
	accent = "#8CBE8C",
	contrast = 0.1,
})

xeno.new_theme("xeno-golden-hour", {
	base = "#11100f",
	accent = "#FFCC33",
	contrast = 0.1,
})

vim.pack.add({
	-- { src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- { src = "https://github.com/nvim-mini/mini.icons" },
	-- { src = "https://github.com/onsails/lspkind.nvim" },
	{ src = "https://github.com/winston0410/syringe.nvim", version = "main" },
	{ src = "https://github.com/winston0410/range-highlight.nvim", version = "master" },
	{ src = "https://github.com/nacro90/numb.nvim", version = "master" },
	-- FIXME these plugins cannot work as expected with vim.pack.add
	-- { src = "https://github.com/sitiom/nvim-numbertoggle" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	{ src = "https://github.com/NStefan002/screenkey.nvim", version = "main" },
	{ src = "http://github.com/winston0410/sops.nvim", version = "main" },
	{ src = "https://github.com/vyfor/cord.nvim", version = vim.version.range("2.0") },
	{ src = "https://github.com/folke/which-key.nvim", version = vim.version.range("3.0") },
})
require("syringe").setup({})
require("numb").setup()
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

vim.pack.add({
	{ src = "https://github.com/chrisgrieser/nvim-various-textobjs" },
	{ src = "https://github.com/chrisgrieser/nvim-spider" },
	{ src = "https://github.com/kylechui/nvim-surround", version = vim.version.range("3.0") },
})

vim.pack.add({
    { src= "https://github.com/sphamba/smear-cursor.nvim", version = vim.version.range("0.6") }
})

-- {
-- 	"kylechui/nvim-surround",
-- 	version = "3.x",
-- 	-- NOTE By default, s is a useless synonym of cc, therefore we remap that
-- 	event = { "VeryLazy" },
-- 	dependencies = { "nvim-treesitter/nvim-treesitter" },
-- 	config = function()
-- 		require("nvim-surround").setup({
-- 			keymaps = {
-- 				-- insert = false,
-- 				-- insert_line = false,
-- 				-- normal = false,
-- 				-- normal_cur = false,
-- 				-- normal_line = false,
-- 				-- normal_cur_line = false,
-- 				-- visual = false,
-- 				-- visual_line = false,
-- 				-- delete = false,
-- 				-- change = false,
-- 				-- change_line = false,
-- 				insert = "<C-g>s",
-- 				insert_line = "<C-g>S",
-- 				normal = "s",
-- 				normal_cur = "ss",
-- 				normal_line = "S",
-- 				normal_cur_line = "SS",
-- 				visual = "s",
-- 				visual_line = "gS",
-- 				delete = "ds",
-- 				change = "cs",
-- 				change_line = "cS",
-- 			},
-- 			aliases = {},
-- 		})
-- 	end,
-- },
-- {
-- 	"chrisgrieser/nvim-spider",
-- 	keys = {
-- 		{
-- 			"w",
-- 			function()
-- 				require("spider").motion("w")
-- 			end,
-- 			mode = { "n", "o", "x" },
-- 			silent = true,
-- 			noremap = true,
-- 			desc = "Jump forward to word",
-- 		},
-- 		{
-- 			"e",
-- 			function()
-- 				require("spider").motion("e")
-- 			end,
-- 			mode = { "n", "o", "x" },
-- 			silent = true,
-- 			noremap = true,
-- 			desc = "Jump forward to end of word",
-- 		},
-- 		{
-- 			"ge",
-- 			function()
-- 				require("spider").motion("ge")
-- 			end,
-- 			mode = { "n", "o", "x" },
-- 			silent = true,
-- 			noremap = true,
-- 			desc = "Jump backward to previous end of word",
-- 		},
-- 		{
-- 			"b",
-- 			function()
-- 				require("spider").motion("b")
-- 			end,
-- 			mode = { "n", "o", "x" },
-- 			silent = true,
-- 			noremap = true,
-- 			desc = "Jump backward to word",
-- 		},
-- 	},
-- },
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

-- local wk = require("which-key")
--
-- wk.setup({
-- 	preset = "helix",
-- 	plugins = {
-- 		marks = true,
-- 		registers = true,
-- 		spelling = {
-- 			enabled = false,
-- 			suggestions = 20,
-- 		},
-- 		presets = {
-- 			operators = true,
-- 			motions = true,
-- 			text_objects = true,
-- 			windows = true,
-- 			nav = true,
-- 			z = true,
-- 			g = true,
-- 		},
-- 	},
-- 	keys = {
-- 		scroll_down = "<c-n>",
-- 		scroll_up = "<c-p>",
-- 	},
-- })
--
-- vim.keymap.set({ "n" }, "<leader>b?", function()
--     wk.show({ global = false, loop = true })
-- end, { noremap = true, silent = true, desc = "Show local keymaps" })
--
-- vim.keymap.set({ "n" }, "<leader>b?", function()
--     wk.show({ global = true, loop = true })
-- end, { noremap = true, silent = true, desc = "Show global keymaps" })
--
vim.pack.add({
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})
-- Treesitter related
vim.pack.add({
	{ src = "https://github.com/folke/ts-comments.nvim" },
})

require("lazy").setup({
	performance = {
		reset_packpath = false,
		rtp = {
			reset = false,
		},
	},
	rocks = {
		hererocks = false,
	},
	spec = {
		{ import = "plugins.misc" },
		{ import = "plugins.neotest" },
		{ import = "plugins.git" },
		{ import = "plugins.splits-management" },
		{ import = "plugins.neovim-as-platform" },
		{ import = "plugins.lualine" },
		{ import = "plugins.dap" },
		{ import = "plugins.session-manager" },
		{ import = "plugins.blink" },
		{ import = "plugins.icons" },
		-- { import = "plugins.hydra" },
		{ import = "plugins.codecompanion" },
		{ import = "plugins.operators" },
		{ import = "plugins.nvim-lspconfig" },
		{ import = "plugins.flash" },
		{ import = "plugins.oil" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.snacks" },
		{ import = "plugins.conform" },
		-- {
		-- 	"stevearc/quicker.nvim",
		-- 	-- don't lazy load it, otherwise when triggering qf with pickers from snacks.nvim would not be editable
		-- 	lazy = false,
		--           enabled = true,
		-- 	ft = { "qf" },
		-- 	keys = {
		-- 		{
		-- 			"<leader>q",
		-- 			function()
		-- 				require("quicker").toggle()
		-- 			end,
		-- 			mode = { "n" },
		-- 			silent = true,
		-- 			noremap = true,
		-- 			desc = "Open quickfix list",
		-- 		},
		-- 	},
		-- 	config = function()
		-- 		require("quicker").setup({
		-- 			keys = {},
		-- 			borders = {
		-- 				vert = "│",
		-- 			},
		-- 			opts = {
		-- 				buflisted = false,
		-- 				number = false,
		-- 				relativenumber = false,
		-- 				signcolumn = "no",
		-- 				winfixheight = true,
		-- 				wrap = false,
		-- 			},
		-- 			follow = {
		-- 				enabled = false,
		-- 			},
		-- 		})
		-- 	end,
		-- },
	},
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local cwd = vim.fn.getcwd()
		local godot_dir = cwd .. "/.godot"

		if vim.fn.isdirectory(godot_dir) == 1 then
			godot.listen_godot_external_editor_pipe()
		end
	end,
	desc = "Connect to godot external editor pipe",
})

-- TODO Do not push diagnostic to quickfix for now. We need to figure out how to push these diagnostic to another quickfix list, without disrupting the current one
-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
-- 	callback = function()
-- 		local qflist_id = 1
-- 		local diagnostics = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.WARN })
-- 		local items = vim.diagnostic.toqflist(diagnostics)
-- 		vim.fn.setqflist({}, "r", { id = qflist_id, title = "Diagnostics", items = items })
-- 	end,
-- })
vim.pack.update(vim.pack.get())

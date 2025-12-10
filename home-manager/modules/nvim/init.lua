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

require("plugins.lualine")
require("plugins.theme")
require("plugins.session-manager")
require("plugins.file-manager")
require("plugins.highlight")
require("plugins.lsp")
require("plugins.completion")
require("plugins.diff")
require("plugins.snacks")

vim.api.nvim_create_autocmd("CursorHold", {
  once = true,
  callback = function()
    require("plugins.editing-support")
    require("plugins.extra")
    require("plugins.conform")
    require("plugins.test")
  end,
})

-- vim.pack.add({
	-- { src = "https://github.com/mistricky/codesnap.nvim", version = vim.version.range("2.0") },
-- })
-- require("codesnap").setup({
-- 	show_line_number = true,
-- })

-- require("lazy").setup({
-- 	performance = {
-- 		reset_packpath = false,
-- 		rtp = {
-- 			reset = false,
-- 		},
-- 	},
-- 	rocks = {
-- 		hererocks = false,
-- 	},
-- 	spec = {
-- 		-- { import = "plugins.neovim-as-platform" },
-- 		-- { import = "plugins.dap" },
-- 		-- { import = "plugins.snacks" },
-- 		-- { import = "plugins.codecompanion" },
-- 		-- { import = "plugins.operators" },
-- 		-- {
-- 		-- 	"stevearc/quicker.nvim",
-- 		-- 	-- don't lazy load it, otherwise when triggering qf with pickers from snacks.nvim would not be editable
-- 		-- 	lazy = false,
-- 		--           enabled = true,
-- 		-- 	ft = { "qf" },
-- 		-- 	keys = {
-- 		-- 		{
-- 		-- 			"<leader>q",
-- 		-- 			function()
-- 		-- 				require("quicker").toggle()
-- 		-- 			end,
-- 		-- 			mode = { "n" },
-- 		-- 			silent = true,
-- 		-- 			noremap = true,
-- 		-- 			desc = "Open quickfix list",
-- 		-- 		},
-- 		-- 	},
-- 		-- 	config = function()
-- 		-- 		require("quicker").setup({
-- 		-- 			keys = {},
-- 		-- 			borders = {
-- 		-- 				vert = "│",
-- 		-- 			},
-- 		-- 			opts = {
-- 		-- 				buflisted = false,
-- 		-- 				number = false,
-- 		-- 				relativenumber = false,
-- 		-- 				signcolumn = "no",
-- 		-- 				winfixheight = true,
-- 		-- 				wrap = false,
-- 		-- 			},
-- 		-- 			follow = {
-- 		-- 				enabled = false,
-- 		-- 			},
-- 		-- 		})
-- 		-- 	end,
-- 		-- },
-- 	},
-- })

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


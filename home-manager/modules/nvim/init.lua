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

require("lazy").setup({
	rocks = {
		hererocks = false,
	},
	spec = {

		{
			"chentoast/marks.nvim",
			enabled = false,
			event = { "VeryLazy" },
			commit = "bb25ae3f65f504379e3d08c8a02560b76eaf91e8",
			keys = {
				{
					"m",
					function()
						require("marks").set()
					end,
					silent = true,
					noremap = true,
					desc = "Set mark",
				},
				{
					"m,",
					function()
						require("marks").set_next()
					end,
					silent = true,
					noremap = true,
					desc = "Set next available mark",
				},
				{
					"dm",
					function()
						require("marks").delete()
					end,
					silent = true,
					noremap = true,
					desc = "Delete mark",
				},
			},
			opts = {
				default_mappings = false,
				builtin_marks = {
					"[",
					"]",
					-- beginning of last insert
					"^",
				},
				excluded_filetypes = { "fzf" },
				excluded_buftypes = { "nofile" },
			},
		},

		{ import = "plugins.misc" },
		{ import = "plugins.neotest" },
		{ import = "plugins.icons" },
		{ import = "plugins.git" },
		{ import = "plugins.splits-management" },
		{ import = "plugins.screenkey" },
		{ import = "plugins.neovim-as-platform" },
		{ import = "plugins.lualine" },
		{ import = "plugins.grapple" },
		{ import = "plugins.dap" },
		{ import = "plugins.session-manager" },
		{ import = "plugins.highlight" },
		{ import = "plugins.smear-cursor" },
		{ import = "plugins.colorpicker" },
		{ import = "plugins.cord" },
		{ import = "plugins.blink" },
		{ import = "plugins.hydra" },
		{ import = "plugins.range" },
		{ import = "plugins.codecompanion" },
		{ import = "plugins.operators" },
		{ import = "plugins.themes" },
		{ import = "plugins.nvim-lspconfig" },
		{ import = "plugins.flash" },
		{ import = "plugins.oil" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.snacks" },
		{ import = "plugins.which-key" },
		{ import = "plugins.conform" },
		{
			"stevearc/quicker.nvim",
			-- don't lazy load it, otherwise when triggering qf with pickers from snacks.nvim would not be editable
			lazy = false,
			ft = { "qf" },
			keys = {
				{
					"<leader>k",
					function()
						require("quicker").toggle()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open quickfix list",
				},
			},
			config = function()
				require("quicker").setup({
					keys = {},
					borders = {
						vert = "│",
					},
					opts = {
						buflisted = false,
						number = false,
						relativenumber = false,
						signcolumn = "no",
						winfixheight = true,
						wrap = false,
					},
					follow = {
						enabled = false,
					},
				})
			end,
		},
		{
			"m00qek/baleia.nvim",
			version = "*",
			cmd = { "BaleiaColorize", "BaleiaLogs" },
			config = function()
				vim.g.baleia = require("baleia").setup({})

				vim.api.nvim_create_user_command("BaleiaColorize", function()
					local bufId = tonumber(vim.api.nvim_get_current_buf())
					if bufId == nil then
						vim.notify("Unable to find current buffer handle", vim.log.levels.ERROR)
						return
					end
					---@diagnostic disable-next-line: param-type-mismatch
					vim.g.baleia.once(bufId)
				end, { bang = true })

				vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
			end,
		},
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

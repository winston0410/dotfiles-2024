require("custom.essential")

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
			"rose-pine/neovim",
			name = "rose-pine",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"rose-pine.lua",
					"rose-pine-dawn.lua",
				})
				vim.cmd.colorscheme("rose-pine-moon")
			end,
		},
		{ import = "plugins.cord" },
		{ import = "plugins.lualine" },
		{ import = "plugins.operators" },
		{ import = "plugins.flash" },
		{ import = "plugins.oil" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.snacks" },
		{ import = "plugins.which-key" },
		{ import = "plugins.highlight" },
		{ import = "plugins.nvim-lspconfig" },
	},
})

return {
	-- Where to check themes
	-- https://vimcolorschemes.com/i/trending/b.dark
	-- https://github.com/mcchrish/vim-no-color-collections
	-- Too high constrast, but seems to have a good design theory
	{
		"nuvic/flexoki-nvim",
		lazy = true,
		init = function()
			vim.opt.wildignore:append({
				"flexoki.lua",
				-- don't look good in dark theme
				"flexoki-moon.lua",
			})
		end,
	},
	{ "miikanissi/modus-themes.nvim", lazy = true, enabled = false },
	-- comment is too dark when using lackluster
	{
		"slugbyte/lackluster.nvim",
		enabled = false,
		lazy = true,
	},
	{
		"AlexvZyl/nordic.nvim",
		lazy = true,
	},
	{
		"thesimonho/kanagawa-paper.nvim",
		lazy = true,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 99,
		requires = { "nvim-tree/nvim-web-devicons" },
		init = function()
			vim.g.tokyonight_style = "moon"
			vim.cmd.colorscheme("tokyonight")
			vim.opt.wildignore:append({
				"tokyonight.lua",
				"tokyonight-night.lua",
				"tokyonight-day.lua",
			})
		end,
		opts = {},
	},
	{
		"wnkz/monoglow.nvim",
		init = function()
			vim.opt.wildignore:append({
				"monoglow.lua",
				"monoglow-void.lua",
				"monoglow-lack.lua",
			})
		end,
		config = function()
			require("monoglow").setup({
				on_colors = function() end,
				on_highlights = function() end,
			})
		end,
		lazy = true,
	},
	{
		"alexxGmZ/e-ink.nvim",
		lazy = true,
		init = function()
			vim.opt.background = "dark"
		end,
		config = function()
			-- NOTE somehow defining in init does not work, defining again
			vim.opt.background = "dark"
			require("e-ink").setup()
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		init = function()
			vim.opt.wildignore:append({
				"rose-pine.lua",
				"rose-pine-dawn.lua",
			})
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		lazy = true,
		init = function()
			vim.opt.wildignore:append({
				"github_dark.vim",
				"github_dark_default.vim",
				"github_dark_tritanopia.vim",
				"github_dark_high_contrast.vim",
				"github_dark_dimmed.vim",
				"github_light.vim",
				"github_light_default.vim",
				"github_light_tritanopia.vim",
				"github_light_colorblind.vim",
				"github_light_high_contrast.vim",
			})
		end,
	},
	{
		"EdenEast/nightfox.nvim",
		lazy = true,
		init = function()
			vim.opt.wildignore:append({
				"dawnfox.vim",
				"dayfox.vim",
				"nightfox.vim",
			})
		end,
	},
}

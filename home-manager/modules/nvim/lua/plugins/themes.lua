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

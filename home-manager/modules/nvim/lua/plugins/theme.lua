vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/onsails/lspkind.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/e-ink-colorscheme/e-ink.nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
	{ src = "https://github.com/thesimonho/kanagawa-paper.nvim" },
	{ src = "https://github.com/kyza0d/xeno.nvim" },
	{ src = "https://github.com/AlexvZyl/nordic.nvim" },
	{ src = "https://github.com/jnz/studio98" },
	{ src = "https://github.com/nuvic/flexoki-nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme", version = vim.version.range("1.x") },
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
vim.opt.wildignore:append({
	"flexoki.lua",
	-- don't look good in dark theme
	"flexoki-moon.lua",
})
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

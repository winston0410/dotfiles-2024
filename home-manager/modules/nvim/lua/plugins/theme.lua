vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.icons" },
	{ src = "https://github.com/onsails/lspkind.nvim" },
    -- low contrast themes
    { src = "https://github.com/catppuccin/nvim" },
    -- cannot see the comment clearly with this theme
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    -- High contrast themes
    { src = "https://github.com/nuvic/flexoki-nvim" }, -- it has limited plugin support
	{ src = "https://github.com/miikanissi/modus-themes.nvim" },
	{ src = "https://github.com/kyza0d/xeno.nvim" },
    -- for fun
	{ src = "https://github.com/jnz/studio98" },
	{ src = "https://github.com/e-ink-colorscheme/e-ink.nvim" },
	{ src = "https://github.com/Mofiqul/vscode.nvim" },
	-- { src = "https://github.com/projekt0n/github-nvim-theme", version = vim.version.range("1.x") },
})
require('mini.icons').setup()
require('mini.icons').mock_nvim_web_devicons()

require('vscode').setup({
    style = "dark"
})
vim.opt.wildignore:append({
	"tokyonight.lua",
	"tokyonight-night.lua",
	"tokyonight-storm.lua",
	-- "tokyonight-moon.lua",
	"tokyonight-day.lua",
})
vim.opt.wildignore:append({
	"rose-pine.lua",
	"rose-pine-main.lua",
	"rose-pine-dawn.lua",
})
vim.opt.wildignore:append({
	"flexoki.lua", 
	"modus.lua",
    -- this light theme doesn't look good. The contrast is not good enough
    "modus_operandi.lua",
})
vim.opt.wildignore:append({
    "kanagawa.vim",
    "kanagawa-lotus.vim",
    "kanagawa-wave.vim",
    "kanagawa-dragon.vim",
})
vim.opt.wildignore:append({
	"catppuccin.vim",
	"catppuccin-frappe.vim",
	"catppuccin-macchiato.vim",
})
-- vim.opt.wildignore:append({
-- 	"github_dark.vim",
-- 	"github_dark_default.vim",
-- 	"github_dark_tritanopia.vim",
-- 	"github_dark_high_contrast.vim",
-- 	"github_dark_dimmed.vim",
-- 	"github_light.vim",
-- 	"github_light_default.vim",
-- 	"github_light_tritanopia.vim",
-- 	"github_light_colorblind.vim",
-- 	"github_light_high_contrast.vim",
-- })
local xeno = require("xeno")
xeno.config({
	transparent = true,
	contrast = 0.1,
})

xeno.new_theme("xeno-golden-hour", {
	base = "#11100f",
	accent = "#FFCC33",
	contrast = 0.2,
})
require("modus-themes").setup({
	line_nr_column_background = true, 
	sign_column_background = true, 
})
vim.cmd.colorscheme("rose-pine-moon")

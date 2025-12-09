vim.pack.add({
	{ src = "https://github.com/mcauley-penney/visual-whitespace.nvim", version = "main" },
})

local function setup()
	local comment_hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
	local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
	require("visual-whitespace").setup({
		highlight = { fg = comment_hl.fg, bg = visual_hl.bg },
	})
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function(event)
		setup()
	end,
})

setup()

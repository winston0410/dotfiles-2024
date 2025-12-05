if vim.g.enable_session == nil then
	vim.g.enable_session = true
end

return {
	{
		"folke/persistence.nvim",
		version = "3.x",
		priority = 1000,
        lazy = false,
		init = function()
			-- https://github.com/folke/persistence.nvim/issues/13
			vim.api.nvim_create_autocmd("VimEnter", {
				group = vim.api.nvim_create_augroup("Persistence", { clear = true }),
				callback = function()
					if vim.fn.argc() == 0 and vim.g.enable_session then
						require("persistence").load()
					end
				end,
				nested = true,
			})
		end,
		config = function()
			require("persistence").setup({})
		end,
	},
}

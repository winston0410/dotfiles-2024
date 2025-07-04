if vim.g.enable_session == nil then
	vim.g.enable_session = true
end

return {
	{
		"Shatur/neovim-session-manager",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		priority = 89,
		enabled = vim.g.enable_session,
		config = function()
			local config = require("session_manager.config")
			require("session_manager").setup({
				autoload_mode = {
					config.AutoloadMode.GitSession,
					config.AutoloadMode.CurrentDir,
					config.AutoloadMode.Disabled,
				},
				autosave_last_session = true,
				autosave_ignore_not_normal = true,
				autosave_ignore_filetypes = {
					"gitcommit",
					"gitrebase",
				},
			})
		end,
	},
}

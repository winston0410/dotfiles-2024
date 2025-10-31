if vim.g.enable_session == nil then
	vim.g.enable_session = true
end

return {
	-- Does not handle dropbar restore at the moment
	-- {
	-- 	"stevearc/resession.nvim",
	-- 	lazy = false,
	-- 	priority = 89,
	-- 	enabled = vim.g.enable_session,
	-- 	config = function()
	-- 		local resession = require("resession")
	-- 		require("resession").setup({
	-- 			autosave = {
	-- 				enabled = true,
	-- 				interval = 60,
	-- 				notify = false,
	-- 			},
	-- 			options = {
	-- 				"binary",
	-- 				"bufhidden",
	-- 				"buflisted",
	-- 				"cmdheight",
	-- 				"diff",
	-- 				"filetype",
	-- 				"modifiable",
	-- 				"previewwindow",
	-- 				"readonly",
	-- 				"scrollbind",
	-- 				"winfixheight",
	-- 				"winfixwidth",
	-- 			},
	-- 			dir = "resession",
	-- 			load_detail = true,
	-- 			load_order = "modification_time",
	-- 			extensions = {
	-- 				quickfix = {},
	-- 				overseer = {
	-- 					unique = true,
	-- 				},
	-- 				oil = {},
	-- 			},
	-- 		})
	--
	-- 		local function get_session_name()
	-- 			local name = vim.fn.getcwd()
	-- 			local branch = vim.trim(vim.fn.system("git branch --show-current"))
	-- 			if vim.v.shell_error == 0 then
	-- 				return name .. branch
	-- 			else
	-- 				return name
	-- 			end
	-- 		end
	-- 		vim.api.nvim_create_autocmd("VimEnter", {
	-- 			callback = function()
	-- 				if vim.fn.argc(-1) == 0 then
	-- 					resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
	-- 				end
	-- 			end,
	-- 		})
	-- 		vim.api.nvim_create_autocmd("VimLeavePre", {
	-- 			callback = function()
	-- 				resession.save(get_session_name(), { dir = "dirsession", notify = false })
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	-- Does not support restore session with git branch
	-- {
	-- 	"Shatur/neovim-session-manager",
	-- 	dependencies = { "nvim-lua/plenary.nvim" },
	-- 	lazy = false,
	-- 	priority = 89,
	-- 	enabled = vim.g.enable_session,
	-- 	config = function()
	-- 		local config = require("session_manager.config")
	-- 		require("session_manager").setup({
	-- 			autoload_mode = {
	-- 				config.AutoloadMode.GitSession,
	-- 				config.AutoloadMode.CurrentDir,
	-- 				config.AutoloadMode.Disabled,
	-- 			},
	-- 			autosave_last_session = true,
	-- 			autosave_ignore_not_normal = true,
	-- 			autosave_ignore_filetypes = {
	-- 				"gitcommit",
	-- 				"gitrebase",
	-- 			},
	-- 		})
	-- 	end,
	-- },
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

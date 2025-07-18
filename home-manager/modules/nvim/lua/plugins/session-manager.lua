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
	-- 	init = function()
	-- 		-- FIXME do not set folds here as it cannot reload the session correctly
	-- 		-- https://github.com/neovim/neovim/issues/28692
	-- 		vim.o.sessionoptions = "buffers,curdir,help,resize,tabpages,winsize,winpos,terminal"
	-- 	end,
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

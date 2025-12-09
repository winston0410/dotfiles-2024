return {
	-- https://github.com/benlubas/molten-nvim/issues/324
	-- {
	-- 	"benlubas/molten-nvim",
	-- 	version = "<2.0.0",
	-- 	event = { "VeryLazy" },
	-- 	-- TODO not sure why but there is an error message in lazy.nvim after adding the build command, but it can be installed successfully
	-- 	-- REF on installing kernel for different envs https://docs.astral.sh/uv/guides/integration/jupyter/#creating-a-kernel
	-- 	build = ":UpdateRemotePlugins",
	-- 	init = function()
	-- 		vim.g.molten_image_provider = "snacks.nvim"
	--
	-- 		local runtime_path
	--
	-- 		local uname = vim.loop.os_uname()
	-- 		if uname.sysname == "Darwin" then
	-- 			runtime_path = vim.fn.expand("~") .. "/Library/Jupyter/runtime"
	-- 		elseif uname.sysname == "Linux" then
	-- 			-- TODO handle the path later
	-- 		end
	-- 		-- REF https://github.com/benlubas/molten-nvim/issues/264
	-- 		vim.fn.mkdir(runtime_path, "p")
	-- 	end,
	-- },
	{
		"stevearc/overseer.nvim",
		cmd = {
			"OverseerOpen",
			"OverseerClose",
			"OverseerToggle",
			"OverseerSaveBundle",
			"OverseerLoadBundle",
			"OverseerDeleteBundle",
			"OverseerRunCmd",
			"OverseerRun",
			"OverseerInfo",
			"OverseerBuild",
			"OverseerQuickAction",
			"OverseerTaskAction",
			"OverseerClearCache",
		},
		keys = {
			{
				"<leader>e",
				function()
					require("overseer").toggle()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Toggle Overseer",
			},
			{
				"<leader>p<leader>e",
				function()
					vim.cmd("OverseerRun")
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Pick task to run",
			},
		},
		version = "1.x",
		config = function()
			-- https://github.com/stevearc/overseer.nvim/discussions/373
			local overseer = require("overseer")
			overseer.setup({
				bundles = {
					autostart_on_load = false,
				},
			})

			-- local function get_cwd_as_name()
			-- 	local dir = vim.fn.getcwd(0)
			-- 	return dir:gsub("[^A-Za-z0-9]", "_")
			-- end
			--
			-- vim.api.nvim_create_autocmd("User", {
			-- 	desc = "Save overseer.nvim tasks on persistence.nvim session save",
			-- 	pattern = "PersistenceSavePre",
			-- 	callback = function()
			-- 		overseer.save_task_bundle(get_cwd_as_name(), nil, { on_conflict = "overwrite" })
			-- 	end,
			-- })
			--
			-- vim.api.nvim_create_autocmd("User", {
			-- 	desc = "Remove all previous overseer.nvim tasks on persistence.nvim session load",
			-- 	pattern = "PersistenceLoadPre",
			-- 	callback = function()
			-- 		for _, task in ipairs(overseer.list_tasks({})) do
			-- 			task:dispose(true)
			-- 		end
			-- 	end,
			-- })
			--
			-- vim.api.nvim_create_autocmd("User", {
			-- 	desc = "Load overseer.nvim tasks on persistence.nvim session load",
			-- 	pattern = "PersistenceLoadPost",
			-- 	callback = function()
			-- 		overseer.load_task_bundle(get_cwd_as_name(), { ignore_missing = true })
			-- 	end,
			-- })
		end,
	},
}

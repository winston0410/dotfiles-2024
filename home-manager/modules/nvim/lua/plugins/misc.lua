return {
	{
		"benlubas/molten-nvim",
		version = "<2.0.0",
		-- TODO not sure why but there is an error message in lazy.nvim after adding the build command, but it can be installed successfully
		-- REF on installing kernel for different envs https://docs.astral.sh/uv/guides/integration/jupyter/#creating-a-kernel
		build = ":UpdateRemotePlugins",
		dependencies = {
			{
				"GCBallesteros/jupytext.nvim",
				config = function()
					require("jupytext").setup({
						style = "markdown",
						output_extension = "md",
						force_ft = "markdown",
					})
				end,
			},
		},
		init = function()
            vim.g.molten_image_provider = "snacks.nvim"

			local runtime_path

            local uname = vim.loop.os_uname()
            if uname.sysname == "Darwin" then
              runtime_path = vim.fn.expand("~") .. "/Library/Jupyter/runtime"
            elseif uname.sysname == "Linux" then
              -- TODO handle the path later
            end
			-- REF https://github.com/benlubas/molten-nvim/issues/264
			vim.fn.mkdir(runtime_path, "p")
		end,
	},
	{
		"ahkohd/difft.nvim",
		-- not sure why is this useful
		enabled = false,
		config = function()
			require("difft").setup()
		end,
	},
	-- FIXME it never built successfully
	{
		"jackplus-xyz/player-one.nvim",
		enabled = false,
		opts = {
			is_enabled = true,
			debug = true,
		},
	},
	{
		"mistricky/codesnap.nvim",
		build = "make",
		version = "1.x",
		cmd = { "CodeSnapHighlight", "CodeSnapSaveHighlight", "CodeSnapASCII", "CodeSnap", "CodeSnapSave" },
	},
	-- NOTE interesting plugin, but not very useful
	{
		"mawkler/hml.nvim",
		enabled = false,
		event = { "VeryLazy" },
		opts = {},
	},
	{
		"mcauley-penney/visual-whitespace.nvim",
		event = { "VeryLazy" },
		config = function()
			local comment_hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
			local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
			require("visual-whitespace").setup({
				highlight = { fg = comment_hl.fg, bg = visual_hl.bg },
			})
		end,
	},
	{
		"winston0410/sops.nvim",
		cmd = { "SopsEncrypt", "SopsDecrypt" },
		lazy = false,
		init = function()
			vim.b.sops_auto_transform = true
			vim.g.sops_auto_transform = true
		end,
		-- event = {"VeryLazy"},
		config = function()
			require("sops").setup({})
		end,
	},
	{
		"michaelb/sniprun",
		version = "1.x",
		build = false,
		cmd = { "SnipClose", "SnipInfo", "SnipReset", "SnipRun", "SnipReplMemoryClean" },
		config = function()
			require("sniprun").setup({
				binary_path = "sniprun",
			})
		end,
	},
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
		opts = {
			bundles = {
				autostart_on_load = false,
			},
		},
	},
}

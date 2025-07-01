return {
	{
		"cbochs/grapple.nvim",
		version = "0.30.x",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		config = function()
			-- TODO wait for tag_hook to be documented, and we can override it to change keymapping inside tag windows
			require("grapple").setup({
				scope = "git_branch",
			})
		end,
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
			-- {
			-- 	"<leader>mm",
			-- 	function()
			-- 		require("grapple").toggle({})
			-- 	end,
			-- 	desc = "Grapple toggle tag",
			-- },
			{
				"<leader>p<leader>m",
				function()
					require("grapple").toggle_tags({})
				end,
				silent = true,
				noremap = true,
				desc = "Grapple toggle tags window",
			},
			{
				"<leader>mo",
				function()
					require("grapple").cycle_tags("next")
				end,
				silent = true,
				noremap = true,
				desc = "Grapple cycle next tag",
			},
			{
				"<leader>mi",
				function()
					require("grapple").cycle_tags("prev")
				end,
				silent = true,
				noremap = true,
				desc = "Grapple cycle previous tag",
			},
			{
				"<leader>mv",
				function()
					vim.ui.input({ prompt = "Grapple tag name" }, function(input)
						if input == nil then
							return
						end
						require("grapple").tag({ name = input })
						vim.notify("Grapple tag created", vim.log.levels.INFO)
					end)
				end,
				silent = true,
				noremap = true,
				desc = "Grapple add tag",
			},
			{
				"<leader>mq",
				function()
					require("grapple").untag()
					vim.notify("Grapple tag removed", vim.log.levels.INFO)
				end,
				silent = true,
				noremap = true,
				desc = "Grapple delete tag",
			},
		},
	},
}

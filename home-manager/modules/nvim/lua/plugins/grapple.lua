return {
	{
		-- TODO implement position specific tag https://github.com/cbochs/grapple.nvim/issues/118
		"cbochs/grapple.nvim",
		version = "0.30.x",
        enabled = false,
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
		},
		config = function()
			-- TODO wait for tag_hook to be documented, and we can override it to change keymapping inside tag windows
			require("grapple").setup({
				default_scopes = {
					global = { hidden = true },
					lsp = { hidden = true },
					static = { hidden = true },
				},
				scope = "git_branch",
			})
		end,
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
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

						local err = require("grapple").tag({ name = input })
						if err ~= nil then
							return
						end
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
					local err = require("grapple").untag()
					if err ~= nil then
						return
					end
					vim.notify("Grapple tag removed", vim.log.levels.INFO)
				end,
				silent = true,
				noremap = true,
				desc = "Grapple delete tag",
			},
			{
				"<leader>mQ",
				function()
					local err = require("grapple").reset({ notify = true })
					if err ~= nil then
						return
					end
				end,
				silent = true,
				noremap = true,
				desc = "Grapple remove all tags in a scope",
			},
			{
				"<leader>m<leader>q",
				function()
					require("grapple").quickfix()
				end,
				silent = true,
				noremap = true,
				desc = "Grapple loads tag to quickfix",
			},
			{
				"<leader>mso",
				function()
					require("grapple").cycle_scopes("next")
				end,
				silent = true,
				noremap = true,
				desc = "Grapple cycle next scope",
			},
			{
				"<leader>msi",
				function()
					require("grapple").cycle_scopes("prev")
				end,
				silent = true,
				noremap = true,
				desc = "Grapple cycle prev scope",
			},
			-- NOTE don't see a need to create scope right now
			-- {
			-- 	"<leader>msv",
			-- 	function()
			-- 		vim.ui.input({ prompt = "Grapple scope name" }, function(input)
			-- 			if input == nil then
			-- 				return
			-- 			end
			--
			-- 			local err = require("grapple").define_scope({
			-- 				name = input,
			-- 				-- REF https://github.com/cbochs/grapple.nvim/blob/b41ddfc1c39f87f3d1799b99c2f0f1daa524c5f7/lua/grapple/settings.lua#L94
			-- 				resolver = function()
			-- 					return vim.loop.cwd(), vim.loop.cwd()
			-- 				end,
			-- 			})
			-- 			if err ~= nil then
			-- 				return
			-- 			end
			-- 			vim.notify("Grapple scope created", vim.log.levels.INFO)
			-- 		end)
			-- 	end,
			-- 	silent = true,
			-- 	noremap = true,
			-- 	desc = "Create a Grapple scope",
			-- },
			-- {
			-- 	"<leader>msd",
			-- 	function()
			-- 		-- require("grapple").delete_scope()
			-- 	end,
			-- 	silent = true,
			-- 	noremap = true,
			-- 	desc = "Delete a Grapple scope",
			-- },
		},
	},
}

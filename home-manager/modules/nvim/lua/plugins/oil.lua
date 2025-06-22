local utils = require("custom.utils")
return {
	{
		"stevearc/oil.nvim",
		version = "2.x",
		lazy = false,
		cmd = { "Oil" },
		keys = {
			{
				"<leader>o",
				function()
					utils.smart_open(function()
						vim.cmd("Oil")
					end, {
						filetype = "oil",
					})
				end,
				mode = { "n" },
				noremap = true,
				silent = true,
				desc = "Open Oil.nvim panel",
			},
		},
		config = function()
			local show_detail = false
			local default_columns = {
				"icon",
				"permissions",
			}
			local detail_columns = vim.list_extend(vim.list_slice(default_columns), { "size", "mtime" })
			require("oil").setup({
				columns = default_columns,
				constrain_cursor = "editable",
				watch_for_changes = true,
				keymaps = {
					["<CR>"] = {
						callback = function()
							local oil = require("oil")
							-- local entry = oil.get_cursor_entry()
							require("oil").select({ close = false })
						end,
						mode = "n",
						desc = "Select a file or directory",
					},
					["~"] = { "actions.cd", mode = "n", desc = "Change current directory of NeoVim" },
					["<a-m>"] = {
						callback = function()
							show_detail = not show_detail
							if show_detail then
								require("oil").set_columns(detail_columns)
							else
								require("oil").set_columns(default_columns)
							end
						end,
						mode = "n",
						desc = "Toggle file detail",
					},
					["<a-h>"] = {
						"actions.toggle_hidden",
						mode = "n",
						desc = "Toggle hidden files",
					},
					["<a-s>"] = { "actions.change_sort", mode = "n" },
					["-"] = { "actions.parent", mode = "n", desc = "Go to parent directory" },
					["gx"] = { "actions.open_external", mode = "n", desc = "Open in external application" },
				},
				use_default_keymaps = false,
				win_options = {
					wrap = true,
				},
				view_options = {
					show_hidden = true,
				},
				skip_confirm_for_simple_edits = true,
			})
			-- REF https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data.actions.type == "move" then
						Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
					end
				end,
			})
		end,
		dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
	},
}

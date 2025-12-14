vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim", version = "v2.15.0" },
})
local show_detail = false
local default_columns = {
	"icon",
}
local detail_columns = vim.list_extend(vim.list_slice(default_columns), { "size", "mtime", "permissions" })
require("oil").setup({
	columns = default_columns,
	constrain_cursor = "editable",
	watch_for_changes = true,
	keymaps = {
		["<CR>"] = {
			callback = function()
				require("oil").select({
					close = false,
					handle_buffer_callback = function(buf_id)
						local oil = require("oil")
						local entry = oil.get_cursor_entry()
						if entry == nil then
							return
						end
						if entry.type == "directory" then
							oil.select()
							return
						end

						local picked_window_id = require("window-picker").pick_window({
							filter_rules = {
								autoselect_one = true,
								include_current_win = true,
							},
						})
						if picked_window_id == nil then
							return
						end
						vim.api.nvim_win_set_buf(picked_window_id, buf_id)
						vim.api.nvim_set_current_win(picked_window_id)
					end,
				})
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
        number = false,
		signcolumn = "auto:2",
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

vim.keymap.set({ "n" }, "<leader>o", function()
	require("oil").open(nil)
end, { silent = true, noremap = true, desc = "Open Oil.nvim panel" })
-- fyler.nvim is still buggy, wait for a bit longer
-- vim.pack.add({
--     {
--         src = "https://github.com/A7Lavinraj/fyler.nvim",
--         -- version = vim.version.range("2.x")
--         version = "main"
--     },
-- })
--
-- vim.keymap.set({ "n" }, "<leader>o", function()
--     vim.cmd("Fyler")
-- end, { silent = true, noremap = true, desc = "Open Oil.nvim panel" })
--
-- require("fyler").setup({
--     close_on_select = true,
--     confirm_simple = true,
--     default_explorer = true,
--     delete_to_trash = true,
--     integrations = {
--         icon = "mini_icons",
--         winpick = { provider = "nvim-window-picker" },
--     },
--     hooks = {
--         on_rename = function(src_path, destination_path)
--             Snacks.rename.on_rename_file(src_path, destination_path)
--         end,
--     },
--     views = {
--         explorer = {},
--         mappings = {
--             ["q"] = "CloseView",
--             ["<CR>"] = "Select",
--             ["-"] = "GotoParent",
--             ["="] = "GotoCwd",
--             ["."] = "GotoNode",
--             ["zM"] = "CollapseAll",
--             ["zc"] = "CollapseNode",
--         },
--         watcher = {
--             enabled = true,
--         },
--         win = {
--             win_opts = {
--                 number = false,
--             },
--         },
--     },
-- })

return {
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = { "VeryLazy" },
		version = "2.*",
		keys = {
			{
				"<leader>p<C-w>",
				function()
					local picked_window_id = require("window-picker").pick_window()
					if picked_window_id == nil then
						return
					end
					vim.api.nvim_set_current_win(picked_window_id)
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Pick window",
			},
			{
				"<C-w>x",
                function ()
					local picked_window_id = require("window-picker").pick_window()
					if picked_window_id == nil then
						return
					end

                    local picked_buf_id = vim.api.nvim_win_get_buf(picked_window_id)

                    local cur_win_id = vim.api.nvim_get_current_win()
                    local cur_buf_id = vim.api.nvim_win_get_buf(cur_win_id)

                    vim.api.nvim_win_set_buf(picked_window_id, cur_buf_id)
                    vim.api.nvim_win_set_buf(cur_win_id, picked_buf_id)
                end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Swap window",
			},
		},
		config = function()
			require("window-picker").setup({
				show_prompt = false,
				hint = "floating-big-letter",
			})
		end,
	},
}

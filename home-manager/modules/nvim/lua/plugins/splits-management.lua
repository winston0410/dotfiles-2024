return {
	{
		"mrjones2014/smart-splits.nvim",
		version = "1.x",
		keys = {
			{
				"<leader>w>",
				function()
					require("smart-splits").resize_right()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to right",
			},
			{
				"<C-w>>",
				function()
					require("smart-splits").resize_right()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to right",
			},
			{
				"<C-w><",
				function()
					require("smart-splits").resize_left()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to left",
			},
			{
				"<leader>w<",
				function()
					require("smart-splits").resize_left()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to left",
			},
			{
				"<leader>w+",
				function()
					require("smart-splits").resize_up()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to top",
			},
			{
				"<C-w>+",
				function()
					require("smart-splits").resize_up()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to top",
			},
			{
				"<leader>w-",
				function()
					require("smart-splits").resize_down()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to bottom",
			},
			{
				"<C-w>-",
				function()
					require("smart-splits").resize_down()
				end,
				mode = "n",
				silent = true,
				desc = "Resize split to bottom",
			},
		},
		opts = {
			default_amount = 10,
		},
	},
	{
		"s1n7ax/nvim-window-picker",
		name = "window-picker",
		event = "VeryLazy",
		version = "2.*",
		keys = {
			{
				"<leader>p<leader>w",
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
				"x<leader>w",
				function()
					local to_win_id = require("window-picker").pick_window()
					if to_win_id == nil then
						return
					end

					local from_win_id = vim.api.nvim_get_current_win()
					if from_win_id == to_win_id then
						return
					end

					local from_buf = vim.api.nvim_win_get_buf(from_win_id)
					local to_buf = vim.api.nvim_win_get_buf(to_win_id)

					local original_cursor_pos = vim.api.nvim_win_get_cursor(from_win_id)

					vim.api.nvim_win_set_buf(from_win_id, to_buf)
					vim.api.nvim_win_set_buf(to_win_id, from_buf)

					local cur_buf_after_swap = vim.api.nvim_get_current_buf()
					if cur_buf_after_swap == from_buf then
						return
					end

					vim.api.nvim_win_set_cursor(to_win_id, original_cursor_pos)
					vim.api.nvim_set_current_win(to_win_id)
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Swap buffer between windows",
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

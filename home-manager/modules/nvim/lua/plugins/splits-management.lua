return {
	{
		"mrjones2014/smart-splits.nvim",
		version = "1.x",
		enabled = false,
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
				"<leader>wx",
				mode = { "n" },
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

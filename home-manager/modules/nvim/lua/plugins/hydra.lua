return {
	{
		"aaronik/treewalker.nvim",
		event = { "CursorHold" },
		enabled = true,
		opts = {
			highlight = false,
		},
	},
	{
		"nvimtools/hydra.nvim",
		version = "1.x",
		event = { "VeryLazy" },
		config = function()
			local hydra = require("hydra")

			hydra.setup({
				on_enter = function()
					vim.api.nvim_exec_autocmds("User", { pattern = "HydraModeEnter" })
				end,
				on_exit = vim.schedule_wrap(function()
					vim.cmd.redrawstatus()
					vim.api.nvim_exec_autocmds("User", { pattern = "HydraModeExit" })
				end),
			})

			hydra({
				name = "Treewalk",
				mode = { "n" },
				body = "<leader>s",
				config = {
					hint = false,
				},
				heads = {
					{
						"k",
						function()
							local count = vim.v.count1
							for _ = 1, count do
								vim.cmd("Treewalker Up")
							end
						end,
						{
							mode = { "n", "v" },
							noremap = true,
							silent = true,
							desc = "Move upward to a Treesitter node",
						},
					},
					{
						"j",
						function()
							local count = vim.v.count1
							for _ = 1, count do
								vim.cmd("Treewalker Down")
							end
						end,
						{
							mode = { "n", "v" },
							noremap = true,
							silent = true,
							desc = "Move downward to a Treesitter node",
						},
					},
					{
						"l",
						function()
							local count = vim.v.count1
							for _ = 1, count do
								vim.cmd("Treewalker Right")
							end
						end,
						{
							mode = { "n", "v" },
							noremap = true,
							silent = true,
							desc = "Move right to a Treesitter node",
						},
					},
					{
						"h",
						function()
							local count = vim.v.count1
							for _ = 1, count do
								vim.cmd("Treewalker Left")
							end
						end,
						{
							mode = { "n", "v" },
							noremap = true,
							silent = true,
							desc = "Move left to a Treesitter node",
						},
					},
				},
			})

			hydra({
				name = "Window",
				mode = { "n" },
				body = "<c-w>",
				config = {
					hint = false,
				},
				heads = {
					{
						"q",
						function()
							vim.cmd("quit")
						end,
						{
							noremap = true,
							silent = true,
							desc = "Create a horizontal split",
						},
					},
					{
						"s",
						"<c-w>s",
						{
							noremap = true,
							silent = true,
							desc = "Create a horizontal split",
						},
					},
					{
						"v",
						"<c-w>v",
						{
							noremap = true,
							silent = true,
							desc = "Create a vertical split",
						},
					},
					{
						"+",
						"10<c-w>+",
						{
							noremap = true,
							silent = true,
							desc = "Increase split height",
						},
					},
					{
						"-",
						"10<c-w>-",
						{
							noremap = true,
							silent = true,
							desc = "Decrease split height",
						},
					},
					{
						">",
						"10<c-w>>",
						{
							noremap = true,
							silent = true,
							desc = "Increase split width",
						},
					},
					{
						"=",
						"<c-w>=",
						{
							noremap = true,
							silent = true,
							desc = "Resize all splits to identical size",
						},
					},
					{
						"<",
						"10<c-w><",
						{
							noremap = true,
							silent = true,
							desc = "Decrease split width",
						},
					},
					{
						"l",
						"<c-w>l",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the right split",
						},
					},
					{
						"h",
						"<c-w>h",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the left split",
						},
					},
					{
						"k",
						"<c-w>k",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the top split",
						},
					},
					{
						"j",
						"<c-w>j",
						{
							noremap = true,
							silent = true,
							desc = "Navigate to the bottom split",
						},
					},
					{
						"L",
						"<c-w>L",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the right split",
						},
					},
					{
						"H",
						"<c-w>H",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the left split",
						},
					},
					{
						"K",
						"<c-w>K",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the top split",
						},
					},
					{
						"J",
						"<c-w>J",
						{
							noremap = true,
							silent = true,
							desc = "Swap with the bottom split",
						},
					},
					{
						"x",
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
						{
							noremap = true,
							silent = true,
							desc = "Swap buffer between windows",
						},
					},
				},
			})
		end,
	},
}

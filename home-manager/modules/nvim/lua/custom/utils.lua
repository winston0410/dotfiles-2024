local M = {}

---@class SmartOpenOpts
---@field height number | nil
---@field filetype string
---@field ignored_filetypes string[]

---@param cmd fun()
---@param opts SmartOpenOpts
function M.smart_open(cmd, opts)
	local total_lines = vim.o.lines
	local split_height = math.floor(total_lines * 0.3)
	opts = vim.tbl_deep_extend("force", {
		height = split_height,
		ignored_filetypes = { "NvimTree", "neo-tree", "notify", "snacks_notif" },
	}, opts)
	table.insert(opts.ignored_filetypes, opts.filetype)

	local cur_buf = vim.api.nvim_get_current_buf()
	local cur_buf_ft = vim.bo[cur_buf].filetype

	local next_win_id
	local placeholder_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(placeholder_buf, "bufhidden", "wipe")

	if cur_buf_ft == opts.filetype then
		next_win_id = vim.api.nvim_open_win(placeholder_buf, false, {
			split = "right",
		})
	else
		next_win_id = vim.api.nvim_open_win(placeholder_buf, false, {
			height = opts.height,
			split = "below",
		})
	end
	local picked_window_id = require("window-picker").pick_window({
		filter_rules = {
			autoselect_one = false,
			include_current_win = true,
			bo = {
				filetype = opts.ignored_filetypes,
			},
		},
	})

	if picked_window_id == nil then
		vim.api.nvim_win_close(next_win_id, false)
		return
	end
	if picked_window_id ~= next_win_id then
		vim.api.nvim_win_close(next_win_id, false)
	end
	vim.api.nvim_set_current_win(picked_window_id)
	cmd()
end

return M

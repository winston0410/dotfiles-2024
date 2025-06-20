local M = {}

---@class SmartOpenOpts
---@field height number | nil
---@field filetype string

---@param cmd fun()
---@param opts SmartOpenOpts
function M.smart_open(cmd, opts)
	local total_lines = vim.o.lines
	local split_height = math.floor(total_lines * 0.3)
	opts = vim.tbl_deep_extend("force", {
		height = split_height,
	}, opts)

	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype
	if filetype == opts.filetype then
		local win = vim.api.nvim_open_win(0, false, {
			split = "right",
			win = 0,
		})
		vim.api.nvim_set_current_win(win)
		cmd()
		return
	end

	if filetype ~= "" then
		local win = vim.api.nvim_open_win(0, false, {
			height = opts.height,
			split = "below",
			win = 0,
		})
		vim.api.nvim_set_current_win(win)
		cmd()
		return
	end
	cmd()
end

return M

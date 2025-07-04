local M = {}

---@class SmartOpenOpts
---@field ignored_filetypes? string[]

---@param cmd fun()
---@param opts SmartOpenOpts
function M.smart_open(cmd, opts)
	local picked_window_id = require("window-picker").pick_window({
		filter_rules = {
			autoselect_one = true,
			include_current_win = true,
			bo = {
				filetype = opts.ignored_filetypes,
			},
		},
	})

	if picked_window_id == nil then
		return
	end
	vim.api.nvim_set_current_win(picked_window_id)
	cmd()
end

return M

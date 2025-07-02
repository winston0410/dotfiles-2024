local M = {}

---@param target_ft string
function has_filetype_in_tab(target_ft)
	local tab_id = vim.api.nvim_get_current_tabpage()
	local wins = vim.api.nvim_tabpage_list_wins(tab_id)
	for _, win in ipairs(wins) do
		local buf_id = vim.api.nvim_win_get_buf(win)
		local ft = vim.bo[buf_id].filetype
		if ft == target_ft then
			return true
		end
	end

	return false
end

---@class SmartOpenOpts
---@field desired_height? number
---@field desired_width? number
---@field filetype string
---@field ignored_filetypes? string[]

---@param cmd fun()
---@param opts SmartOpenOpts
function M.smart_open(cmd, opts)
	---@type SmartOpenOpts
	opts = vim.tbl_deep_extend("force", {
		desired_height = math.floor(vim.o.lines * 0.3),
		desired_width = math.floor(vim.o.columns * 0.2),
		ignored_filetypes = { "NvimTree", "neo-tree", "notify", "snacks_notif" },
	}, opts)
	table.insert(opts.ignored_filetypes, opts.filetype)

	local placeholder_buf = vim.api.nvim_create_buf(false, true)
	local next_vsplit_win_id = vim.api.nvim_open_win(placeholder_buf, false, {
		split = "left",
		width = opts.desired_width,
	})
	vim.api.nvim_set_option_value("winfixwidth", true, { win = next_vsplit_win_id, scope = "local" })
	vim.api.nvim_set_option_value("winfixheight", true, { win = next_vsplit_win_id, scope = "local" })

	local next_split_win_id = vim.api.nvim_open_win(placeholder_buf, false, {
		height = opts.desired_height,
		split = "below",
	})
	vim.api.nvim_set_option_value("winfixwidth", true, { win = next_split_win_id, scope = "local" })
	vim.api.nvim_set_option_value("winfixheight", true, { win = next_split_win_id, scope = "local" })

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
		vim.api.nvim_win_close(next_split_win_id, false)
		vim.api.nvim_win_close(next_vsplit_win_id, false)
		return
	end
	if picked_window_id ~= next_split_win_id then
		vim.api.nvim_win_close(next_split_win_id, false)
	end
	if picked_window_id ~= next_vsplit_win_id then
		vim.api.nvim_win_close(next_vsplit_win_id, false)
	end
	vim.api.nvim_set_current_win(picked_window_id)
	cmd()
end

return M

local M = {}

local function collect_windows(layout)
	local result = {}
	local layout_type = layout[1]

	if layout_type == "leaf" then
		table.insert(result, layout[2])
	elseif layout_type == "row" or layout_type == "col" then
		for i = 2, #layout do
			local sub_result = collect_windows(layout[i])
			for _, win in ipairs(sub_result) do
				table.insert(result, win)
			end
		end
	end

	return result
end

---@class LayoutRuleOpts
---@field width integer
---@field height integer
---@field allowed? { ft?: string[]}

---@class LayoutRuleWithDefaultOpts
---@field width integer
---@field height integer
---@field allowed { ft: string[]}

---@param layout LayoutRuleOpts[]
function M.open_layout(layout)
	local tab_id = vim.api.nvim_get_current_tabpage()
	local win_layout = vim.fn.winlayout(tab_id)
	vim.print("debug layout", win_layout)
	local win_ids = collect_windows(win_layout)
	vim.print("extracted layout", win_ids)

	-- local non_floating_win_ids = vim.iter(win_ids)
	-- 	:filter(function(win_id)
	-- 		local cur_buf_id = vim.api.nvim_win_get_buf(win_id)
	-- 		local buf_name = vim.api.nvim_buf_get_name(cur_buf_id)
	-- 		vim.print("buffer name", buf_name)
	-- 		local win_config = vim.api.nvim_win_get_config(win_id)
	-- 		-- only include non floating windows
	-- 		return win_config.relative == ""
	-- 	end)
	-- 	:totable()

	-- ---@type LayoutRuleWithDefaultOpts[]
	-- local rules = vim.iter(layout)
	-- 	:map(function(rule)
	-- 		return vim.tbl_deep_extend("force", { allowed = {} }, rule)
	-- 	end)
	-- 	:totable()
	--
	-- local created_win_ids = {}
	--
	-- for idx, rule in ipairs(rules) do
	-- 	local computed_width = math.floor(vim.o.columns * rule.width)
	-- 	local computed_height = math.floor(vim.o.lines * rule.height)
	--
	-- 	local cur_win_id = non_floating_win_ids[idx]
	-- 	---@type integer
	-- 	local cur_buf_id
	--
	-- 	if cur_win_id ~= nil then
	-- 		cur_buf_id = vim.api.nvim_win_get_buf(cur_win_id)
	-- 		local buf_name = vim.api.nvim_buf_get_name(cur_buf_id)
	-- 		vim.print("buffer name", buf_name)
	-- 	else
	-- 		cur_buf_id = vim.api.nvim_create_buf(false, true)
	-- 	end
	--
	-- 	-- if #rule.allowed > 0 then
	-- 	-- 	---@type integer | nil
	-- 	-- 	local matched_win_id = vim.iter(win_ids):find(function(win_id)
	-- 	-- 		local buf_id = vim.api.nvim_win_get_buf(win_id)
	-- 	-- 		local ft = vim.bo[buf_id].filetype
	-- 	-- 		local is_allowed_ft = vim.list_contains(rule.allowed, ft)
	-- 	--
	-- 	-- 		return is_allowed_ft
	-- 	-- 	end)
	-- 	--
	-- 	-- 	if matched_win_id ~= nil then
	-- 	-- 	else
	--
	-- 	local created_win_id = vim.api.nvim_open_win(cur_buf_id, true, {
	-- 		win = -1,
	-- 		split = "left",
	-- 		width = computed_width,
	-- 		height = computed_height,
	-- 	})
	--
	-- 	table.insert(created_win_ids, created_win_id)
	-- end
	--
	-- for _, win_id in ipairs(non_floating_win_ids) do
	-- 	vim.api.nvim_win_close(win_id, false)
	-- end
end

return M

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
	local win_ids = vim.api.nvim_tabpage_list_wins(tab_id)
	local non_floating_win_ids = vim.iter(win_ids)
		:filter(function(win_id)
			local win_config = vim.api.nvim_win_get_config(win_id)
			-- vim.print(vim.inspect(win_config))
			-- only include non floating windows
			return win_config.relative == ""
		end)
		:totable()

	-- table.sort(win_ids, function(a, b)
	-- 	local pos_a = vim.api.nvim_win_get_position(a)
	-- 	local pos_b = vim.api.nvim_win_get_position(b)
	-- 	return pos_a[2] < pos_b[2]
	-- end)

	---@type LayoutRuleWithDefaultOpts[]
	local rules = vim.iter(layout)
		:map(function(rule)
			return vim.tbl_deep_extend("force", { allowed = {} }, rule)
		end)
		:totable()

	local created_win_ids = {}

	for idx, rule in ipairs(rules) do
		local computed_width = math.floor(vim.o.columns * rule.width)
		local computed_height = math.floor(vim.o.lines * rule.height)

		-- if #rule.allowed > 0 then
		-- 	---@type integer | nil
		-- 	local matched_win_id = vim.iter(win_ids):find(function(win_id)
		-- 		local buf_id = vim.api.nvim_win_get_buf(win_id)
		-- 		local ft = vim.bo[buf_id].filetype
		-- 		local is_allowed_ft = vim.list_contains(rule.allowed, ft)
		--
		-- 		return is_allowed_ft
		-- 	end)
		--
		-- 	if matched_win_id ~= nil then
		-- 	else

		local scratch_buf_id = vim.api.nvim_create_buf(false, true)
		local created_win_id = vim.api.nvim_open_win(scratch_buf_id, true, {
			win = -1,
			split = "left",
			width = computed_width,
			height = computed_height,
		})

		table.insert(created_win_ids, created_win_id)
	end

	for _, win_id in ipairs(non_floating_win_ids) do
		vim.api.nvim_win_close(win_id, false)
	end
end

return M

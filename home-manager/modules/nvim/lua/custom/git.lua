local M = {}

---@class BlameResult
---@field hash string The shortened commit hash (8 characters)
---@field author string The commit author name
---@field date string The formatted commit date (YYYY MMM DD format)
---@field summary string The commit message summary

---Shows git blame information for the current line as virtual text
---@return BlameResult|nil blame_info Returns blame information table or nil if file is not tracked by git or no blame info available
function M.blame_line()
	local buf_id = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(buf_id)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local pos = vim.pos(cursor_pos[1], cursor_pos[2])
	local row = cursor_pos[1]
	local blame_info = vim.fn.systemlist("git blame -L " .. row .. ",+1 " .. filename .. " --porcelain")
	if blame_info[2] == nil then
		return
	end

	local hash = string.sub(blame_info[1], 1, 8)
	local author_name = string.sub(blame_info[2], 8)
	local author_date = os.date("%Y %b %d", tonumber(string.sub(blame_info[4], 12)))
	local summary = string.sub(blame_info[10], 9)

    return {
        hash = hash,
        author = author_name,
        date = author_date,
        summary = summary
    }
end

return M

local M = {}

---@class BlameResult
---@field hash string The shortened commit hash (8 characters)
---@field author string The commit author name
---@field date string The formatted commit date (YYYY MMM DD format)
---@field summary string The commit message summary

---Shows git blame information for the current line as virtual text
---@param row number The line number to get blame information for
---@return BlameResult|nil blame_info Returns blame information table or nil if file is not tracked by git or no blame info available
function M.blame_line(row)
	local buf_id = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(buf_id)
	local blame_info = vim.fn.systemlist("git blame -L " .. row .. ",+1 " .. filename .. " --porcelain")
	if blame_info[2] == nil then
		return
	end

	local hash = string.sub(blame_info[1], 1, 7)
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

local function read_head_and_branch(git_dir, head_file)
	if vim.fn.filereadable(git_dir .. "/" .. head_file) ~= 1 then
		return nil, nil
	end
	
	local content = vim.fn.readfile(git_dir .. "/" .. head_file)[1]
	if not content then
		return nil, nil
	end
	
	-- Shorten the SHA to 8 characters
	content = string.sub(content, 1, 7)
	
	local branch_result = vim.fn.systemlist("git branch --contains " .. content .. " 2>/dev/null")
	if vim.v.shell_error ~= 0 or not branch_result[1] then
		return content, nil
	end
	
	-- Remove the "* " or "  " prefix and get the first branch
	local branch = string.gsub(branch_result[1], "^[* ] ", "")
	return content, branch
end

---@class GitMergeMetadata
---@field action "merge"|"cherry-pick"|"revert"|"rebase"
---@field sha? string The SHA of the selected side (local or remote)
---@field branch? string The name of the selected branch (local or remote)

---Gets git merge/rebase metadata for the current repository
---@param side ":2"|":3" The side to show - :2 for LOCAL, :3 for REMOTE
---@return GitMergeMetadata metadata Returns a table with the current git action and selected side info
function M.get_merge_metadata(side)
	assert(side == ":2" or side == ":3", "side must be either ':2' or ':3'")
	
	local git_dir = vim.fn.systemlist("git rev-parse --git-dir 2>/dev/null")[1]
	if vim.v.shell_error ~= 0 or not git_dir then
		error("not a git repository")
	end

	-- Read ORIG_HEAD content and branch
	local orig_head_content, orig_head_branch = read_head_and_branch(git_dir, "ORIG_HEAD")

	-- Check for merge state
	if vim.fn.filereadable(git_dir .. "/MERGE_HEAD") == 1 then
		-- Read MERGE_HEAD content and branch
		local merge_head_content, merge_head_branch = read_head_and_branch(git_dir, "MERGE_HEAD")
		
		if side == ":2" then
			return { 
				action = "merge",
				sha = orig_head_content,
				branch = orig_head_branch
			}
		end
		
		return { 
			action = "merge",
			sha = merge_head_content,
			branch = merge_head_branch
		}
	end

	-- Check for cherry-pick state
	if vim.fn.filereadable(git_dir .. "/CHERRY_PICK_HEAD") == 1 then
		-- Read CHERRY_PICK_HEAD content and branch
		local cherry_pick_head_content, cherry_pick_head_branch = read_head_and_branch(git_dir, "CHERRY_PICK_HEAD")

		if side == ":2" then
			return { 
				action = "cherry-pick",
				sha = orig_head_content,
				branch = orig_head_branch
			}
		end
		
		return { 
			action = "cherry-pick",
			sha = cherry_pick_head_content,
			branch = cherry_pick_head_branch
		}
	end

	-- Check for revert state
	if vim.fn.filereadable(git_dir .. "/REVERT_HEAD") == 1 then
		-- Read REVERT_HEAD content and branch
		local revert_head_content, revert_head_branch = read_head_and_branch(git_dir, "REVERT_HEAD")

		if side == ":2" then
			return { 
				action = "revert",
				sha = orig_head_content,
				branch = orig_head_branch
			}
		end
		
		return { 
			action = "revert",
			sha = revert_head_content,
			branch = revert_head_branch
		}
	end

	-- Check for rebase state
	if vim.fn.filereadable(git_dir .. "/rebase-merge/head-name") == 1 or vim.fn.filereadable(git_dir .. "/rebase-apply/head-name") == 1 then
		-- For rebase, we need to read the current HEAD being rebased
		local current_head_content = vim.fn.systemlist("git rev-parse HEAD 2>/dev/null")[1]
		if current_head_content then
			current_head_content = string.sub(current_head_content, 1, 8)
		end
		
		local current_branch_result = vim.fn.systemlist("git branch --contains " .. (current_head_content or "") .. " 2>/dev/null")
		local current_branch = nil
		if vim.v.shell_error == 0 and current_branch_result[1] then
			current_branch = string.gsub(current_branch_result[1], "^[* ] ", "")
		end

		if side == ":2" then
			return { 
				action = "rebase",
				sha = current_head_content,
				branch = current_branch
			}
		end
		
		return { 
			action = "rebase",
			sha = orig_head_content,
			branch = orig_head_branch
		}
	end

	-- Default fallback - no active git operation detected
	error("no active git merge/rebase operation detected")
end

return M

local M = {}
---@return string The current git branch
M.get_current_branch = function ()
	local res = vim.system({
		vim.o.shell,
		vim.o.shellcmdflag,
        "git branch --show-current"
	}):wait()
	if res.code ~= 0 then
		vim.notify(res.stderr, vim.log.levels.ERROR)
	end
    return vim.trim(res.stdout)
end
---@param revision string git revision that can be commit hash, branch name, tag or ref
---@return string
M.convert_revision_into_temp_dir = function(revision)
	local temp_dir_path = vim.fn.tempname()
	vim.fn.mkdir(temp_dir_path, "p")

	local res = vim.system({
		vim.o.shell,
		vim.o.shellcmdflag,
		string.format("git archive %s | tar -x -C %s", revision, temp_dir_path),
	}):wait()

	if res.code ~= 0 then
		vim.notify(res.stderr, vim.log.levels.ERROR)
	end
	return temp_dir_path
end

return M

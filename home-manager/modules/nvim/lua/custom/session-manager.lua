local M = {}

---@class SessionManager.Config
local defaults = {
	dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
	branch = true, -- use git branch to save session
}

---@type SessionManager.Config
M.options = {}

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
	vim.fn.mkdir(M.options.dir, "p")
end

---@param opts? {branch?: boolean}
function M.current(opts)
	opts = opts or {}
	local name = vim.fn.getcwd():gsub("[\\/:]+", "%%")
	if M.options.branch and opts.branch ~= false then
		local branch = M.branch()
		if branch and branch ~= "main" and branch ~= "master" then
			name = name .. "%%" .. branch:gsub("[\\/:]+", "%%")
		end
	end
	return M.options.dir .. name .. ".vim"
end

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
	vim.fn.mkdir(M.options.dir, "p")
end

function M.save()
	vim.cmd("mks! " .. vim.fn.fnameescape(M.current()))
end

---@param opts? { last?: boolean }
function M.load(opts)
	opts = opts or {}
	---@type string
	local file = M.current()
	if vim.fn.filereadable(file) == 0 then
		file = M.current({ branch = false })
	end
	if file and vim.fn.filereadable(file) ~= 0 then
		vim.cmd("silent! source " .. vim.fn.fnameescape(file))
	end
end

--- get current branch name
---@return string?
function M.branch()
	if vim.uv.fs_stat(".git") then
		local ret = vim.fn.systemlist("git branch --show-current")[1]
		return vim.v.shell_error == 0 and ret or nil
	end
end

return M

--  Potential issue here when reinstalling
local function getCwd()
	local path = require("fzf-lua.path").git_root(vim.loop.cwd(), true) or vim.loop.cwd()
	return { cwd = path, show_cwd_header = true }
end

local function searchFiles()
	local opts = getCwd()

	require("fzf-lua").files(opts)
end

local function liveGrep()
	local opts = getCwd()

	require("fzf-lua").live_grep(opts)
end

return {
	searchFiles = searchFiles,
	liveGrep = liveGrep,
}
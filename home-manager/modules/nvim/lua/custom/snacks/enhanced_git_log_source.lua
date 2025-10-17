local M = {}

---@param ... (string|string[]|nil)
local function git_args(...)
	local ret = { "-c", "core.quotepath=false" } ---@type string[]
	for i = 1, select("#", ...) do
		local arg = select(i, ...)
		vim.list_extend(ret, type(arg) == "table" and arg or { arg })
	end
	return ret
end
---@class EnhancedGitLogOpts
---@field author? string filter commits by author

-- https://github.com/folke/snacks.nvim/blob/dae80fb393f712bd7352a20f9185f5e16b69f20f/lua/snacks/picker/source/git.lua#L90
M.enhanced_git_log = {
	---@param opts EnhancedGitLogOpts
	---@type snacks.picker.finder
	finder = function(opts, ctx)
		if ctx.filter.search == "" then
			return function() end
		end
		local _, pargs = Snacks.picker.util.parse(string.format("dummy -- %s", ctx.filter.search))

		local args = git_args(
			"log",
			"--pretty=format:%h %s (%ch)",
			"--abbrev-commit",
			"--decorate",
			"--date=short",
			"--color=never",
			"--no-show-signature",
			"--no-patch"
		)

		pargs = vim.iter(pargs):map(function(v)
            if string.sub(v, 1, 1) == "-" then
                return v
            end
            return "--" .. v
		end):totable()

		vim.list_extend(args, pargs)

		if opts.author then
			table.insert(args, "--author=" .. opts.author)
		end

		return function(cb)
			require('snacks.picker.source.proc').proc({
				opts,
				{
					cmd = "git",
					args = args,
					-- NOTE transform data show they can be displayed in the picker item list
					---@param item snacks.picker.finder.Item
					transform = function(item)
						local commit, msg, date = item.text:match("^(%S+) (.*) %((.*)%)$")
						if not commit then
							Snacks.notify.error(
								("failed to parse log item:\n%q"):format(item.text)
							)
							return false
						end
						item.commit = commit
						item.msg = msg
						item.date = date
					end,
				},
			}, ctx)(cb)
		end
	end,
}

return M

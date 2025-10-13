local uv = vim.uv or vim.loop
local Async = require("snacks.picker.util.async")

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

---@param opts snacks.picker.proc.Config|{[1]: snacks.picker.Config, [2]: snacks.picker.proc.Config}
---@type snacks.picker.finder
local function proc(opts, ctx)
	if svim.islist(opts) then
		local transform = opts[2].transform
		opts = Snacks.config.merge(unpack(vim.deepcopy(opts))) --[[@as snacks.picker.proc.Config]]
		opts.transform = transform
	end
	---@cast opts snacks.picker.proc.Config
	assert(opts.cmd, "`opts.cmd` is required")
	---@async
	return function(cb)
		if opts.transform then
			local _cb = cb
			cb = function(item)
				local t = opts.transform(item, ctx)
				item = type(t) == "table" and t or item
				if t ~= false then
					_cb(item)
				end
			end
		end

		if ctx.picker.opts.debug.proc then
			vim.schedule(function()
				Snacks.debug.cmd(Snacks.config.merge(opts, { group = true }))
			end)
		end

		local sep = opts.sep or "\n"
		local aborted = false
		local stdout = assert(uv.new_pipe())

		local self = Async.running()

		local spawn_opts = {
			args = opts.args,
			stdio = { nil, stdout, nil },
			cwd = opts.cwd and svim.fs.normalize(opts.cwd) or nil,
			env = opts.env,
			hide = true,
		}

		local handle ---@type uv.uv_process_t
		---@diagnostic disable-next-line: missing-fields
		handle = uv.spawn(opts.cmd, spawn_opts, function(code, _signal)
			if not aborted and code ~= 0 and opts.notify ~= false then
				local full = { opts.cmd or "" }
				vim.list_extend(full, opts.args or {})
				-- Snacks.notify.error(("Command failed:\n- cmd: `%s`"):format(table.concat(full, " ")))
			end
			handle:close()
			self:resume()
		end)
		if not handle then
			return Snacks.notify.error("Failed to spawn " .. opts.cmd)
		end

		local prev ---@type string?
		local queue = require("snacks.picker.util.queue").new()

		self:on("abort", function()
			stdout:read_stop()
			if not stdout:is_closing() then
				stdout:close()
			end
			aborted = true
			queue:clear()
			cb = function() end
			if not handle:is_closing() then
				handle:kill("sigterm")
				vim.defer_fn(function()
					if not handle:is_closing() then
						handle:kill("sigkill")
					end
				end, 200)
			end
		end)

		---@param data? string
		local function process(data)
			if aborted then
				return
			end
			if not data then
				return prev and cb({ text = prev })
			end
			local from = 1
			while from <= #data do
				local nl = data:find(sep, from, true)
				if nl then
					local cr = data:byte(nl - 1, nl - 1) == 13 -- \r
					local line = data:sub(from, nl - (cr and 2 or 1))
					if prev then
						line, prev = prev .. line, nil
					end
					cb({ text = line })
					from = nl + 1
				elseif prev then
					prev = prev .. data:sub(from)
					break
				else
					prev = data:sub(from)
					break
				end
			end
		end

		stdout:read_start(function(err, data)
			assert(not err, err)
			if aborted or not data then
				stdout:close()
				self:resume()
				return
			end
			if M.USE_QUEUE then
				queue:push(data)
				self:resume()
			else
				process(data)
			end
		end)

		while not (stdout:is_closing() and queue:empty()) do
			if queue:empty() then
				self:suspend()
			else
				process(queue:pop())
			end
		end
		-- process the last line
		if prev then
			cb({ text = prev })
		end
	end
end

-- https://github.com/folke/snacks.nvim/blob/dae80fb393f712bd7352a20f9185f5e16b69f20f/lua/snacks/picker/source/git.lua#L90
M.enhanced_git_log = {
	---@param opts EnhancedGitLogOpts
	---@type snacks.picker.finder
	finder = function(opts, ctx)
		if ctx.filter.search == "" then
			return function() end
		end
		local _, pargs = Snacks.picker.util.parse(string.format("-- %s", ctx.filter.search))

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
            if not string.sub(v, 1, 1) then
                return v
            end
            return "--" .. v
		end):totable()

		vim.list_extend(args, pargs)
        print(vim.inspect(args))

		if opts.author then
			table.insert(args, "--author=" .. opts.author)
		end

		return function(cb)
			proc({
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

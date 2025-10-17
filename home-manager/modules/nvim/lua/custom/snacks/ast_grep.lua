local M = {}

M.ast_grep = {
	---@param opts snacks.picker.grep.Config
	finder = function(opts, ctx)
		local cmd = "ast-grep"
		local args = { "run", "--color=never", "--json=stream" }
		if vim.fn.has("win32") == 1 then
			cmd = "sg"
		end
		if opts.hidden then
			table.insert(args, "--no-ignore=hidden")
		end
		if opts.ignored then
			table.insert(args, "--no-ignore=vcs")
		end
		local pattern, pargs = Snacks.picker.util.parse(ctx.filter.search)
		table.insert(args, string.format("--pattern=%s", pattern))
		vim.list_extend(args, pargs)
		return require("snacks.picker.source.proc").proc({
			opts,
			{
				cmd = cmd,
				args = args,
				transform = function(item)
					local entry = vim.json.decode(item.text)
					if vim.tbl_isempty(entry) then
						return false
					else
						local start = entry.range.start
						item.cwd = svim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or ".") or nil
						item.file = entry.file
						item.line = entry.text
						item.pos = { tonumber(start.line) + 1, tonumber(start.column) }
					end
				end,
			},
		}, ctx)
	end,
}

return M

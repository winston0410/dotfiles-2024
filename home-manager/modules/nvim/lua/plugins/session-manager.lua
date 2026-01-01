local session_manager = require("custom.session-manager")
local group = vim.api.nvim_create_augroup("SessionManager", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = function()
		if vim.fn.argc() > 0 or vim.g.disable_session then
            return
		end
        -- restore session after Nvim event loop has started, so the loading wouldn't block it
        vim.schedule(function()
            session_manager.load()
        end)
	end,
	nested = true,
})
session_manager.setup({})

local function save_qf()
	local qflist = vim.fn.getqflist()
	if #qflist == 0 then
		return
	end

	local qf_session_dir = vim.fs.joinpath(session_manager.options.dir, "qf")
	vim.fn.mkdir(qf_session_dir, "p")

	for _, entry in ipairs(qflist) do
		-- use filename instead of bufnr so it can be reloaded
		entry.filename = vim.api.nvim_buf_get_name(entry.bufnr)
		entry.bufnr = nil
	end

	local serialized_entries = vim.fn.json_encode(qflist)

	vim.g.RestoreQuickFix = serialized_entries
end

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = group,
	callback = function()
        if vim.g.disable_session then
            return
        end
        save_qf()
		session_manager.save()
	end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
	group = group,
	callback = function()
		local qf_session_content = vim.g.RestoreQuickFix
		if type(qf_session_content) ~= "string" then
			return
		end
		local qf_session = vim.fn.json_decode(qf_session_content)
		vim.fn.setqflist(qf_session, "r")
	end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
	group = group,
	callback = function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local is_listed = vim.bo[buf].buflisted
			if not is_listed then
				vim.api.nvim_win_close(win, true)
			end
		end
	end,
})

vim.api.nvim_create_autocmd("SessionLoadPost", {
	group = group,
	callback = function()
		require("custom.dap").load_breakpoints()
	end,
})

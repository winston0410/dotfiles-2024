local M = {}

local clear_buffer_keybinding = "<leader>bc"
local delete_buffer_keybinding = "<leader>bq"
local next_buffer_keybinding = "<leader>bl"
local prev_buffer_keybinding = "<leader>bh"
function M.setup()
	vim.keymap.set({ "n" }, clear_buffer_keybinding, function()
		-- TODO
	end, { silent = true, noremap = true, desc = "Unload other buffers" })
	vim.keymap.set({ "n" }, delete_buffer_keybinding, function()
		Snacks.bufdelete.delete()
	end, { silent = true, noremap = true, desc = "Delete current buffer" })
	vim.keymap.set({ "n" }, next_buffer_keybinding, function()
		vim.cmd("bnext")
	end, { silent = true, noremap = true, desc = "Go to next buffer" })
	vim.keymap.set({ "n" }, prev_buffer_keybinding, function()
		vim.cmd("bprev")
	end, { silent = true, noremap = true, desc = "Go to previous buffer" })
	for i = 1, 9 do
		vim.keymap.set({ "n" }, "<leader>b" .. i, function()
			vim.cmd(string.format("LualineBuffersJump %s", i))
		end, { noremap = true, silent = true, desc = string.format("Jump to buffer %s", i) })
	end
end

--- @param bufId number
function M.detach(bufId)
	pcall(function()
		vim.keymap.del({ "n" }, clear_buffer_keybinding, { buffer = bufId })
		vim.keymap.del({ "n" }, delete_buffer_keybinding, { buffer = bufId })
		vim.keymap.del({ "n" }, next_buffer_keybinding, { buffer = bufId })
		vim.keymap.del({ "n" }, prev_buffer_keybinding, { buffer = bufId })
		for i = 1, 9 do
			vim.keymap.del({ "n" }, "<leader>b" .. i, { buffer = bufId })
		end
	end)
end

return M

local keys = { "a", "c", "i" }
for _, key in ipairs(keys) do
	vim.keymap.set("n", key, function()
		vim.cmd("quit")
		vim.cmd("startinsert")
	end, { buffer = true, silent = true, desc = "Clear the buffer and enter insert mode" })
end

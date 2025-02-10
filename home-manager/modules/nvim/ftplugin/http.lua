vim.keymap.set("n", "<CR>", function()
	require("kulala").run()
end, { buffer = true, silent = true, desc = "Execute the request" })

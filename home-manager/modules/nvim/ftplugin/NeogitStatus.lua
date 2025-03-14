local tab_id = vim.api.nvim_get_current_tabpage()
vim.api.nvim_tabpage_set_var(tab_id, "lockbuffer", true)

if vim.g.enable_session == nil then
	vim.g.enable_session = true
end

vim.pack.add({
    { src = "https://github.com/folke/persistence.nvim", version = vim.version.range("3.0")}
})
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Persistence", { clear = true }),
    callback = function()
        if vim.fn.argc() == 0 and vim.g.enable_session then
            require("persistence").load()
        end
    end,
    nested = true,
})

require("persistence").setup({})

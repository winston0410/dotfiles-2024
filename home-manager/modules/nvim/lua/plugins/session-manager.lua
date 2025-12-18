vim.pack.add({
    { src = "https://github.com/folke/persistence.nvim", version = vim.version.range("3.x") }
})
local group = vim.api.nvim_create_augroup("Persistence", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
        if vim.fn.argc() == 0 and not vim.g.disable_session then
            require("persistence").load()
        end
    end,
    nested = true,
})
local persistence = require("persistence")
require("persistence").setup({})
local persistence_config = require("persistence.config")

--NOTE not sure if there is a limit for global variable size in session file. Keep the code that save Quickfix list result in another file now
vim.api.nvim_create_autocmd("User", {
    pattern = "PersistenceSavePre",
    group = group,
    callback = function()
        local qflist = vim.fn.getqflist()
        if #qflist == 0 then
            return
        end

        local qf_session_dir = vim.fs.joinpath(persistence_config.options.dir, "qf")
        vim.fn.mkdir(qf_session_dir, "p")

        for _, entry in ipairs(qflist) do
            -- use filename instead of bufnr so it can be reloaded
            entry.filename = vim.api.nvim_buf_get_name(entry.bufnr)
            entry.bufnr = nil
        end

        local serialized_entries = vim.fn.json_encode(qflist)

        vim.g.RestoreQuickFix = serialized_entries
        -- local current_session_file = persistence.current()
        -- local qf_session_file =
        --     vim.fs.joinpath(qf_session_dir, vim.fs.basename(current_session_file))
        -- vim.fn.writefile({ serialized_entries }, qf_session_file)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "PersistenceLoadPost",
    group = group,
    callback = function()
        -- local current_session_file = persistence.current()
        -- local qf_session_dir = vim.fs.joinpath(persistence_config.options.dir, "qf")
        -- local qf_session_file =
        --     vim.fs.joinpath(qf_session_dir, vim.fs.basename(current_session_file))
        -- local qf_session_exists = vim.fn.filereadable(qf_session_file)
        -- if qf_session_exists == 0 then
        --     return
        -- end
        -- local qf_session_file_content = vim.fn.readfile(qf_session_file)
        -- local qf_session = vim.fn.json_decode(qf_session_file_content[1])

        local qf_session_content = vim.g.RestoreQuickFix 
        if type(qf_session_content) ~= "string" then
            return
        end
        local qf_session =  vim.fn.json_decode(qf_session_content)
        vim.fn.setqflist(qf_session, "a")
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "PersistenceLoadPost",
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

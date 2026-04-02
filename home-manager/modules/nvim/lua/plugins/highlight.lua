vim.pack.add({
    { src = "https://github.com/winston0410/syringe.nvim" },
    { src = "https://github.com/mcauley-penney/visual-whitespace.nvim",        version = "main" },
    -- { src = "https://github.com/GCBallesteros/jupytext.nvim" },
    { src = "https://github.com/folke/ts-comments.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",              version = "main" },
    { src = "https://github.com/ravsii/tree-sitter-d2" },
    { src = "https://github.com/OXY2DEV/markview.nvim",                        version = vim.version.range("27.x") },
}, { confirm = false })
-- FIXME seems to be outdated. Need a newer plugin for jupytext?
-- require("jupytext").setup({
--     style = "markdown",
--     output_extension = "md",
--     force_ft = "markdown",
-- })

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        if ev.data.spec.name ~= "tree-sitter-d2" then
            return
        end
        vim.system({ "make", "nvim-install" }, { cwd = ev.data.path }, function(res)
            if res.code ~= 0 then
                vim.notify("Build failed for " .. ev.data.spec.name, vim.log.levels.ERROR)
            else
                vim.notify("Build succeeded for " .. ev.data.spec.name, vim.log.levels.INFO)
            end
        end)
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("visual-whitespace.setup", {}),
    callback = function(event)
        local comment_hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
        local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
        require("visual-whitespace").setup({
            highlight = { fg = comment_hl.fg, bg = visual_hl.bg },
        })
    end,
})

-- https://github.com/MeanderingProgrammer/treesitter-modules.nvim?tab=readme-ov-file#do-i-need-this-plugin
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter.setup", {}),
    callback = function(args)
        local buf = args.buf
        local filetype = args.match

        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.treesitter.language.add(language) then
            return
        end

        --TODO review csv treesitter highlight in the future. It is not good at the moment so we disable its parser
        if filetype == "csv" then
            return
        end

        vim.treesitter.start(buf, language)

        vim.keymap.set({ "x" }, "+", "an", { remap = true, silent = true })
        vim.keymap.set({ "x" }, "-", "in", { remap = true, silent = true })
    end,
})

require("markview").setup({
    preview = {
        enable = false,
        hybrid_modes = { "n" },
        icon_provider = "mini",
        filetypes = { "markdown", "codecompanion", "md", "rmd", "quarto", "yaml", "typst" },
        ignore_buftypes = {},
    },
    markdown = {
        headings = {
            shift_width = 0,
        },
        code_blocks = {
            style = "simple",
            sign = false,
        },
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "csv" },
    desc = "Enable CSV View on .csv files",
    callback = function()
        vim.pack.add({ { src = "https://github.com/hat0uma/csvview.nvim", version = vim.version.range("1.x") } })
        require('csvview').setup()
        require("csvview").enable()
    end,
})

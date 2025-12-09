vim.pack.add({
    { src = "https://github.com/winston0410/syringe.nvim" },
    { src = "https://github.com/mcauley-penney/visual-whitespace.nvim",        version = "main" },
    { src = "https://github.com/GCBallesteros/jupytext.nvim" },
    { src = "https://github.com/MeanderingProgrammer/treesitter-modules.nvim", version = "main" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter",              version = "main" },
})

local function setup()
    local comment_hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
    local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
    require("visual-whitespace").setup({
        highlight = { fg = comment_hl.fg, bg = visual_hl.bg },
    })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function(event)
        setup()
    end,
})

setup()

require("jupytext").setup({
    style = "markdown",
    output_extension = "md",
    force_ft = "markdown",
})

require("treesitter-modules").setup({
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = false,
            node_incremental = "+",
            node_decremental = "-",
            scope_incremental = false,
        },
    },
})

require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter.setup", {}),
    callback = function(args)
        local filetype = args.match

        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.treesitter.language.add(language) then
            return
        end
        vim.treesitter.start(args.buf, language)
    end,
})

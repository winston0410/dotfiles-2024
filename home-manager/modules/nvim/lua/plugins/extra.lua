-- FIXME https://github.com/mistricky/codesnap.nvim/issues/162
-- vim.pack.add({
-- 	{ src = "https://github.com/mistricky/codesnap.nvim", version = vim.version.range("2.0") },
-- })
-- require("codesnap").setup({
-- 	show_line_number = true,
-- })
-- improve structure here
vim.api.nvim_create_autocmd("CursorHold", {
    once = true,
    callback = function()
        -- really optional plugins
        vim.pack.add({
            { src = "https://github.com/vyfor/cord.nvim",                    version = vim.version.range("2.x") },
            { src = "https://github.com/michaelb/sniprun",                   version = "v1.3.20" },
            { src = "https://github.com/nvim-lua/plenary.nvim" },
            { src = "https://github.com/mistweaverco/kulala.nvim",           version = vim.version.range("5.x") },
            { src = "https://github.com/martineausimon/nvim-lilypond-suite", },
            { src = "https://github.com/Ramilito/kubectl.nvim",              version = vim.version.range("2.x") },
        })

        require("cord").setup({
            timestamp = {
                enabled = true,
                reset_on_idle = false,
                reset_on_change = false,
            },
            editor = {
                client = "neovim",
                tooltip = "Hugo's ultimate editor",
            },
        })
        require("sniprun").setup({
            binary_path = "sniprun",
            selected_interpreters = { "Python3_fifo" },
            repl_enable = { "Python3_fifo" },
            interpreter_options = {
                CSharp_original = {
                    compiler = "csc",
                },
                TypeScript_original = {
                    interpreter = "node",
                },
            },
            snipruncolors = {
                SniprunVirtualTextOk = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextInfo" }),
                SniprunVirtualWinOk = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextInfo" }),
                SniprunVirtualTextErr = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }),
                SniprunVirtualWinErr = vim.api.nvim_get_hl(0, { name = "DiagnosticVirtualTextError" }),
            },
        })

        require("kulala").setup({
            global_keymaps = false,
            display_mode = "split",
            split_direction = "vertical",
            debug = false,
            default_view = "headers_body",
            winbar = true,
            default_winbar_panes = { "headers_body", "verbose", "script_output", "report" },
            vscode_rest_client_environmentvars = true,
            disable_script_print_output = false,
            environment_scope = "b",
            urlencode = "always",
            -- show_variable_info_text = "float",
            show_variable_info_text = false,
            ui = {
                -- 10Mb
                max_response_size = 1024 * 1024 * 10,
                disable_news_popup = true,
            },
        })
        vim.keymap.set({ "n" }, "<leader>ri", function()
            -- inspect a request for result interpolation
            require("kulala").inspect()
        end, { remap = true, silent = true, desc = "Inspect request" })
        vim.keymap.set({ "x" }, "<leader>r<CR>", function()
            require("kulala").run()
        end, { remap = true, silent = true, desc = "Execute selected requests" })
        vim.keymap.set({ "n" }, "<leader>r<CR>", function()
            require("kulala").run()
        end, { remap = true, silent = true, desc = "Execute a request" })

        vim.keymap.set({ "n" }, "<leader>ry", function()
            require("kulala").copy()
        end, { remap = true, silent = true, desc = "Copy a request as Curl" })
        vim.keymap.set({ "n" }, "<leader>rp", function()
            require("kulala").from_curl()
        end, { remap = true, silent = true, desc = "Paste a request from Curl" })
        vim.keymap.set({ "n" }, "<leader>r/", function()
            require("kulala").search()
        end, { remap = true, silent = true, desc = "Find a request" })
        vim.keymap.set({ "n" }, "]<leader>r", function()
            require("kulala").jump_next()
        end, { remap = true, silent = true, desc = "Jump to next request" })
        vim.keymap.set({ "n" }, "[<leader>r", function()
            require("kulala").jump_prev()
        end, { remap = true, silent = true, desc = "Jump to previous request" })
        vim.keymap.set({ "n" }, "<leader>rg", function()
            require("kulala").download_graphql_schema()
        end, { remap = true, silent = true, desc = "Download GraphQL schema" })

        require("nvls").setup({})
        require("kubectl").setup({
            log_level = vim.log.levels.INFO,
            diff = {
                bin = "kubediff",
            },
        })
    end,
})

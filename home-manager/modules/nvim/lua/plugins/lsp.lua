vim.pack.add({
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("VimPackLspConfig", { clear = true }),
	once = true,
	callback = function(ev)
		vim.pack.add({
			{ src = "https://github.com/dmmulroy/ts-error-translator.nvim", version = vim.version.range("2.x") },
			{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
			{ src = "https://github.com/rachartier/tiny-code-action.nvim" },
		})

		require("ts-error-translator").setup({
			auto_attach = true,
		})
		require("tiny-inline-diagnostic").setup({
			options = {
				show_source = {
					enabled = true,
				},
				show_related = {
					enabled = true,
					max_count = 3,
				},
			},
		})
		vim.diagnostic.config({ virtual_text = false })
		vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float

		require("tiny-code-action").setup({
			backend = "vim",
			picker = "snacks",
		})
	end,
})

return {
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		version = "v2.*",
		build = "make install_jsregexp",
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
		version = "1.x",
		opts = {
			keymap = {
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then
							return cmp.accept()
						else
							return cmp.select_and_accept()
						end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			snippets = { preset = "luasnip" },

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "omni" },
				per_filetype = {
					codecompanion = { inherit_defaults = false, "codecompanion" },
				},
				min_keyword_length = function(ctx)
					-- only applies when typing a command, doesn't apply to arguments
					if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
						return 3
					end
					return 0
				end,
			},
			completion = {
				menu = {
					auto_show = function(ctx)
						return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
					end,
				},
				keyword = { range = "full" },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 400,
				},
				ghost_text = { enabled = true, show_with_menu = false },
			},
			signature = { enabled = true },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},
}

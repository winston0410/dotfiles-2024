return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			{ "L3MON4D3/LuaSnip", version = "v2.*" },
			{ "disrupted/blink-cmp-conventional-commits" },
			-- { "Kaiser-Yang/blink-cmp-git", version = "3.x" },
			-- FIXME this module is exposing the value of an env. Reconsider if we need this
			{ "bydlw98/blink-cmp-env" },
			{ "archie-judd/blink-cmp-words" },
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
		},
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
				default = { "thesaurus", "lsp", "path", "snippets", "buffer", "omni", "conventional_commits" },
				providers = {
					thesaurus = {
						name = "blink-cmp-words",
						module = "blink-cmp-words.thesaurus",
						opts = {
							score_offset = 0,
						},
					},
					-- git = {
					-- 	module = "blink-cmp-git",
					-- 	name = "Git",
					-- 	enabled = function()
					-- 		return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
					-- 	end,
					-- 	--- @module 'blink-cmp-git'
					-- 	--- @type blink-cmp-git.Options
					-- 	opts = {},
					-- },
					conventional_commits = {
						name = "Conventional Commits",
						module = "blink-cmp-conventional-commits",
						enabled = function()
							return vim.bo.filetype == "gitcommit"
						end,
						---@module 'blink-cmp-conventional-commits'
						---@type blink-cmp-conventional-commits.Options
						opts = {}, -- none so far
					},
				},
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
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = require("lspkind").symbolic(ctx.kind, {
											mode = "symbol",
										})
									end

									return icon .. ctx.icon_gap
								end,

								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
						},
					},
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
			fuzzy = { implementation = "prefer_rust" },
		},
	},
}

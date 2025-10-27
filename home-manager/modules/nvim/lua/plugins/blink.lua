return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = {
			{ "moyiz/blink-emoji.nvim", version = "1.x" },
			{ "fang2hou/blink-copilot", version = "1.x" },
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				config = function()
					local ls = require("luasnip")
					local s, sn = ls.snippet, ls.snippet_node
					local t, i, d, c = ls.text_node, ls.insert_node, ls.dynamic_node, ls.choice_node

					local uuid_configs = {
						-- Exclude v3 and v5, as they requires a namespace
						-- "v3",
						-- "v5",
						"v1",
						"v4",
						"v6",
						"v7",
					}

					local snippets = {}

					local now_utc_name = "now_iso8601_utc"
					table.insert(
						snippets,
						s({
							trig = now_utc_name,
							name = now_utc_name,
							desc = "Generate current datetime in ISO8601 format in UTC",
						}, {
							d(1, function()
								return sn(nil, t(os.date("!%Y-%m-%dT%H:%M:%SZ")))
							end),
						})
					)
					local rand_formats = { "base64", "hex" }
					if vim.fn.executable("openssl") == 1 then
						for _, format in ipairs(rand_formats) do
							local name = string.format("rand_%s", format)
							table.insert(
								snippets,
								s({
									trig = name,
									name = name,
									desc = string.format("Generate 32 random bytes in %s", format),
								}, {
									d(1, function()
										local res = vim.system({
											"openssl",
											"rand",
											"-base64",
											"32",
										}, { text = true }):wait()
										if res.code ~= 0 then
											vim.notify(
												string.format(
													"Failed to generate random bytes: %s",
													vim.trim(res.stderr)
												),
												vim.log.levels.ERROR
											)
											return nil
										end
										return sn(nil, t(vim.trim(res.stdout)))
									end),
								})
							)
						end
					end

					for _, uuid_version in ipairs(uuid_configs) do
						local trig_name = "uuid_" .. uuid_version
						local full_desc = "Generate UUID " .. uuid_version

						table.insert(
							snippets,
							s({
								trig = trig_name,
								name = trig_name,
								desc = full_desc,
							}, {
								d(1, function()
									local res = vim.system({
										"uuid",
										uuid_version,
									}, { text = true }):wait()
									if res.code ~= 0 then
										vim.notify(
											string.format("Failed to generate %s: %s", trig_name, vim.trim(res.stderr)),
											vim.log.levels.ERROR
										)
										return nil
									end
									return sn(nil, t(vim.trim(res.stdout)))
								end),
							})
						)
					end

					ls.add_snippets("all", snippets)
				end,
			},
			{ "disrupted/blink-cmp-conventional-commits" },
			-- Only working for github and gitlab
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
				-- NOTE Remember, gh bring us back to select mode again. Use this after the first edit
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
				default = {
					"lsp",
					"path",
					"snippets",
					"buffer",
					"omni",
					"emoji",
					"copilot",
				},
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
						opts = {
							max_completions = 1,
						},
						transform_items = function(ctx, items)
							for _, item in ipairs(items) do
								item.kind_icon = ""
								item.kind_name = "Copilot"
							end
							return items
						end,
					},
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15,
						opts = {
							insert = true,
							---@type string|table|fun():table
							trigger = function()
								return { ":" }
							end,
						},
						should_show_items = function()
							return vim.tbl_contains({ "gitcommit", "markdown" }, vim.o.filetype)
						end,
					},
					dictionary = {
						name = "blink-cmp-words",
						module = "blink-cmp-words.dictionary",
						opts = {
							dictionary_search_threshold = 3,
							score_offset = 0,
						},
					},
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
					-- 	--- @module 'blink-cmp-git'
					-- 	--- @type blink-cmp-git.Options
					-- 	opts = {},
					-- },
					conventional_commits = {
						name = "Conventional Commits",
						module = "blink-cmp-conventional-commits",
						---@module 'blink-cmp-conventional-commits'
						---@type blink-cmp-conventional-commits.Options
						opts = {},
					},
				},
				per_filetype = {
					gitcommit = {
						inherit_defaults = true,
						"conventional_commits",
						-- "git"
					},
					markdown = {
						inherit_defaults = true,
						-- "git",
						"thesaurus",
						-- disable this now, as it makes the UI laggy
						-- "dictionary"
					},
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
									elseif ctx.kind == "Copilot" then
										-- noop
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
				ghost_text = { enabled = true, show_with_menu = true },
			},
			signature = { enabled = true },
			fuzzy = { implementation = "prefer_rust" },
		},
	},
}

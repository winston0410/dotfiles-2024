-- NOTE wait for Neovim 0.12
-- vim.pack.add({
--     { src = "https://github.com/winston0410/syringe.nvim", version = 'main' },
-- })
-- require("syringe").setup({})

local ts_deps = { "nvim-treesitter/nvim-treesitter", branch = "main" }
return {
	{
		"winston0410/syringe.nvim",
		dependencies = ts_deps,
		lazy = false,
		config = function()
			require("syringe").setup({})
		end,
	},
	{
		"jmbuhr/otter.nvim",
		lazy = false,
		dependencies = ts_deps,
		version = "2.x",
		config = function()
			local host_languages = vim.list_extend( require("syringe").get_supported_host_languages(), {"markdown", "markdown_inline"})
			local otter = require("otter")
			otter.setup({
				lsp = {
					diagnostic_update_events = { "BufWritePost", "InsertLeave", "TextChanged" },
				},
			})
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function(ev)
					local main_lang = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
					if not vim.tbl_contains(host_languages, main_lang) then
						return
					end

					local parsername = vim.treesitter.language.get_lang(main_lang)
					if not parsername then
						return
					end
					local ok, parser = pcall(function()
						local parser = vim.treesitter.get_parser(ev.buf, parsername)
						return parser
					end)
					if not ok or not parser then
						return
					end
					otter.activate()
				end,
			})
		end,
	},
	-- keep using this until d2 filetype and treesitter grammar is supported by neovim out of the box
	{
		"ravsii/tree-sitter-d2",
		dependencies = ts_deps,
		version = "*",
		build = "make nvim-install",
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = ts_deps,
		opts = {
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = false,
					node_incremental = "+",
					node_decremental = "-",
					scope_incremental = false,
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = ts_deps,
		branch = "main",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				move = {
					set_jumps = true,
				},
				select = {
					lookahead = true,
					selection_modes = {
						["@class.outer"] = "<c-v>",
					},
					include_surrounding_whitespace = false,
				},
			})

			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "*" },
				callback = function(ev)
					local ts_shared = require("nvim-treesitter-textobjects.shared")
					local mappings = {
						{ symbol = "r", node = "@return", label = "return statement", outer = true, inner = true },
						{ symbol = "p", node = "@parameter", label = "parameter", outer = true, inner = true },
						{ symbol = "f", node = "@function", label = "function definition", outer = true, inner = true },
						{ symbol = "i", node = "@conditional", label = "conditional", outer = true, inner = true },
						{ symbol = "k", node = "@call", label = "function call", outer = true, inner = true },
						{ symbol = "K", node = "@class", label = "class", outer = true, inner = true },
						{ symbol = "a", node = "@attribute", label = "attribute", outer = true, inner = true },
						{ symbol = "b", node = "@block", label = "block", outer = true, inner = true },
					}
					local main_lang = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
					local parsername = vim.treesitter.language.get_lang(main_lang)
					if not parsername then
						return
					end
					local ok, parser = pcall(function()
						local parser = vim.treesitter.get_parser(ev.buf, parsername)
						return parser
					end)
					if not ok or not parser then
						return
					end

					for _, mapping in ipairs(mappings) do
						if mapping.inner then
							local query_string = string.format("%s.inner", mapping.node)
							if ts_shared.check_support(ev.buf, "textobjects", { query_string }) then
								vim.keymap.set({ "x", "o" }, "i" .. mapping.symbol, function()
									require("nvim-treesitter-textobjects.select").select_textobject(query_string)
								end, {
									noremap = true,
									silent = true,
									desc = string.format("Inside %s", mapping.label),
									buffer = ev.buf,
								})
							end
						end
						if mapping.outer then
							local query_string = string.format("%s.outer", mapping.node)
							if ts_shared.check_support(ev.buf, "textobjects", { query_string }) then
								vim.keymap.set({ "n", "x", "o" }, "[" .. mapping.symbol, function()
									require("nvim-treesitter-textobjects.move").goto_previous_start(
										query_string,
										"textobjects"
									)
								end, {
									noremap = true,
									silent = true,
									desc = string.format("Previous %s", mapping.label),
									buffer = ev.buf,
								})
								vim.keymap.set({ "n", "x", "o" }, "]" .. mapping.symbol, function()
									require("nvim-treesitter-textobjects.move").goto_next_start(
										query_string,
										"textobjects"
									)
								end, {
									noremap = true,
									silent = true,
									desc = string.format("Next %s", mapping.label),
									buffer = ev.buf,
								})

								vim.keymap.set({ "x", "o" }, "a" .. mapping.symbol, function()
									require("nvim-treesitter-textobjects.select").select_textobject(
										query_string,
										"textobjects"
									)
								end, {
									noremap = true,
									silent = true,
									desc = string.format("Around %s", mapping.label),
									buffer = ev.buf,
								})
							end
						end
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			vim.cmd("TSUpdate")
		end,
		branch = "main",
		lazy = false,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
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
		end,
	},

	-- TODO see if we can turn these into treesitter's dependencies, and config with its setup function
	{
		"nvim-treesitter/nvim-treesitter-context",
		-- replaced this plugin with dropbar.nvim, as it occupies less estate on screen
		enabled = false,
		opts = {
			max_lines = 5,
		},
		event = { "VeryLazy" },
		dependencies = ts_deps,
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
		config = function() end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		enabled = false,
		event = { "VeryLazy" },
		dependencies = ts_deps,
	},
}

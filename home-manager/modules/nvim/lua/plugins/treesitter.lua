return {
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
		config = function() end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		build = function()
			vim.cmd("TSUpdate")
		end,
		lazy = false,
		priority = 999,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			local installer = require("nvim-treesitter.install")
			installer.prefer_git = true

			---@diagnostic disable-next-line: inject-field
			parser_config.ejs = {
				install_info = {
					branch = "master",
					url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
					files = { "src/parser.c" },
				},
				filetype = "ejs",
				used_by = { "erb" },
			}
			---@diagnostic disable-next-line: inject-field
			parser_config.make = {
				install_info = {
					branch = "main",
					url = "https://github.com/alemuller/tree-sitter-make",
					files = { "src/parser.c" },
				},
				filetype = "make",
				used_by = { "make" },
			}
			local select_around_node = function()
				local ts_utils = require("nvim-treesitter.ts_utils")
				local node = ts_utils.get_node_at_cursor()
				if node == nil then
					vim.notify("No Treesitter node found at cursor position", vim.log.levels.WARN)
					return
				end
				local start_row, start_col, end_row, end_col = ts_utils.get_vim_range({ node:range() })

				if start_row > 0 and end_row > 0 then
					vim.api.nvim_buf_set_mark(0, "<", start_row, start_col - 1, {})
					vim.api.nvim_buf_set_mark(0, ">", end_row, end_col - 1, {})
					vim.cmd("normal! gv")
				end
			end

			vim.keymap.set(
				{ "o", "x" },
				"%",
				select_around_node,
				{ silent = true, noremap = true, desc = "Treesitter node" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"a%",
				select_around_node,
				{ silent = true, noremap = true, desc = "Treesitter node" }
			)
			vim.keymap.set({ "n", "v" }, "%", function()
				local ts_utils = require("nvim-treesitter.ts_utils")
				local cur_row, cur_col = unpack(vim.api.nvim_win_get_cursor(0))

				local node = ts_utils.get_node_at_cursor()

				if node == nil then
					vim.notify("No Treesitter node found at cursor position", vim.log.levels.WARN)
					return
				end
				vim.notify(string.format("type of node is %s", node:type()), vim.log.levels.DEBUG)

				local start_row, start_col, end_row, end_col = ts_utils.get_vim_range({ node:range() })

				-- -- decide which position is further away from current cursor position, and jump to there
				-- -- simple algo, row is always compared before column
				local start_row_diff = math.abs(cur_row - start_row)
				local end_row_diff = math.abs(end_row - cur_row)

				local target_row = start_row
				local target_col = start_col

				if end_row_diff == start_row_diff then
					if math.abs(end_col - cur_col) > math.abs(cur_col - start_col) then
						target_row = end_row
						target_col = end_col
					end
				else
					if end_row_diff > start_row_diff then
						target_row = end_row
						target_col = end_col
					end
				end
				vim.api.nvim_win_set_cursor(0, { target_row, target_col - 1 })
			end, { silent = true, noremap = true, desc = "Jump between beginning and end of the node" })

			local function_textobj_binding = "f"
			local call_textobj_binding = "k"
			local class_textobj_binding = "K"
			local conditional_textobj_binding = "i"
			local return_textobj_binding = "r"
			local parameter_textobj_binding = "p"
			local assignment_lhs_textobj_binding = "al"
			local assignment_rhs_textobj_binding = "ar"
			local block_textobj_binding = "b"
			local comment_textobj_binding = "c"
			-- local fold_textobj_binding = "z"
			local prev_next_binding = {
				{ lhs = "[", desc = "Jump to previous %s" },
				{ lhs = "]", desc = "Jump to next %s" },
			}
			local select_around_binding = {
				{ lhs = "a", desc = "Select around %s" },
			}
			local select_inside_binding = {
				{ lhs = "i", desc = "Select inside %s" },
			}

			local enabled_ts_nodes = {
				-- ["@fold"] = {
				-- 	move = vim.tbl_map(function(entry)
				-- 		return {
				-- 			lhs = entry.lhs .. fold_textobj_binding,
				-- 			desc = string.format(entry.desc, "fold"),
				-- 			query_group = "folds",
				-- 		}
				-- 	end, prev_next_binding),
				-- 	select = vim.tbl_map(function(entry)
				-- 		return {
				-- 			lhs = entry.lhs .. fold_textobj_binding,
				-- 			desc = string.format(entry.desc, "fold"),
				-- 		}
				-- 	end, select_around_binding),
				-- },
				["@block.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. block_textobj_binding,
							desc = string.format(entry.desc, "block"),
						}
					end, select_inside_binding),
				},
				["@block.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. block_textobj_binding,
							desc = string.format(entry.desc, "block"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. block_textobj_binding,
							desc = string.format(entry.desc, "block"),
						}
					end, select_around_binding),
				},
				["@comment.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. comment_textobj_binding,
							desc = string.format(entry.desc, "comment"),
						}
					end, select_inside_binding),
				},
				["@comment.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. comment_textobj_binding,
							desc = string.format(entry.desc, "comment"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. comment_textobj_binding,
							desc = string.format(entry.desc, "comment"),
						}
					end, select_around_binding),
				},
				["@return.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. return_textobj_binding,
							desc = string.format(entry.desc, "return statement"),
						}
					end, select_inside_binding),
				},
				["@return.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. return_textobj_binding,
							desc = string.format(entry.desc, "return statement"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. return_textobj_binding,
							desc = string.format(entry.desc, "return statement"),
						}
					end, select_around_binding),
				},
				["@conditional.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. conditional_textobj_binding,
							desc = string.format(entry.desc, "conditional"),
						}
					end, select_inside_binding),
				},
				["@conditional.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. conditional_textobj_binding,
							desc = string.format(entry.desc, "conditional"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. conditional_textobj_binding,
							desc = string.format(entry.desc, "conditional"),
						}
					end, select_around_binding),
				},
				["@parameter.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. parameter_textobj_binding,
							desc = string.format(entry.desc, "parameter"),
						}
					end, select_inside_binding),
				},
				["@parameter.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. parameter_textobj_binding,
							desc = string.format(entry.desc, "parameter"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. parameter_textobj_binding,
							desc = string.format(entry.desc, "parameter"),
						}
					end, select_around_binding),
				},
				["@function.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. function_textobj_binding,
							desc = string.format(entry.desc, "function"),
						}
					end, select_inside_binding),
				},
				["@function.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. function_textobj_binding,
							desc = string.format(entry.desc, "function"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. function_textobj_binding,
							desc = string.format(entry.desc, "function"),
						}
					end, select_around_binding),
				},
				["@call.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. call_textobj_binding,
							desc = string.format(entry.desc, "call"),
						}
					end, select_inside_binding),
				},
				["@call.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. call_textobj_binding,
							desc = string.format(entry.desc, "call"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. call_textobj_binding,
							desc = string.format(entry.desc, "call"),
						}
					end, select_around_binding),
				},
				["@class.inner"] = {
					move = {},
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. class_textobj_binding,
							desc = string.format(entry.desc, "class"),
						}
					end, select_inside_binding),
				},
				["@class.outer"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. class_textobj_binding,
							desc = string.format(entry.desc, "class"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. class_textobj_binding,
							desc = string.format(entry.desc, "class"),
						}
					end, select_around_binding),
				},
				["@assignment.lhs"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. assignment_lhs_textobj_binding,
							desc = string.format(entry.desc, "lhs of assignment"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. assignment_lhs_textobj_binding,
							desc = string.format(entry.desc, "lhs of assignment"),
						}
					end, vim.list_extend(vim.list_extend({}, select_around_binding), select_inside_binding)),
				},
				["@assignment.rhs"] = {
					move = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. assignment_rhs_textobj_binding,
							desc = string.format(entry.desc, "rhs of assignment"),
						}
					end, prev_next_binding),
					select = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. assignment_rhs_textobj_binding,
							desc = string.format(entry.desc, "rhs of assignment"),
						}
					end, vim.list_extend(vim.list_extend({}, select_around_binding), select_inside_binding)),
				},
			}
			local config = {
				ensure_installed = "all",
				auto_install = false,
				sync_install = false,
				ignore_install = {},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = false,
						node_incremental = "+",
						node_decremental = "-",
						scope_incremental = false,
					},
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
					priority = {
						["@comment.error"] = 999,
						["@comment.warning"] = 999,
						["@comment.note"] = 999,
						["@comment.todo"] = 999,
						-- ["@comment.info"] = 999,
						-- ["@comment.hint"] = 999,
					},
				},
				indent = { enable = true },
				query_linter = {
					enable = true,
					use_virtual_text = true,
					lint_events = { "BufWrite", "CursorHold" },
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next = {},
						goto_next_start = {
							-- -- ["]cd"] = {
							-- -- 	query = "@comment.documentation",
							-- -- 	query_group = "highlights",
							-- -- 	desc = "Next lua doc comment",
							-- -- },
							-- ["]ct"] = {
							-- 	query = "@comment.todo",
							-- 	desc = "Jump to next TODO comment",
							-- },
							-- -- ["]cn"] = {
							-- -- 	query = "@comment.note",
							-- -- 	query_group = "injections",
							-- -- 	desc = "Jump to next NOTE comment",
							-- -- },
						},
						goto_next_end = {},
						goto_previous = {},
						goto_previous_end = {},
						goto_previous_start = {},
					},
				},
			}
			for node, value in pairs(enabled_ts_nodes) do
				if #value.move == 2 then
					local prev = value.move[1]
					local next = value.move[2]
					config.textobjects.move.goto_previous_start[prev.lhs] =
						{ query = node, desc = prev.desc, query_group = prev.query_group }
					config.textobjects.move.goto_next_start[next.lhs] =
						{ query = node, desc = next.desc, query_group = next.query_group }
				end

				for _, item in ipairs(value.select) do
					config.textobjects.select.keymaps[item.lhs] = { query = node, desc = item.desc }
				end
			end
			require("nvim-treesitter.configs").setup(config)
			vim.api.nvim_create_autocmd("CursorHold", {
				pattern = "*",
				callback = function(ev)
					local treesitter_textobjects_modes = { "n", "x", "o" }
					local del_desc = "Not available in this language"

					local available_textobjects = require("nvim-treesitter.textobjects.shared").available_textobjects()
					pcall(function()
						for node_type, value in pairs(enabled_ts_nodes) do
							local node_label = node_type:sub(2)
							if not vim.list_contains(available_textobjects, node_label) then
								vim.notify(
									string.format("found non-existent Treesitter node's binding: %s", node_label),
									vim.log.levels.DEBUG
								)
								for _, binding in ipairs(value.move) do
									vim.keymap.del(
										treesitter_textobjects_modes,
										binding.lhs,
										{ buffer = ev.buf, desc = del_desc }
									)
								end
							end
						end
					end)
				end,
			})
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			vim.keymap.set(
				{ "n", "x", "o" },
				";",
				ts_repeat_move.repeat_last_move_next,
				{ noremap = true, silent = true, desc = "Repeat Treesitter motion" }
			)
			vim.keymap.set(
				{ "n", "x", "o" },
				",",
				ts_repeat_move.repeat_last_move_previous,
				{ noremap = true, silent = true, desc = "Repeat Treesitter motion" }
			)
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
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		event = { "VeryLazy" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"aaronik/treewalker.nvim",
		event = "CursorHold",
		-- NOTE not really that accurate
		enabled = false,
		opts = {
			highlight = false,
		},
		keys = {
			{
				"<leader>sh",
				function()
					local count = vim.v.count1
					for _ = 1, count do
						vim.cmd("Treewalker Left")
					end
				end,
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "Move left to a Treesitter node",
			},
			{
				"<leader>sl",
				function()
					local count = vim.v.count1
					for _ = 1, count do
						vim.cmd("Treewalker Right")
					end
				end,
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "Move right to a Treesitter node",
			},
			{
				"<leader>sk",
				function()
					local count = vim.v.count1
					for _ = 1, count do
						vim.cmd("Treewalker Up")
					end
				end,
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "Move upward to a Treesitter node",
			},
			{
				"<leader>sj",
				function()
					local count = vim.v.count1
					for _ = 1, count do
						vim.cmd("Treewalker Down")
					end
				end,
				mode = { "n", "v" },
				noremap = true,
				silent = true,
				desc = "Move downward to a Treesitter node",
			},
		},
	},
}

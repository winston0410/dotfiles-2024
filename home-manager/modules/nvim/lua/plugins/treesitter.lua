return {
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
		config = function() end,
	},
    -- keep using this until d2 is supporte by neovim out of the box
    {
          "ravsii/tree-sitter-d2",
          dependencies = { "nvim-treesitter/nvim-treesitter" },
          version = "*",
          build = "make nvim-install",
    },
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" }, 
		build = function()
			vim.cmd("TSUpdate")
		end,
		lazy = false,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			local installer = require("nvim-treesitter.install")
			installer.prefer_git = true

			-- FIXME Failed to load parser: uv_dlsym. Seems like neovim or the grammar's issue
			-- ---@diagnostic disable-next-line: inject-field
			-- parser_config.kbd = {
			-- 	install_info = {
			-- 		branch = "master",
			-- 		url = "https://github.com/postsolar/tree-sitter-kanata",
			-- 		files = { "src/parser.c" },
			-- 	},
			-- 	filetype = "kbd",
			-- 	used_by = { "kbd" },
			-- }
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

			---@param binding string The key binding suffix
			---@param desc string The description for the textobject
			---@param include_move boolean Whether to include movement keybindings
			---@param select_bindings table[] Array of binding groups for selection
			---@return table Configuration object with move and select keymaps
			local function create_textobj_config(binding, desc, include_move, select_bindings)
				include_move = include_move == nil and true or include_move
				
				local select_keymaps = {}
				for _, binding_group in ipairs(select_bindings) do
					local mapped_bindings = vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. binding,
							desc = string.format(entry.desc, desc),
						}
					end, binding_group)
					for _, mapped_binding in ipairs(mapped_bindings) do
						table.insert(select_keymaps, mapped_binding)
					end
				end
				
				return {
					move = include_move and vim.tbl_map(function(entry)
						return {
							lhs = entry.lhs .. binding,
							desc = string.format(entry.desc, desc),
						}
					end, prev_next_binding) or {},
					select = select_keymaps,
				}
			end

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
				["@block.inner"] = create_textobj_config(block_textobj_binding, "block", false, { select_inside_binding }),
				["@block.outer"] = create_textobj_config(block_textobj_binding, "block", true, { select_around_binding }),
                -- NOTE note really that helpful, and it causing a conflict with [c
				-- ["@comment.inner"] = create_textobj_config(comment_textobj_binding, "comment", false, { select_inside_binding }),
				-- ["@comment.outer"] = create_textobj_config(comment_textobj_binding, "comment", true, { select_around_binding }),
				["@return.inner"] = create_textobj_config(return_textobj_binding, "return statement", false, { select_inside_binding }),
				["@return.outer"] = create_textobj_config(return_textobj_binding, "return statement", true, { select_around_binding }),
				["@conditional.inner"] = create_textobj_config(conditional_textobj_binding, "conditional", false, { select_inside_binding }),
				["@conditional.outer"] = create_textobj_config(conditional_textobj_binding, "conditional", true, { select_around_binding }),
				["@parameter.inner"] = create_textobj_config(parameter_textobj_binding, "parameter", false, { select_inside_binding }),
				["@parameter.outer"] = create_textobj_config(parameter_textobj_binding, "parameter", true, { select_around_binding }),
				["@function.inner"] = create_textobj_config(function_textobj_binding, "function", false, { select_inside_binding }),
				["@function.outer"] = create_textobj_config(function_textobj_binding, "function", true, { select_around_binding }),
				["@call.inner"] = create_textobj_config(call_textobj_binding, "call", false, { select_inside_binding }),
				["@call.outer"] = create_textobj_config(call_textobj_binding, "call", true, { select_around_binding }),
				["@class.inner"] = create_textobj_config(class_textobj_binding, "class", false, { select_inside_binding }),
				["@class.outer"] = create_textobj_config(class_textobj_binding, "class", true, { select_around_binding }),
				["@assignment.lhs"] = create_textobj_config(assignment_lhs_textobj_binding, "lhs of assignment", true, { select_around_binding, select_inside_binding }),
				["@assignment.rhs"] = create_textobj_config(assignment_rhs_textobj_binding, "rhs of assignment", true, { select_around_binding, select_inside_binding }),
			}
			local config = {
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
						["@comment.info"] = 999,
						["@comment.hint"] = 999,
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
}

local function init(use)
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
		requires = { "nvim-treesitter/nvim-treesitter" },
        commit = "e69a504baf2951d52e1f1fbb05145d43f236cbf1"
	})
	-- --Only use this when developing something related treesitter, slow to start
	-- --{ "nvim-treesitter/playground" },
	-- use({
	-- 	"JoosepAlviste/nvim-ts-context-commentstring",
	-- 	requires = { "nvim-treesitter/nvim-treesitter" },
	-- })
	use({
		"nvim-treesitter/nvim-treesitter",
        commit = "efec7115d8175bdb6720eeb4e26196032cb52593",
		run = function()
			vim.cmd("TSUpdate")
		end,
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

			parser_config.wast = {
				install_info = {
					branch = "main",
					url = "https://github.com/wasm-lsp/tree-sitter-wasm",
					files = { "wast/src/parser.c" },
				},
				filetype = "wast",
				used_by = { "wast" },
			}
			parser_config.wat = {
				install_info = {
					branch = "main",
					url = "https://github.com/wasm-lsp/tree-sitter-wasm",
					files = { "wat/src/parser.c" },
				},
				filetype = "wat",
				used_by = { "wat" },
			}
			parser_config.ejs = {
				install_info = {
					branch = "master",
					url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
					files = { "src/parser.c" },
				},
				filetype = "ejs",
				used_by = { "erb" },
			}
			parser_config.make = {
				install_info = {
					branch = "main",
					url = "https://github.com/alemuller/tree-sitter-make",
					files = { "src/parser.c" },
				},
				filetype = "make",
				used_by = { "make" },
			}

			for _, mode in ipairs({ "n", "v" }) do
				-- Unmap x
				vim.api.nvim_set_keymap(mode, "x", "<nop>", { silent = true, noremap = true })
			end

			treesitter.setup({
				highlight = { enable = true },
				indent = { enable = true },
				context_commentstring = { enable = true, enable_autocmd = false },
				query_linter = {
					enable = true,
					use_virtual_text = true,
					lint_events = { "BufWrite", "CursorHold" },
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ai"] = "@conditional.outer",
							["ii"] = "@conditional.inner",
							["ac"] = "@call.inner",
							["ic"] = "@call.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["xf"] = "@function.outer",
							["xc"] = "@call.outer",
							["xs"] = "@parameter.inner",
							["xz"] = "@conditional.outer",
							["xv"] = "@class.outer",
						},
						goto_next_end = {
							["xF"] = "@function.outer",
							["xC"] = "@call.outer",
							["xS"] = "@parameter.inner",
							["xZ"] = "@conditional.outer",
							["xV"] = "@class.outer",
						},
						goto_previous_start = {
							["Xf"] = "@function.outer",
							["Xc"] = "@call.outer",
							["Xs"] = "@parameter.inner",
							["Xz"] = "@conditional.outer",
							["Xv"] = "@class.outer",
						},
						goto_previous_end = {
							["XF"] = "@function.outer",
							["XC"] = "@call.outer",
							["XS"] = "@parameter.inner",
							["XZ"] = "@conditional.outer",
							["XV"] = "@class.outer",
						},
					},
				},
			})
		end,
	})
end

return { init = init }
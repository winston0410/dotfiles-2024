return {
	{
		"Bekaboo/dropbar.nvim",
		version = "12.x",
		-- FIXME dropbar pick does not work, after recovering from a session
		lazy = false,
		enabled = true,
		dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
		keys = {
			{
				"<leader>ps",
				function()
					require("dropbar.api").pick()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				expr = true,
				desc = "Search symobls",
			},
		},
		init = function()
			vim.o.mousemoveevent = true
		end,
		config = function()
			require("dropbar").setup({
				bar = {
					---@type dropbar_source_t[]|fun(buf: integer, win: integer): dropbar_source_t[]
					sources = function(buf, _)
						local sources = require("dropbar.sources")
						if vim.bo[buf].buftype == "terminal" then
							return {
								sources.terminal,
							}
						end

						return {
							sources.path,
						}
					end,
				},
				sources = {
					lsp = {
						valid_symbols = {
							"File",
							"Module",
							"Namespace",
							"Package",
							"Class",
							"Method",
							"Property",
							"Field",
							"Constructor",
							"Enum",
							"Interface",
							"Function",
							"Object",
							"Keyword",
							"EnumMember",
							"Struct",
							"Event",
							"Operator",
							"TypeParameter",
							-- NOTE exclude all primitive variables
							-- "Variable",
							-- "Constant",
							-- "String",
							-- "Number",
							-- "Boolean",
							-- "Array",
							-- "Null",
						},
					},
					treesitter = {
						valid_types = {
							"block_mapping_pair",
							"array",
							"break_statement",
							"call",
							"case_statement",
							"class",
							"constant",
							"constructor",
							"continue_statement",
							"delete",
							"do_statement",
							"element",
							"enum",
							"enum_member",
							"event",
							"for_statement",
							"function",
							"goto_statement",
							"h1_marker",
							"h2_marker",
							"h3_marker",
							"h4_marker",
							"h5_marker",
							"h6_marker",
							"if_statement",
							"interface",
							"keyword",
							"macro",
							"method",
							"module",
							"namespace",
							"operator",
							"package",
							"pair",
							"property",
							"reference",
							"repeat",
							"return_statement",
							"rule_set",
							"scope",
							"specifier",
							"struct",
							"switch_statement",
							"table",
							"type",
							"type_parameter",
							"unit",
							"while_statement",
							"declaration",
							"field",
							"identifier",
							"object",
							"statement",
							-- NOTE exclude all primitive variables
							-- "value",
							-- "variable",
							-- "null",
							-- "boolean",
							-- "number",
						},
					},
				},
			})
		end,
	},
}

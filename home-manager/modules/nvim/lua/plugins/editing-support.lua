vim.api.nvim_create_autocmd("CursorHold", {
	once = true,
	callback = function()
		vim.pack.add({
			-- Rely on the nvim-surround for adding, changing(cst) and deleting(dst) HTML tags. No need for auto pairing plugins.
			-- For creating HTML tag, we can also use the LSP completion hints for closing the tag. Try typing <div><, and then accept /div>
			{ src = "https://github.com/winston0410/thunder.nvim" },
			{ src = "https://github.com/winston0410/encoding.nvim" },
			{ src = "https://github.com/winston0410/range-highlight.nvim", version = "master" },
			{ src = "https://github.com/nacro90/numb.nvim", version = "master" },
			{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
			{ src = "https://github.com/NStefan002/screenkey.nvim", version = vim.version.range("2.x") },
			{ src = "http://github.com/winston0410/sops.nvim", version = "main" },
			-- move on to this in the future, but the UI is just not as good as which-key.nvim
			-- { src = "https://github.com/nvim-mini/mini.clue" },
			{
				src = "https://github.com/folke/which-key.nvim",
				version = vim.version.range("3.x"),
			},
			{ src = "https://github.com/chrisgrieser/nvim-various-textobjs" },
			{ src = "https://github.com/chrisgrieser/nvim-spider" },
			{
				src = "https://github.com/kylechui/nvim-surround",
				version = vim.version.range("3.x"),
			},
			{
				src = "https://github.com/sphamba/smear-cursor.nvim",
				version = vim.version.range("0.6"),
			},
			{
				src = "https://github.com/s1n7ax/nvim-window-picker",
				version = vim.version.range("2.x"),
			},
			{
				src = "https://github.com/lewis6991/gitsigns.nvim",
				version = vim.version.range("1.x"),
			},
			{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
			{ src = "https://github.com/rlue/vim-barbaric", version = "master" },
		})
		vim.api.nvim_create_autocmd("PackChanged", {
			nested = true,
			callback = function(ev)
				if ev.data.spec.name ~= "nvim-treesitter" then
					return
				end
				if ev.data.kind == "update" then
					vim.cmd("TSUpdate all")
				else
					vim.cmd("TSInstall all")
				end
			end,
		})
		require("numb").setup()
		require("nvim-highlight-colors").setup({
			render = "virtual",
			enable_tailwind = true,
			exclude_filetypes = {
				"lazy",
				"checkhealth",
				"qf",
				"snacks_dashboard",
				"snacks_picker_list",
				"snacks_picker_input",
			},
			exclude_buftypes = {},
		})

		vim.b.sops_auto_transform = true
		vim.g.sops_auto_transform = true

		require("various-textobjs").setup({
			keymaps = {
				useDefaults = false,
			},
		})
		vim.keymap.set({ "o", "x" }, "ad", function()
			require("various-textobjs").diagnostic()
		end, { silent = true, noremap = true, desc = "Around diagnostic" })
		vim.keymap.set({ "o", "x" }, "au", function()
			require("various-textobjs").url()
		end, { silent = true, noremap = true, desc = "Around URL" })
		vim.keymap.set({ "o", "x" }, "aw", function()
			require("various-textobjs").subword("outer")
		end, { silent = true, noremap = true, desc = "Around subword" })
		vim.keymap.set({ "o", "x" }, "iw", function()
			require("various-textobjs").subword("inner")
		end, { silent = true, noremap = true, desc = "Inside subword" })
		-- Using this instead of mini.surround, as it can handle changing html tag correctly
		require("nvim-surround").setup({
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "s",
				normal_cur = "ss",
				normal_line = "S",
				normal_cur_line = "SS",
				visual = "s",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			},
			aliases = {},
		})

		vim.keymap.set({ "n", "o", "x" }, "w", function()
			require("spider").motion("w")
		end, { silent = true, noremap = true, desc = "Jump forward to word" })
		vim.keymap.set({ "n", "o", "x" }, "e", function()
			require("spider").motion("e")
		end, { silent = true, noremap = true, desc = "Jump forward to end of word" })
		vim.keymap.set({ "n", "o", "x" }, "ge", function()
			require("spider").motion("ge")
		end, { silent = true, noremap = true, desc = "Jump backward to previous end of word" })
		vim.keymap.set({ "n", "o", "x" }, "b", function()
			require("spider").motion("b")
		end, { silent = true, noremap = true, desc = "Jump backward to word" })

		-- local miniclue = require("mini.clue")
		-- miniclue.setup({
		-- 	triggers = {
		-- 		-- Leader triggers
		-- 		{ mode = "n", keys = "<Leader>" },
		-- 		{ mode = "x", keys = "<Leader>" },
		--
		-- 		-- `[` and `]` keys
		-- 		{ mode = "n", keys = "[" },
		-- 		{ mode = "n", keys = "]" },
		--
		-- 		-- Built-in completion
		-- 		{ mode = "i", keys = "<C-x>" },
		--
		-- 		-- `g` key
		-- 		{ mode = "n", keys = "g" },
		-- 		{ mode = "x", keys = "g" },
		--
		-- 		-- Marks
		-- 		{ mode = "n", keys = "'" },
		-- 		{ mode = "n", keys = "`" },
		-- 		{ mode = "x", keys = "'" },
		-- 		{ mode = "x", keys = "`" },
		--
		-- 		-- Registers
		-- 		{ mode = "n", keys = '"' },
		-- 		{ mode = "x", keys = '"' },
		-- 		{ mode = "i", keys = "<C-r>" },
		-- 		{ mode = "c", keys = "<C-r>" },
		--
		-- 		-- Window commands
		-- 		{ mode = "n", keys = "<C-w>" },
		--
		-- 		-- `z` key
		-- 		{ mode = "n", keys = "z" },
		-- 		{ mode = "x", keys = "z" },
		-- 	},
		--
		-- 	clues = {
		-- 		-- Enhance this by adding descriptions for <Leader> mapping groups
		-- 		miniclue.gen_clues.square_brackets(),
		-- 		miniclue.gen_clues.builtin_completion(),
		-- 		miniclue.gen_clues.g(),
		-- 		miniclue.gen_clues.marks(),
		-- 		miniclue.gen_clues.registers(),
		-- 		miniclue.gen_clues.windows(),
		-- 		miniclue.gen_clues.z(),
		-- 	},
		--
		--     window = {
		--       delay = 250,
		--
		--       config = {
		--         width = 'auto',
		--       },
		--     },
		-- })
		local wk = require("which-key")

		wk.setup({
			preset = "helix",
			plugins = {
				marks = true,
				registers = true,
				spelling = {
					enabled = false,
					suggestions = 20,
				},
				presets = {
					operators = true,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = true,
				},
			},
			keys = {
				scroll_down = "<c-n>",
				scroll_up = "<c-p>",
			},
		})

		vim.keymap.set({ "n" }, "<leader>b?", function()
			-- wk.show({ global = false, loop = true })
		end, { noremap = true, silent = true, desc = "Show local keymaps" })

		vim.keymap.set({ "n" }, "<leader>b?", function()
			-- wk.show({ global = true, loop = true })
		end, { noremap = true, silent = true, desc = "Show global keymaps" })

		require("smear_cursor").setup({})
		require("smear_cursor").enabled = false
		require("thunder").setup({
			label = {
				style = "inline",
			},
		})
		require("window-picker").setup({
			show_prompt = false,
			hint = "floating-big-letter",
		})

		vim.keymap.set({ "n" }, "<C-w>x", function()
			local picked_window_id = require("window-picker").pick_window()
			if picked_window_id == nil then
				return
			end

			local picked_buf_id = vim.api.nvim_win_get_buf(picked_window_id)

			local cur_win_id = vim.api.nvim_get_current_win()
			local cur_buf_id = vim.api.nvim_win_get_buf(cur_win_id)

			vim.api.nvim_win_set_buf(picked_window_id, cur_buf_id)
			vim.api.nvim_win_set_buf(cur_win_id, picked_buf_id)
		end, { noremap = true, silent = true, desc = "Swap window" })

		vim.keymap.set({ "n" }, "<leader>p<C-w>", function()
			local picked_window_id = require("window-picker").pick_window()
			if picked_window_id == nil then
				return
			end
			vim.api.nvim_set_current_win(picked_window_id)
		end, { noremap = true, silent = true, desc = "Pick window" })

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
			nested = true,
			pattern = { "*" },
			callback = function(ev)
				local ts_shared = require("nvim-treesitter-textobjects.shared")
				local mappings = {
					{ symbol = "r", node = "@return", label = "return statement", outer = true, inner = true },
					{ symbol = "p", node = "@parameter", label = "parameter", outer = true, inner = true },
					{ symbol = "P", node = "@attribute", label = "attribute", outer = true, inner = true },
					{ symbol = "f", node = "@function", label = "function definition", outer = true, inner = true },
					{ symbol = "i", node = "@conditional", label = "conditional", outer = true, inner = true },
					{ symbol = "k", node = "@call", label = "function call", outer = true, inner = true },
					{ symbol = "K", node = "@class", label = "class", outer = true, inner = true },
					{ symbol = "b", node = "@block", label = "block", outer = true, inner = true },
					{ symbol = "al", node = "@assignment.lhs", label = "Assignment LHS", standalone = true },
					{ symbol = "ar", node = "@assignment.rhs", label = "Assignment RHS", standalone = true },
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
				---@class TreesitterNodeMappingSpec
				---@field symbol string
				---@field node string
				---@field label string
				---@param query_string string
				---@param mapping TreesitterNodeMappingSpec
				local function create_outer_mapping(query_string, mapping)
					if ts_shared.check_support(ev.buf, "textobjects", { query_string }) then
						vim.keymap.set({ "n", "x", "o" }, "[" .. mapping.symbol, function()
							require("nvim-treesitter-textobjects.move").goto_previous_start(query_string, "textobjects")
						end, {
							noremap = true,
							silent = true,
							desc = string.format("Previous %s start", mapping.label),
							buffer = ev.buf,
						})
						vim.keymap.set({ "n", "x", "o" }, "[" .. mapping.symbol:upper(), function()
							require("nvim-treesitter-textobjects.move").goto_previous_end(query_string, "textobjects")
						end, {
							noremap = true,
							silent = true,
							desc = string.format("Previous %s end", mapping.label),
							buffer = ev.buf,
						})
						vim.keymap.set({ "n", "x", "o" }, "]" .. mapping.symbol, function()
							require("nvim-treesitter-textobjects.move").goto_next_start(query_string, "textobjects")
						end, {
							noremap = true,
							silent = true,
							desc = string.format("Next %s start", mapping.label),
							buffer = ev.buf,
						})
						vim.keymap.set({ "n", "x", "o" }, "]" .. mapping.symbol:upper(), function()
							require("nvim-treesitter-textobjects.move").goto_next_end(query_string, "textobjects")
						end, {
							noremap = true,
							silent = true,
							desc = string.format("Next %s end", mapping.label),
							buffer = ev.buf,
						})

						vim.keymap.set({ "x", "o" }, "a" .. mapping.symbol, function()
							require("nvim-treesitter-textobjects.select").select_textobject(query_string, "textobjects")
						end, {
							noremap = true,
							silent = true,
							desc = string.format("Around %s", mapping.label),
							buffer = ev.buf,
						})
					end
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
					if mapping.standalone then
						local query_string = mapping.node
						create_outer_mapping(query_string, mapping)
					end
					if mapping.outer then
						local query_string = string.format("%s.outer", mapping.node)
						create_outer_mapping(query_string, mapping)
					end
				end
			end,
		})
		local pipe_icon = "┃"
		local signs_icons = {
			add = { text = pipe_icon },
			change = { text = pipe_icon },
			delete = { text = pipe_icon },
			topdelete = { text = pipe_icon },
			changedelete = { text = pipe_icon },
			untracked = { text = pipe_icon },
		}
		require("gitsigns").setup({
			signs = signs_icons,
			signs_staged = signs_icons,
			signcolumn = true,
			linehl = false,
			current_line_blame = true,
			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
		})

		vim.keymap.set({ "o", "x" }, "ac", function()
			require("gitsigns").select_hunk()
		end, {
			silent = true,
			noremap = true,
			desc = "Git hunk",
		})

		vim.keymap.set("n", "<leader>gsc", function()
			require("gitsigns").stage_hunk()
		end, {
			silent = true,
			noremap = true,
			desc = "Stage hunk",
		})

		vim.keymap.set("n", "<leader>gpc", function()
			require("gitsigns").preview_hunk()
		end, {
			silent = true,
			noremap = true,
			desc = "Preview hunk",
		})

		vim.keymap.set("n", "<leader>grc", function()
			require("gitsigns").reset_hunk()
		end, {
			silent = true,
			noremap = true,
			desc = "Reset hunk",
		})

		vim.keymap.set("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				require("gitsigns").nav_hunk("next")
			end
		end, {
			silent = true,
			noremap = true,
			desc = "Jump to next hunk",
		})

		vim.keymap.set("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				require("gitsigns").nav_hunk("prev")
			end
		end, {
			silent = true,
			noremap = true,
			desc = "Jump to previous hunk",
		})
		vim.keymap.set({ "n", "x" }, "g?1e", function()
			require("encoding").base64_encode()
		end, {
			silent = true,
			noremap = true,
			desc = "Base64 encode",
		})

		vim.keymap.set({ "n", "x" }, "g?1d", function()
			require("encoding").base64_decode()
		end, {
			silent = true,
			noremap = true,
			desc = "Base64 decode",
		})

		vim.keymap.set({ "n", "x" }, "g?2", function()
			require("encoding").uri_encode_or_decode()
		end, {
			silent = true,
			noremap = true,
			desc = "URI encode or decode",
		})

		vim.keymap.set({ "n", "x" }, "g?3", "g?", {
			silent = true,
			remap = true,
			desc = "ROT13 encode or decode",
		})
		local group = vim.api.nvim_create_augroup("DynamicNumber", { clear = true })

		vim.api.nvim_create_autocmd("BufWinEnter", {
			nested = true,
			group = group,
			callback = function()
				vim.wo.number = false
				vim.cmd.redraw()
			end,
		})
		vim.api.nvim_create_autocmd("CmdlineEnter", {
			nested = true,
			group = group,
			callback = function(ev)
				if ev.match == "/" or ev.match == "?" or ev.match == "=" then
					return
				end
				vim.wo.number = true
				vim.cmd.redraw()
			end,
		})

		vim.api.nvim_create_autocmd("CmdlineLeave", {
			nested = true,
			group = group,
			callback = function(ev)
				if ev.match == "/" or ev.match == "?" or ev.match == "=" then
					return
				end
				vim.wo.number = false
				vim.cmd.redraw()
			end,
		})

		vim.api.nvim_create_autocmd("ModeChanged", {
			nested = true,
			pattern = { "*:V", "*:v", "*:\22" },
			group = group,
			callback = function(ev)
				vim.wo.number = true
				vim.wo.relativenumber = true
				vim.cmd.redraw()
			end,
		})

		vim.api.nvim_create_autocmd("ModeChanged", {
			nested = true,
			pattern = { "V:*", "v:*", "\22:*" },
			group = group,
			callback = function(ev)
				vim.wo.number = false
				vim.wo.relativenumber = false
				vim.cmd.redraw()
			end,
		})

		local thunder_group = vim.api.nvim_create_augroup("thunder", { clear = true })
		vim.api.nvim_create_autocmd("CmdlineLeave", {
			nested = true,
			group = thunder_group,
			callback = function()
				if vim.v.event.abort then
					return
				end
				if not require("thunder.utils").is_search() then
					return
				end
				require("thunder").search()
			end,
		})
	end,
})

local utils = require("custom.utils")

return {
	{
		"folke/snacks.nvim",
		version = "2.x",
		priority = 1000,
		lazy = false,
		dependencies = {},
		keys = {
			{
				-- mnemonic of note
				"<leader>n",
				function()
					Snacks.scratch()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Toggle Scratch Buffer",
			},
			{
				"<leader>p<leader>n",
				function()
					Snacks.scratch.select()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Select Scratch Buffer",
			},
			{
				"<leader>pj",
				function()
					Snacks.picker.jumps()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search jumplist history",
			},
			{
				"<leader>pu",
				function()
					Snacks.picker.undo()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search undo history",
			},
			{
				"<leader>pn",
				function()
					Snacks.picker.notifications({
						confirm = { "copy", "close" },
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search notifications history",
			},
			{
				"<leader>pc",
				function()
					Snacks.picker.command_history()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search command history",
			},
			{
				"<leader>pC",
				function()
					Snacks.picker.colorschemes()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search colorschemes",
			},
			{
				"<leader>pd",
				function()
					Snacks.picker.diagnostics()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search diagnostics",
			},
			-- {
			-- 	"<leader>pl",
			-- 	function()
			-- 		-- Snacks.picker.lines()
			-- 		local items = {
			-- 			{
			-- 				text = "Sidebar layout",
			-- 				---@type LayoutRuleOpts[]
			-- 				value = {
			-- 					{
			-- 						width = 0.2,
			-- 						height = 1,
			-- 						allowed = {
			-- 							ft = { "oil" },
			-- 						},
			-- 					},
			-- 					{ width = 0.8, height = 1 },
			-- 				},
			-- 				preview = {
			-- 					text = "foo",
			-- 				},
			-- 			},
			-- 		}
			--
			-- 		-- Create and show the picker
			-- 		require("snacks").picker({
			-- 			title = "Pick a Greeting",
			-- 			items = items,
			-- 			format = "text",
			-- 			preview = "preview",
			-- 			---@param item { value: LayoutRuleOpts[]}
			-- 			confirm = function(picker, item)
			-- 				utils.open_layout(item.value)
			-- 				picker:close()
			-- 			end,
			-- 		})
			-- 	end,
			-- 	mode = { "n" },
			-- 	silent = true,
			-- 	noremap = true,
			-- 	desc = "Search lines in buffer",
			-- },
			{
				"<leader>p<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git Status",
			},
			{
				"<leader>p<leader>gZ",
				function()
					Snacks.picker.git_stash()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git Stash",
			},
			{
				"<leader>p<leader>gc",
				function()
					Snacks.picker.git_diff()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git Hunks",
			},
			{
				"<leader>gl",
				function()
					vim.cmd("DiffviewFileHistory %")
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Git log of the current file",
			},
			{
				"<leader>p<leader>gl",
				function()
					Snacks.picker.pick({
						source = "enhanced_git_log",
                        notify = false,
						format = "git_log",
						preview = "git_show",
						confirm = "diffview",
						live = true,
						supports_live = true,
						sort = { fields = { "score:desc", "idx" } },
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git log",
			},
			{
				"<leader>pw",
				function()
					Snacks.picker.grep({
						hidden = true,
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Grep in files",
			},
			{
				"<leader>pW",
				function()
					local bufname = vim.api.nvim_buf_get_name(0)
					local dir = vim.fn.fnamemodify(bufname, ":p:h")
					Snacks.picker.grep({
						hidden = true,
						title = string.format("Grep [%s]", dir),
						dirs = { dir },
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Grep in files under the buffer's directory",
			},
			{
				"<leader>pw",
				function()
					Snacks.picker.grep_word({
						hidden = true,
					})
				end,
				mode = { "x" },
				silent = true,
				noremap = true,
				desc = "Combined Grep in files",
			},
			{
				"<leader>p<leader>gb",
				function()
					Snacks.picker.git_branches({
						confirm = "diffview",
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Search Git branches",
			},
			{
				"<leader>gx",
				function()
					vim.ui.select({ "file", "branch", "permalink", "commit" }, {
						prompt = "Gitbrowse resource type",
					}, function(choice)
						if not choice then
							return
						end
						Snacks.gitbrowse.open({
							what = choice,
						})
					end)
				end,
				mode = { "n", "x" },
				silent = true,
				noremap = true,
				desc = "Browse files in remote Git server",
			},
			{
				"<leader>pf",
				function()
					Snacks.picker.files({
						hidden = true,
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Explore files",
			},
			{
				"<leader>ps",
				function()
					Snacks.picker.lsp_symbols({})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Explore LSP symbols",
			},
			{
				"<leader>pr",
				function()
					Snacks.picker.resume()
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Resume last picker",
			},
		},
		config = function()
			local picker_keys = {
				["/"] = "toggle_focus",
				["<2-LeftMouse>"] = "confirm",
				["<leader>k"] = { "qflist", mode = { "n" } },
				["<CR>"] = { "confirm", mode = { "n", "i" } },
				["<Down>"] = { "list_down", mode = { "i", "n" } },
				["<Up>"] = { "list_up", mode = { "i", "n" } },
				["<Esc>"] = "close",
				["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
				["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
				["G"] = "list_bottom",
				["gg"] = "list_top",
				["j"] = "list_down",
				["k"] = "list_up",
				["q"] = "close",
                ["<a-p>"] = "toggle_preview",
                ["<a-w>"] = "cycle_win",
				["<c-w>H"] = "layout_left",
				["<c-w>J"] = "layout_bottom",
				["<c-w>K"] = "layout_top",
				["<c-w>L"] = "layout_right",
				["?"] = function()
					require("which-key").show({ global = true, loop = true })
				end,
			}

			local config_dir = vim.fn.stdpath("config")
			---@cast config_dir string
			require("snacks").setup({
				toggle = { enabled = true },
				gitbrowse = {
					enabled = true,
					url_patterns = {
						["visualstudio%.com"] = {
							branch = "?version=GB{branch}",
							-- FIXME only line row number is returned, we need both row and column to get the highlight in ado https://github.com/folke/snacks.nvim/blob/bfe8c26dbd83f7c4fbc222787552e29b4eccfcc0/lua/snacks/gitbrowse.lua#L177C24-L177C49
							file = "?path={file}&version=GB{branch}&line={line_start}&lineEnd={line_end}&lineStartColumn=1&lineEndColumn=999&lineStyle=plain&_a=contents",
							permalink = "?path={file}&version=GB{branch}&line={line_start}&lineEnd={line_end}&lineStartColumn=1&lineEndColumn=999&lineStyle=plain&_a=contents",
							commit = "/commit/{commit}",
						},
					},
				},
				bigfile = { enabled = false },
				scratch = { enabled = true },
				image = { enabled = true },
				dashboard = {
					enabled = false,
					sections = {
						{
							section = "terminal",
							cmd = string.format(
								"chafa %s --format symbols --symbols block --size 60x17",
								vim.fs.joinpath(config_dir, "assets", "flag_of_british_hk.png")
							),
							height = 17,
							padding = 1,
						},
						{
							pane = 2,
							{
								icon = " ",
								title = "Recent Files",
								section = "recent_files",
								limit = 3,
								indent = 2,
								padding = { 2, 2 },
							},
							{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
							{ section = "startup" },
						},
					},
				},
				picker = {
					sources = {
						enhanced_git_log = require("custom.enhanced_git_log_source").enhanced_git_log,
					},
					enabled = true,
					ui_select = true,
					---@class snacks.picker.matcher.Config
					matcher = {
						cwd_bonus = true,
					},
					layout = {
						cycle = true,
						preset = function()
							return vim.o.columns >= 120 and "default" or "vertical"
						end,
					},
					actions = {
						diffview = function(picker, item)
							picker:close()
							if not item then
								return
							end

							local what = item.branch or item.commit --[[@as string?]]

							if not what then
								return
							end

							vim.cmd(string.format("DiffviewOpen %s", what))
						end,
					},
					win = {
						input = {
							keys = picker_keys,
						},
						list = {
							keys = vim.tbl_extend("force", picker_keys, {
								["zb"] = "list_scroll_bottom",
								["zt"] = "list_scroll_top",
								["zz"] = "list_scroll_center",
							}),
						},
					},
				},
				scroll = {
					enabled = true,
					animate = {
						duration = { step = 10, total = 100 },
						easing = "linear",
					},
				},
				input = {
					enabled = true,
				},
				notifier = {
					enabled = true,
					style = "fancy",
					level = vim.log.levels.INFO,
				},
				indent = {
					-- TODO enable later, after is it working with DiffviewOpen without error
					enabled = true,
				},
				words = { enabled = false },
				styles = {
					notification = {
						wo = {
							wrap = true,
						},
					},
				},
			})

			vim.api.nvim_create_user_command("Zen", function ()
                Snacks.notifier.hide() -- hide all notifications, but keep Snacks.notifier there
			end, {
				desc = "Reduce distraction",
			})


            vim.keymap.set('n', '<space>sg', function()
  Snacks.picker.pick {
    format = 'file',
    notify = false, -- Also prevents error when searching with additional arguments
    show_empty = true,
    live = true,
    supports_live = true,
    -- hidden = true,
    -- ignored = true,
    ---@param opts snacks.picker.grep.Config
    finder = function(opts, ctx)
      local cmd = 'ast-grep'
      local args = { 'run', '--color=never', '--json=stream' }
      if vim.fn.has 'win32' == 1 then
        cmd = 'sg'
      end
      if opts.hidden then
        table.insert(args, '--no-ignore=hidden')
      end
      if opts.ignored then
        table.insert(args, '--no-ignore=vcs')
      end
      local pattern, pargs = Snacks.picker.util.parse(ctx.filter.search)
      table.insert(args, string.format('--pattern=%s', pattern))
      vim.list_extend(args, pargs)
      return require('snacks.picker.source.proc').proc({
        opts,
        {
          cmd = cmd,
          args = args,
          transform = function(item)
            local entry = vim.json.decode(item.text)
            if vim.tbl_isempty(entry) then
              return false
            else
              local start = entry.range.start
              item.cwd = svim.fs.normalize(opts and opts.cwd or vim.uv.cwd() or '.') or nil
              item.file = entry.file
              item.line = entry.text
              item.pos = { tonumber(start.line) + 1, tonumber(start.column) }
            end
          end,
        },
      }, ctx)
    end,
  }
end)
		end,
	},
}

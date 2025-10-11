local utils = require("custom.utils")
local uv = vim.uv or vim.loop
---@param ... (string|string[]|nil)
local function git_args(...)
	local ret = { "-c", "core.quotepath=false" } ---@type string[]
	for i = 1, select("#", ...) do
		local arg = select(i, ...)
		vim.list_extend(ret, type(arg) == "table" and arg or { arg })
	end
	return ret
end
---@class EnhancedGitLogOpts
---@field author? string filter commits by author

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
				"<leader>px",
				function()
					Snacks.picker.pick({
						source = "enhanced_git_log",
						format = "git_log",
						preview = "git_show",
						confirm = "diffview",
						live = true,
						sort = { fields = { "score:desc", "idx" } },
					})
				end,
				mode = { "n" },
				silent = true,
				noremap = true,
				desc = "Test custom picker",
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
					Snacks.picker.git_log({
						confirm = "diffview",
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
			-- TODO can't figure out a way to picker directories
			-- checked https://github.com/folke/snacks.nvim/blob/bc0630e43be5699bb94dadc302c0d21615421d93/lua/snacks/picker/source/files.lua#L184, but cannot get and pass ctx here
			-- {
			-- 	"<leader>pF",
			-- 	function()
			-- 		Snacks.picker.pick({
			--                      source = "procs",
			--                      cmd = "fd",
			--                      args = { "-t", "d" },
			--                  })
			-- 	end,
			-- 	mode = { "n" },
			-- 	silent = true,
			-- 	noremap = true,
			-- 	desc = "Explore all directories",
			-- },
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
				desc = "Resume last picker",
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
						-- https://github.com/folke/snacks.nvim/blob/dae80fb393f712bd7352a20f9185f5e16b69f20f/lua/snacks/picker/source/git.lua#L90
						enhanced_git_log = {
							---@param opts EnhancedGitLogOpts
							---@type snacks.picker.finder
							finder = function(opts, ctx)
                                if ctx.filter.search == "" then
                                    return function () end
                                end
                                local input = ctx.filter.search
                                print(input)

								local args = git_args(
									"log",
                                    ctx.filter.search,
									"--pretty=format:%h %s (%ch)",
									"--abbrev-commit",
									"--decorate",
									"--date=short",
									"--color=never",
									"--no-show-signature",
									"--no-patch"
								)

								if opts.author then
									table.insert(args, "--author=" .. opts.author)
								end

								local Proc = require("snacks.picker.source.proc")

								return function(cb)
									Proc.proc({
										opts,
										{
											cmd = "git",
											args = args,
											---@param item snacks.picker.finder.Item
											transform = function(item)
												local commit, msg, date = item.text:match("^(%S+) (.*) %((.*)%)$")
												if not commit then
                                                    -- TODO wait for debounce to be avaliable in Neovim, then trigger this notification with debounce
													-- Snacks.notify.error(
													-- 	("failed to parse log item:\n%q"):format(item.text)
													-- )
													return false
												end
												item.commit = commit
												item.msg = msg
												item.date = date
											end,
										},
									}, ctx)(cb)
								end
							end,
						},
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
							keys = picker_keys,
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
		end,
	},
}

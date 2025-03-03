-- # Config principle
-- 1. When defining mappings are related with operators and textobjects, follow the verb -> noun convention, so we don't have to go into visual mode all the time to get things done like in Helix
-- 2. When defining mappings that are not related with operators and textobjects, follow the noun -> verb convention, as there could be conflicting actions between different topics, making mappings definition difficult
-- 3. Following the default Vim's mapping semantic and enhance it

-- ## Operators
-- REF https://neovim.io/doc/user/motion.html#operator
-- We only use c, d, y, p, >, <, <leader>c, gq and ~ operator for manipulating textobjects
-- And finally gx for opening url in neovim
-- for deleting without polluting the current register, use blackhold register _, for example "_dd

-- Use space as leader key
vim.g.mapleader = " "
-- Need to find plugin to improve mouse experience, to create something like vscode
-- FIXME vim.opt is overriding value in vim.o. This is likely a bug in Neovim
vim.o.mouse = "a"
vim.o.mousefocus = true

-- NOTE hide colorscheme provided by Neovim in colorscheme picker
vim.opt.wildignore:append({
	"blue.vim",
	"darkblue.vim",
	"delek.vim",
	"desert.vim",
	"elflord.vim",
	"evening.vim",
	"industry.vim",
	"habamax.vim",
	"koehler.vim",
	"lunaperche.vim",
	"morning.vim",
	"murphy.vim",
	"pablo.vim",
	"peachpuff.vim",
	"quiet.vim",
	"ron.vim",
	"shine.vim",
	"slate.vim",
	"sorbet.vim",
	"retrobox.vim",
	"torte.vim",
	"wildcharm.vim",
	"zaibatsu.vim",
	"zellner.vim",
	"default.vim",
	"vim.lua",
})
vim.opt.background = "dark"

local ERROR_ICON = " "
local WARNING_ICON = " "
local INFO_ICON = " "
local HINT_ICON = "󰌶 "

vim.cmd("filetype on")
vim.filetype.add({
	extension = {
		http = "http",
	},
})

---@param filetype string A Nvim filetype
---@return number
local function find_tab_with_filetype(filetype)
	for i, tab_id in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab_id)) do
			local buf = vim.api.nvim_win_get_buf(win)
			local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
			if buf_ft == filetype then
				return i
			end
		end
	end
	return -1
end

local modes = { "n", "v", "c" }

-- REF https://unix.stackexchange.com/a/637223/467987
vim.keymap.set({ "t" }, "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Back to normal mode" })
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		-- vim.api.nvim_buf_set_option(ev.buf, "number", false)
		-- vim.api.nvim_buf_set_option(ev.buf, "relativenumber", false)
		-- vim.api.nvim_buf_set_option(ev.buf, "filetype", "terminal")
		vim.api.nvim_set_option_value("number", false, { scope = "local" })
		vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
		vim.api.nvim_set_option_value("filetype", "terminal", { scope = "local" })

		local shell_cmd = vim.opt.shell:get()
		-- zsh
		local _ = shell_cmd
			-- match substring before the first space
			:match("^(%S+)")
			-- match the base"me of a path
			:match("([^/]+)$")
	end,
})
vim.keymap.set({ "c", "n" }, "q:", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "c", "n" }, "q/", "<Nop>", { noremap = true, silent = true })
vim.keymap.set({ "c", "n" }, "q?", "<Nop>", { noremap = true, silent = true })

-- vim.keymap.set({ "n" }, "[z", "zj", { silent = true, noremap = true, desc = "Jump to previous fold" })
-- vim.keymap.set({ "n" }, "]z", "zk", { silent = true, noremap = true, desc = "Jump to next fold" })

-- NOTE no longer need these bindings, just use register correctly with "+
-- vim.keymap.set(modes, "<leader>y", '"+y', { silent = true, noremap = true, desc = "Yank text to system clipboard" })
-- vim.keymap.set(modes, "<leader>p", '"+p', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
-- vim.keymap.set(modes, "<leader>P", '"+P', { silent = true, noremap = true, desc = "Paste text from system clipboard" })
-- vim.keymap.set(
-- 	modes,
-- 	"<leader>d",
-- 	'"+d',
-- 	{ silent = true, noremap = true, desc = "Delete text and yank to system clipboard" }
-- )

-- NOTE make Y consistent with how C and D behave for changing or deleting to the end of the line.
vim.keymap.set(modes, "Y", "y$", {
	silent = true,
	noremap = true,
	desc = "Yanks to the end of the line.",
})

vim.keymap.set(modes, "<leader>wv", function()
	vim.cmd("vsplit")
end, { silent = true, noremap = true, desc = "Create a vertical split" })
vim.keymap.set(modes, "<leader>ws", function()
	vim.cmd("split")
end, { silent = true, noremap = true, desc = "Create a horizontal split" })
vim.keymap.set(modes, "<leader>wq", function()
	vim.cmd("quit")
end, { silent = true, noremap = true, desc = "Close a split" })
vim.keymap.set(modes, "<leader>wl", "<C-w>l", { silent = true, noremap = true, desc = "Navigate to left split" })
vim.keymap.set(modes, "<leader>wh", "<C-w>h", { silent = true, noremap = true, desc = "Navigate to right split" })
vim.keymap.set(modes, "<leader>wk", "<C-w>k", { silent = true, noremap = true, desc = "Navigate to top split" })
vim.keymap.set(modes, "<leader>wj", "<C-w>j", { silent = true, noremap = true, desc = "Navigate to bottom split" })

vim.keymap.set(modes, "<leader>tv", function()
	vim.cmd("tabnew")
end, { silent = true, noremap = true, desc = "Create a new tab" })
vim.keymap.set(
	modes,
	"<leader>tl",
	"gt",
	{ silent = true, noremap = true, desc = "Go to the next tab page. Wraps around from the last to the first one." }
)
vim.keymap.set(modes, "<leader>th", "gT", {
	silent = true,
	noremap = true,
	desc = "Go to the previous tab page. Wraps around from the first one to the last one.",
})
vim.keymap.set(modes, "<leader>tq", function()
	vim.cmd("tabclose")
end, { silent = true, noremap = true, desc = "Close a tab" })
for i = 1, 9 do
	vim.keymap.set({ "n" }, "<leader>t" .. i, function()
		vim.cmd(string.format("tabn %s", i))
	end, { noremap = true, silent = true, desc = string.format("Jump to tab %s", i) })
end

vim.keymap.set(modes, "<leader>bq", function()
	Snacks.bufdelete.delete()
end, { silent = true, noremap = true, desc = "Delete current buffer" })
vim.keymap.set(modes, "<leader>bl", function()
	vim.cmd("bnext")
end, { silent = true, noremap = true, desc = "Go to next buffer" })
vim.keymap.set(modes, "<leader>bh", function()
	vim.cmd("bprev")
end, { silent = true, noremap = true, desc = "Go to previous buffer" })
for i = 1, 9 do
	vim.keymap.set({ "n" }, "<leader>b" .. i, function()
		vim.cmd(string.format("LualineBuffersJump %s", i))
	end, { noremap = true, silent = true, desc = string.format("Jump to buffer %s", i) })
end

--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
vim.keymap.set(
	{ "i" },
	"<Esc>",
	"<Esc>`^",
	{ silent = true, noremap = true, desc = "Prevent the cursor move back when returning to normal mode" }
)

vim.keymap.set("v", "p", "pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set("v", "P", "Pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set(
	"i",
	"<esc>",
	"<esc>`^",
	{ silent = true, noremap = true, desc = "Revert back to previous cursor position" }
)

--Quit default plugin early
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_man = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
-- silent provider warning
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local global_options = {
	{ "encoding", "UTF-8" },
	{ "fileencoding", "UTF-8" },
	{ "termguicolors", true },
	{ "timeoutlen", 400 },
	{ "ttimeoutlen", 0 },
	{ "updatetime", 300 },
	{ "showmode", false },
	{ "backup", false },
	{ "writebackup", false },
	{ "cmdheight", 1 },
	{ "showmatch", true },
	{ "splitbelow", true },
	{ "splitright", true },
	{ "lazyredraw", true },
	{ "ignorecase", true },
	{ "smartcase", true },
	{ "magic", true },
	{ "grepprg", "rg --vimgrep --no-heading --smart-case" },
	{ "grepformat", "%f:%l:%c:%m" },
	{ "wildmenu", true },
	{ "wildmode", "longest:full,full" },
	-- NOTE Make it false, so once a buffer is closed with :q, the LSP message will be removed as well
	{ "hidden", false },
	{ "cursorline", true },
	-- NOTE disable cursorline in background as it would be shown in inactive split as well, not really useful when using splits
	{ "cursorlineopt", "number" },
}

for _, option in ipairs(global_options) do
	vim.opt[option[1]] = option[2]
end

local window_options = {
	{ "wrap", true },
	{ "linebreak", true },
	{ "number", true },
	{ "relativenumber", true },
	-- at most 2 columns for left hand signcolumn
	{ "signcolumn", "auto:2" },
	{ "scrolloff", 8 },
	-- Ensure tilde signs are not show at the end of buffer, and use diagonal as filler for diff
	-- REF https://github.com/sindrets/diffview.nvim/issues/35#issuecomment-871455517
	{ "fillchars", "diff:╱,eob: " },
}

for _, option in ipairs(window_options) do
	vim.o[option[1]] = option[2]
	vim.wo[option[1]] = option[2]
end

local buffer_options = {
	{ "expandtab", true },
	{ "autoindent", true },
	{ "smartindent", false },
	{ "grepprg", "rg --vimgrep --no-heading --smart-case" },
	{ "undofile", true },
	{ "shiftwidth", 4 },
	{ "tabstop", 4 },
}

for _, option in ipairs(buffer_options) do
	vim.o[option[1]] = option[2]
	vim.bo[option[1]] = option[2]
end

if vim.wo.diff then
	-- disable wrap so filler line will always align with changes
	vim.o.wrap = false
end

vim.keymap.set("n", "[h", "[c", { noremap = true, silent = true, desc = "Jump to the previous hunk" })
vim.keymap.set("n", "]h", "]c", { noremap = true, silent = true, desc = "Jump to the next hunk" })

-- NOTE support clipboard in WSL, https://neovim.io/doc/user/provider.html#clipboard-wsl
if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "/mnt/c/Windows/System32/clip.exe",
			["*"] = "/mnt/c/Windows/System32/clip.exe",
		},
		paste = {
			["+"] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = '/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end
-- TODO how can I always open helpfiles in a tab?

---@param mode "visual" | nil
local function select_area_for_operator(mode)
	local start_pos, end_pos

	if mode == "visual" then
		start_pos = vim.fn.getpos(".")
		end_pos = vim.fn.getpos("v")
	else
		start_pos = vim.fn.getpos("'[")
		end_pos = vim.fn.getpos("']")
	end

	local start_row = start_pos[2]
	local start_col = start_pos[3]
	local end_row = end_pos[2]
	local end_col = end_pos[3]

	if end_row > start_row then
		return start_row, start_col, end_row, end_col
	end

	if start_row > end_row then
		return end_row, end_col, start_row, start_col
	end

	if end_col > start_col then
		return start_row, start_col, end_row, end_col
	end
	return end_row, end_col, start_row, start_col
end

---@param mode "visual"|nil
local function base64_encode_operator(mode)
	local start_row, start_col, end_row, end_col = select_area_for_operator(mode)

	local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})

	local text = table.concat(lines, "\n")

	local encoded = vim.base64.encode(text)

	vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, { encoded })
end
---@param mode "visual"|nil
local function base64_decode_operator(mode)
	local start_row, start_col, end_row, end_col = select_area_for_operator(mode)

	local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})

	local text = table.concat(lines, "\n")

	local decoded = vim.base64.decode(text)

	vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, { decoded })
end
---@param mode "visual"|nil
local function uri_encode_operator(mode)
	local start_row, start_col, end_row, end_col = select_area_for_operator(mode)

	local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})

	local text = table.concat(lines, "\n")

	local encoded = vim.uri_encode(text, "rfc3986")

	vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, { encoded })
end
---@param mode "visual"|nil
local function uri_decode_operator(mode)
	local start_row, start_col, end_row, end_col = select_area_for_operator(mode)

	local lines = vim.api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})

	local text = table.concat(lines, "\n")

	local decoded = vim.uri_decode(text)

	vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, { decoded })
end

vim.keymap.set("n", "<leader>ee1", function()
	vim.o.opfunc = "v:lua.base64_encode_operator"
	return "g@"
end, { noremap = true, silent = true, desc = "Base64 encode", expr = true })
vim.keymap.set("x", "<leader>ee1", function()
	base64_encode_operator("visual")
end, { noremap = true, silent = true, desc = "Base64 encode" })
_G.base64_encode_operator = base64_encode_operator

vim.keymap.set({ "n" }, "<leader>ed1", function()
	vim.o.opfunc = "v:lua.base64_decode_operator"
	return "g@"
end, { noremap = true, silent = true, desc = "Base64 decode", expr = true })
vim.keymap.set("x", "<leader>ed1", function()
	base64_decode_operator("visual")
end, { noremap = true, silent = true, desc = "Base64 decode" })
_G.base64_decode_operator = base64_decode_operator

vim.keymap.set("n", "<leader>ee2", function()
	vim.o.opfunc = "v:lua.uri_encode_operator"
	return "g@"
end, { noremap = true, silent = true, desc = "URI encode", expr = true })
vim.keymap.set("x", "<leader>ee2", function()
	base64_encode_operator("visual")
end, { noremap = true, silent = true, desc = "URI encode" })
_G.uri_encode_operator = uri_encode_operator

vim.keymap.set({ "n" }, "<leader>ed2", function()
	vim.o.opfunc = "v:lua.uri_decode_operator"
	return "g@"
end, { noremap = true, silent = true, desc = "URI decode", expr = true })
vim.keymap.set("x", "<leader>ed2", function()
	base64_decode_operator("visual")
end, { noremap = true, silent = true, desc = "URI decode" })
_G.uri_decode_operator = uri_decode_operator

local function accept_change_operator(mode)
	local start_row, start_col, end_row, end_col = select_area_for_operator(mode)

	---@alias AcceptChangeDiffBuffer {buf_id: number, buf_name: string}
	---@type AcceptChangeDiffBuffer[]
	local diff_buffers = vim.iter(vim.api.nvim_list_wins())
		:filter(function(win_id)
			return vim.api.nvim_win_get_option(win_id, "diff")
		end)
		:map(function(win_id)
			local buf_id = vim.api.nvim_win_get_buf(win_id)
			local buf_name = vim.api.nvim_buf_get_name(buf_id)
			return { buf_id = buf_id, buf_name = buf_name }
		end)
		:totable()
	vim.ui.select(
		vim
			.iter(diff_buffers)
			--- @param buf AcceptChangeDiffBuffer
			:map(function(buf)
				return buf.buf_name
			end)
			:totable(),
		{ prompt = "Accept hunk from" },
		function(choice)
			if choice == nil then
				return
			end

			--- @param buf AcceptChangeDiffBuffer
			--- @type AcceptChangeDiffBuffer | nil
			local selected_buf = vim.iter(diff_buffers):find(function(buf)
				return buf.buf_name == choice
			end)
			if selected_buf == nil then
				vim.notify("Cannot find chosen buffer, aborting", vim.log.levels.WARN)
				return
			end
			local curr_buf_id = vim.api.nvim_get_current_buf()
			if selected_buf.buf_id == curr_buf_id then
				-- accepted hunk in the current buffer, make other buffers accept this hunk
				vim
					.iter(diff_buffers)
					:filter(function(buf)
						return buf ~= curr_buf_id
					end)
					--- @param buf AcceptChangeDiffBuffer
					:each(function(buf)
						vim.api.nvim_buf_call(buf.buf_id, function()
							vim.cmd(string.format("%d,%ddiffget %s", start_row, end_row, curr_buf_id))
						end)
					end)
			else
				-- accepted hunk of the selected buffer, make current buffer accept this hunk
				vim.cmd(string.format("%d,%ddiffget %s", start_row, end_row, selected_buf.buf_id))
			end
		end
	)
end

vim.keymap.set("x", "<leader>hp", function()
	accept_change_operator("visual")
end, { noremap = true, silent = true, desc = "Paste hunk" })
_G.accept_change_operator = accept_change_operator

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	rocks = {
		hererocks = false,
	},
	spec = {
		-- Where to check themes
		-- https://vimcolorschemes.com/i/trending/b.dark
		-- https://github.com/mcchrish/vim-no-color-collections
		-- Too high constrast, but seems to have a good design theory
		{
			"nuvic/flexoki-nvim",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"flexoki.lua",
					-- don't look good in dark theme
					"flexoki-moon.lua",
				})
			end,
		},
		{ "miikanissi/modus-themes.nvim", lazy = true, enabled = false },
		-- comment is too dark when using lackluster
		{
			"slugbyte/lackluster.nvim",
			enabled = false,
			lazy = true,
		},
		-- a warmer Nord variant
		{
			"AlexvZyl/nordic.nvim",
			lazy = true,
		},
		{
			"thesimonho/kanagawa-paper.nvim",
			lazy = true,
		},
		{
			-- single accent color customizable theme, better than darkvoid
			"wnkz/monoglow.nvim",
			init = function()
				vim.opt.wildignore:append({
					"monoglow.lua",
					"monoglow-void.lua",
					"monoglow-lack.lua",
				})
			end,
			config = function()
				require("monoglow").setup({
					on_colors = function() end,
					on_highlights = function() end,
				})
			end,
			lazy = true,
		},
		{
			"alexxGmZ/e-ink.nvim",
			lazy = true,
			init = function()
				vim.opt.background = "dark"
			end,
			config = function()
				-- NOTE somehow defining in init does not work, defining again
				vim.opt.background = "dark"
				require("e-ink").setup()
			end,
		},
		{
			"rose-pine/neovim",
			name = "rose-pine",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"rose-pine.lua",
					"rose-pine-dawn.lua",
				})
			end,
		},
		{
			"projekt0n/github-nvim-theme",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"github_dark.vim",
					"github_dark_default.vim",
					"github_dark_tritanopia.vim",
					"github_dark_high_contrast.vim",
					"github_dark_dimmed.vim",
					"github_light.vim",
					"github_light_default.vim",
					"github_light_tritanopia.vim",
					"github_light_colorblind.vim",
					"github_light_high_contrast.vim",
				})
			end,
		},
		{
			"EdenEast/nightfox.nvim",
			lazy = true,
			init = function()
				vim.opt.wildignore:append({
					"dawnfox.vim",
					"dayfox.vim",
					"nightfox.vim",
				})
			end,
		},
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			requires = { "nvim-tree/nvim-web-devicons" },
			init = function()
				vim.g.tokyonight_style = "moon"
				vim.cmd.colorscheme("tokyonight")
				vim.opt.wildignore:append({
					"tokyonight.lua",
					"tokyonight-night.lua",
					"tokyonight-day.lua",
				})
			end,
		},
		{
			"gbprod/substitute.nvim",
			keys = {
				-- By default, s is a useless synonym of cc
				-- {
				-- 	"s",
				-- 	function()
				-- 		require("substitute").operator()
				-- 	end,
				-- 	mode = { "n" },
				-- 	silent = true,
				-- 	noremap = true,
				-- 	desc = "Substitute",
				-- },
				-- {
				-- 	"ss",
				-- 	function()
				-- 		require("substitute").line()
				-- 	end,
				-- 	mode = { "n" },
				-- 	silent = true,
				-- 	noremap = true,
				-- 	desc = "Substitute line",
				-- },
				-- {
				-- 	"S",
				-- 	function()
				-- 		require("substitute").eol()
				-- 	end,
				-- 	mode = { "n" },
				-- 	silent = true,
				-- 	noremap = true,
				-- 	desc = "Substitute EOL",
				-- },
				-- {
				-- 	"s",
				-- 	function()
				-- 		require("substitute").visual()
				-- 	end,
				-- 	mode = { "x" },
				-- 	silent = true,
				-- 	noremap = true,
				-- 	desc = "Substitute",
				-- },
				{
					"x",
					function()
						require("substitute.exchange").operator()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Exchange",
				},
				{
					"x",
					function()
						require("substitute.exchange").visual()
					end,
					mode = { "x" },
					silent = true,
					noremap = true,
					desc = "Exchange",
				},
				{
					"xx",
					function()
						require("substitute.exchange").line()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Exchange line",
				},
				{
					"xc",
					function()
						require("substitute.exchange").cancel()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Cancel Exchange",
				},
			},
			opts = {},
		},
		{
			"Bekaboo/dropbar.nvim",
			version = "12.0.1",
			event = { "VeryLazy" },
			dependencies = { "nvim-tree/nvim-web-devicons", "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("dropbar").setup({})
			end,
		},
		{
			"jackplus-xyz/player-one.nvim",
			enabled = false,
			opts = {
				is_enabled = true,
				debug = true,
			},
		},
		{
			"olimorris/codecompanion.nvim",
			cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
			event = { "VeryLazy" },
			config = function()
				require("codecompanion").setup({
					-- https://codecompanion.olimorris.dev/configuration/adapters.html#changing-a-model
					adapters = {
						gemini = function()
							return require("codecompanion.adapters").extend("gemini", {
								schema = {
									model = {
										default = "gemini-2.0-flash",
									},
								},
							})
						end,
					},
					strategies = {
						inline = {
							adapter = "gemini",
						},
						keymaps = {
							accept_change = {
								modes = { n = "ga" },
								description = "Accept the suggested change",
							},
							reject_change = {
								modes = { n = "gr" },
								description = "Reject the suggested change",
							},
						},
					},
					display = {
						diff = {
							enabled = true,
							close_chat_at = 240,
							layout = "vertical",
							opts = {
								"internal",
								"filler",
								"closeoff",
								"algorithm:patience",
								"followwrap",
								"linematch:120",
							},
							provider = "default",
						},
					},
				})
			end,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
		},
		{
			"sphamba/smear-cursor.nvim",
			event = { "CursorHold" },
			opts = {},
		},
		{
			"kevinhwang91/nvim-ufo",
			version = "1.4.0",
			dependencies = { "kevinhwang91/promise-async" },
			cmd = {
				"UfoEnable",
				"UfoDisable",
				"UfoInspect",
				"UfoAttach",
				"UfoDetach",
				"UfoEnableFold",
				"UfoDisableFold",
			},
			keys = {
				{
					"zR",
					function()
						require("ufo").openAllFolds()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open all folds",
				},
				{
					"zM",
					function()
						require("ufo").closeAllFolds()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Close all folds",
				},
			},
			event = "VeryLazy",
			init = function()
				vim.o.foldcolumn = "0"
				vim.o.foldlevel = 99
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true
			end,
			config = function()
				require("ufo").setup({
					open_fold_hl_timeout = 500,
					close_fold_kinds_for_ft = { default = {} },
					enable_get_fold_virt_text = false,
					provider_selector = function()
						return { "treesitter", "indent" }
					end,
					preview = {
						win_config = {
							border = "rounded",
							winblend = 12,
							winhighlight = "Normal:Normal",
							maxheight = 20,
						},
						mappings = {
							close = "q",
						},
					},
				})
			end,
		},
		{
			"saghen/blink.cmp",
			event = "InsertEnter",
			dependencies = { "L3MON4D3/LuaSnip", version = "v2.*" },
			version = "0.13.0",
			opts = {
				keymap = {
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
					["<Char-0xAC>"] = { "select_next", "fallback" },
					["<C-p>"] = { "select_prev", "fallback" },
					["<Char-0xAB>"] = { "select_prev", "fallback" },
					["<CR>"] = { "accept", "fallback" },
					-- NOTE mimick the behavior for vscode
					["<S-Tab>"] = { "select_prev", "fallback" },
					["<Tab>"] = { "select_next", "fallback" },
				},

				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},

				snippets = { preset = "luasnip" },

				sources = {
					default = { "lsp", "path", "snippets", "buffer", "omni" },
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
						auto_show = function(ctx)
							return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
						end,
					},
					keyword = { range = "full" },
					documentation = {
						auto_show = true,
					},
				},
				signature = { enabled = true },
				fuzzy = {
					prebuilt_binaries = {},
				},
			},
		},
		{
			"xemptuous/sqlua.nvim",
			cmd = "SQLua",
			config = function()
				require("sqlua").setup({
					keybinds = {
						execute_query = "<cr>",
						activate_db = "<cr>",
					},
				})
			end,
		},
		-- {
		-- 	"folke/persistence.nvim",
		-- 	version = "3.1.0",
		-- 	event = "BufReadPre",
		-- 	keys = {
		-- 		-- Load the session for the current directory
		-- 		{
		-- 			"<leader>qs",
		-- 			function()
		-- 				require("persistence").load()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Load session for current directory",
		-- 		},
		--
		-- 		-- Select a session to load
		-- 		{
		-- 			"<leader>qS",
		-- 			function()
		-- 				require("persistence").select()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Select a session to load",
		-- 		},
		--
		-- 		-- Load the last session
		-- 		{
		-- 			"<leader>ql",
		-- 			function()
		-- 				require("persistence").load({ last = true })
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Load the last session",
		-- 		},
		--
		-- 		-- Stop Persistence => session won't be saved on exit
		-- 		{
		-- 			"<leader>qd",
		-- 			function()
		-- 				require("persistence").stop()
		-- 			end,
		-- 			mode = { "n" },
		-- 			desc = "Stop Persistence (no save on exit)",
		-- 		},
		-- 	},
		-- 	opts = {
		-- 		dir = vim.fn.stdpath("state") .. "/sessions/",
		-- 		need = 1,
		-- 		branch = true,
		-- 	},
		-- },
		{
			"yorickpeterse/nvim-window",
			commit = "93af78311e53919a0b13d1bf6d857880bb0b975d",
			keys = {
				{
					"<leader>wf",
					function()
						require("nvim-window").pick()
					end,
					silent = true,
					noremap = true,
					desc = "Jump to window",
				},
			},
			config = function()
				local chars = {} -- a list from a-z
				for i = 97, 122 do
					table.insert(chars, string.char(i))
				end
				require("nvim-window").setup({
					chars = chars,
					normal_hl = "Normal",
					hint_hl = "Bold",
					border = "single",
					render = "float",
				})
			end,
		},
		{
			"chentoast/marks.nvim",
			event = "VeryLazy",
			commit = "bb25ae3f65f504379e3d08c8a02560b76eaf91e8",
			keys = {
				{
					"m",
					function()
						require("marks").set()
					end,
					silent = true,
					noremap = true,
					desc = "Set mark",
				},
				{
					"m,",
					function()
						require("marks").set_next()
					end,
					silent = true,
					noremap = true,
					desc = "Set next available mark",
				},
				{
					"dm",
					function()
						require("marks").delete()
					end,
					silent = true,
					noremap = true,
					desc = "Delete mark",
				},
			},
			opts = {
				default_mappings = false,
				builtin_marks = {
					-- NOTE beginning of last change. This is not reliable, as plugin such as formatter.nvim would reset its location back to line 1
					-- ".",
					"[",
					"]",
					-- beginning of last insert
					"^",
				},
				excluded_filetypes = { "fzf" },
				excluded_buftypes = { "nofile" },
			},
		},
		{
			"chrisgrieser/nvim-spider",
			keys = {
				{
					"W",
					function()
						require("spider").motion("w")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to word",
				},
				{
					"w",
					function()
						require("spider").motion("w")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to word",
				},
				{
					"e",
					function()
						require("spider").motion("e")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to end of word",
				},
				{
					"E",
					function()
						require("spider").motion("e")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump forward to end of word",
				},
				{
					"b",
					function()
						require("spider").motion("b")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump backward to word",
				},
				{
					"B",
					function()
						require("spider").motion("b")
					end,
					mode = { "n", "o", "x" },
					silent = true,
					noremap = true,
					desc = "Jump backward to word",
				},
			},
		},
		{
			"nvim-lualine/lualine.nvim",
			event = { "VeryLazy" },
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				local utility_filetypes = {
					"terminal",
					"snacks_terminal",
					"oil",
					"trouble",
					"qf",
					"DiffviewFileHistory",
					"DiffviewFiles",
					"snacks_dashboard",
					"snacks_picker_list",
					"snacks_layout_box",
					"snacks_picker_input",
					"snacks_win_backdrop",
					"NeogitStatus",
					"NeogitCommitView",
					"NeogitStashView",
					"NeogitConsole",
					"NeogitLogView",
					"NeogitDiffView",
				}
				require("lualine").setup({
					options = {
						theme = "auto",
						component_separators = "",
						section_separators = "",
						disabled_filetypes = {
							winbar = utility_filetypes,
							inactive_winbar = utility_filetypes,
						},
						always_show_tabline = true,
						globalstatus = true,
					},
					tabline = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {
							{
								"buffers",
								mode = 0,
								icons_enabled = true,
								max_length = function()
									return vim.o.columns / 2
								end,
								filetype_names = {
									checkhealth = "Healthcheck",
								},
								symbols = {
									modified = "[+]",
									alternate_file = "",
								},
							},
						},
						lualine_x = {
							{
								"tabs",
								mode = 0,
								max_length = function()
									return vim.o.columns / 2
								end,
								-- see if we need this again in the future
								-- fmt = function(name, context)
								-- 	local ok, result = pcall(function()
								-- 		return vim.api.nvim_tabpage_get_var(context.tabnr, "tabtitle")
								-- 	end)
								--
								-- 	local tab_title = ""
								--
								-- 	if ok then
								-- 		tab_title = result
								-- 	end
								--
								-- 	if tab_title ~= "" then
								-- 		return tab_title
								-- 	end
								--
								-- 	return vim.fn.getcwd(-1, context.tabnr)
								-- end,
							},
						},
						lualine_y = {},
						lualine_z = {},
					},
					winbar = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {
							{
								"%{%v:lua.dropbar()%}",
							},
						},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					inactive_winbar = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = { {
							"%{%v:lua.dropbar()%}",
						} },
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					inactive_sections = {
						lualine_a = {},
						lualine_b = {},
						lualine_c = {},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {},
					},
					sections = {
						lualine_a = { "mode" },
						lualine_b = { "branch" },
						lualine_c = {
							{
								"location",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								padding = { left = 1, right = 0 },
							},
							{
								"encoding",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								padding = { left = 1, right = 1 },
							},
							{
								"filesize",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								padding = { left = 1, right = 1 },
							},
							"%=",
							{
								function()
									local current_tab = vim.api.nvim_get_current_tabpage()

									local tab_number = vim.api.nvim_tabpage_get_number(current_tab)
									local cwd = vim.fn.getcwd(-1, tab_number)
									local home = os.getenv("HOME")
									if home then
										cwd = cwd:gsub("^" .. home, "~")
									end
									return cwd
								end,
							},
							"%=",
						},
						lualine_x = {},
						lualine_y = {},
						lualine_z = {
							{
								"diagnostics",
								sources = { "nvim_lsp" },
								symbols = {
									error = ERROR_ICON,
									warn = WARNING_ICON,
									info = INFO_ICON,
									hint = HINT_ICON,
								},
								color = "lualine_c_normal",
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
							},
							{
								function()
									local active_clients = vim.lsp.get_clients()
									local client_count = #active_clients
									if #active_clients <= 0 then
										return " LSP:" .. client_count
									else
										local client_names = {}
										for _, client in ipairs(active_clients) do
											if client and client.name ~= "" then
												table.insert(client_names, "[" .. client.name .. "]")
											end
										end
										return " LSP:" .. client_count .. " " .. table.concat(client_names, " ")
									end
								end,
								cond = function()
									return not vim.list_contains(utility_filetypes, vim.bo.filetype)
								end,
								color = "lualine_c_normal",
							},
						},
					},
				})
			end,
		},
		{
			"nvzone/minty",
			enabled = false,
			cmd = { "Shades", "Huefy" },
		},
		-- Doesn't seems to be useful now, as it does not support winbar. bufferline will only work in the first split, when split or vsplit is being used.
		{
			"akinsho/bufferline.nvim",
			commit = "261a72b90d6db4ed8014f7bda976bcdc9dd7ce76",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			enabled = false,
			config = function()
				require("bufferline").setup({
					options = {
						modified_icon = "󰧞",
						close_icon = "",
					},
				})
			end,
		},
		{
			"sindrets/diffview.nvim",
			cmd = {
				"DiffviewOpen",
				"DiffviewToggleFiles",
				"DiffviewFocusFiles",
				"DiffviewRefresh",
				"DiffviewFileHistory",
			},
			config = function()
				local actions = require("diffview.actions")

				require("diffview").setup({
					enhanced_diff_hl = true,
					use_icons = true,
					show_help_hints = false,
					watch_index = true,
					icons = {
						folder_closed = "",
						folder_open = "",
					},
					signs = {
						fold_closed = "",
						fold_open = "",
						done = "✓",
					},
					file_panel = {
						listing_style = "tree",
						tree_options = {
							flatten_dirs = true,
							folder_statuses = "never",
						},
						win_config = {
							position = "left",
							width = 25,
							win_opts = {
								wrap = true,
							},
						},
					},
					file_history_panel = {
						log_options = {
							git = {
								single_file = {
									diff_merges = "combined",
								},
								multi_file = {
									diff_merges = "first-parent",
								},
							},
						},
						win_config = {
							position = "bottom",
							height = 10,
							win_opts = {},
						},
					},
					commit_log_panel = {
						win_config = {},
					},
					keymaps = {
						disable_defaults = true,
						-- the view for the changed files
						view = {
							{
								"n",
								"[x",
								actions.prev_conflict,
								{ desc = "Jump to the previous conflict" },
							},
							{
								"n",
								"]x",
								actions.next_conflict,
								{ desc = "Jump to the next conflict" },
							},
							{
								"n",
								"<tab>",
								actions.select_next_entry,
								{ desc = "Open the diff for the next file" },
							},
							{
								"n",
								"<s-tab>",
								actions.select_prev_entry,
								{ desc = "Open the diff for the previous file" },
							},
							-- TODO decide the right bindings, and apply it to all views
							{
								"n",
								"<leader>ed",
								actions.cycle_layout,
								{ desc = "Cycle through available layouts." },
							},
							{
								"n",
								"<leader>ee",
								actions.toggle_files,
								{ desc = "Toggle the file panel." },
							},
						},
						file_panel = {
							{
								"n",
								"<cr>",
								actions.select_entry,
								{ desc = "Open the diff for the selected entry" },
							},
							{
								"n",
								"<2-LeftMouse>",
								actions.select_entry,
								{ desc = "Open the diff for the selected entry" },
							},
							{
								"n",
								"[x",
								actions.prev_conflict,
								{ desc = "Jump to the previous conflict" },
							},
							{
								"n",
								"]x",
								actions.next_conflict,
								{ desc = "Jump to the next conflict" },
							},
							{
								"n",
								"<tab>",
								actions.select_next_entry,
								{ desc = "Open the diff for the next file" },
							},
							{
								"n",
								"<s-tab>",
								actions.select_prev_entry,
								{ desc = "Open the diff for the previous file" },
							},
						},
						file_history_panel = {
							{
								"n",
								"y",
								actions.copy_hash,
								{ desc = "Copy the commit hash of the entry under the cursor" },
							},
							{
								"n",
								"<cr>",
								actions.select_entry,
								{ desc = "Open the diff for the selected entry" },
							},
							{
								"n",
								"<2-LeftMouse>",
								actions.select_entry,
								{ desc = "Open the diff for the selected entry" },
							},
							{
								"n",
								"<tab>",
								actions.select_next_entry,
								{ desc = "Open the diff for the next file" },
							},
							{
								"n",
								"<s-tab>",
								actions.select_prev_entry,
								{ desc = "Open the diff for the previous file" },
							},
						},
						option_panel = {
							{ "n", "<tab>", actions.select_entry, { desc = "Change the current option" } },
							{ "n", "q", actions.close, { desc = "Close the panel" } },
						},
						help_panel = {
							{ "n", "q", actions.close, { desc = "Close help menu" } },
							{ "n", "<esc>", actions.close, { desc = "Close help menu" } },
						},
					},
				})

				local autocmd_callback = function(_)
					vim.api.nvim_set_option_value("foldcolumn", "0", { scope = "local" })
					vim.api.nvim_set_option_value("wrap", false, { scope = "local" })

					vim.keymap.set(
						"n",
						"[h",
						"[c",
						{ noremap = true, silent = true, desc = "Jump to the previous hunk" }
					)
					vim.keymap.set("n", "]h", "]c", { noremap = true, silent = true, desc = "Jump to the next hunk" })
				end

				vim.api.nvim_create_autocmd("User", {
					pattern = "DiffviewDiffBufRead",
					callback = autocmd_callback,
				})
				vim.api.nvim_create_autocmd("User", {
					pattern = "DiffviewDiffBufWinEnter",
					callback = autocmd_callback,
				})
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "DiffviewFileHistory",
					callback = function()
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFileHistory")
					end,
				})
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "DiffviewFiles",
					callback = function()
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "DiffviewFiles")
					end,
				})
			end,
		},
		-- NOTE doesn't seems to be particularly useful. qa ... Q seems to be good enough for me
		{
			"chrisgrieser/nvim-recorder",
			dependencies = { "folke/snacks.nvim" },
			enabled = false,
			opts = {},
		},
		{
			"NeogitOrg/neogit",
			cmd = {
				"Neogit",
				"NeogitCommit",
				"NeogitLogCurrent",
				"NeogitResetState",
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
				"sindrets/diffview.nvim",
			},
			keys = {
				{
					"<leader>gg",
					function()
						require("neogit").open()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open Neogit status",
				},
			},
			opts = {
				-- FIXME range diffing is not working correctly, cannot select to
				disable_hint = true,
				disable_commit_confirmation = true,
				graph_style = "unicode",
				kind = "tab",
				integrations = {
					diffview = true,
				},
				mappings = {
					status = {
						["<enter>"] = "Toggle",
					},
				},
			},
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			version = "3.14.1",
			keys = {
				{
					"?",
					function()
						require("which-key").show({ global = true, loop = true })
					end,
					silent = true,
					noremap = true,
					desc = "Show local keymaps",
				},
			},
			config = function()
				local wk = require("which-key")
				local ignored_bindings = {
					"z<CR>",
					"z=",
					"zH",
					"zL",
					"zb",
					"ze",
					"zg",
					"zs",
					"zt",
					"zv",
					"zw",
					"zz",
					-- NOTE ignored as we don't use regular f,t
					",",
					";",
					-- NOTE ignored as this is a synonym
					"&",
					-- NOTE default binding set by neovim that does not use treesitter
					"[m",
					"]m",
					"[M",
					"]M",
					-- NOTE for checking misspelled word, we can use latex-lsp to highlight, and then jump with [d and ]d
					"[s",
					"]s",
					-- NOTE <Nop> default keybinding
					"q:",
					"q/",
					"q?",
					-- NOTE not really that useful, explore later
					"ge",
					"gu",
					"gU",
				}

				wk.setup({
					preset = "helix",
					---@param mapping wk.Mapping
					filter = function(mapping)
						return not vim.list_contains(ignored_bindings, mapping.lhs)
					end,
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
				wk.add({
					{ "<leader>c", group = "Comment management" },
					{ "<leader>z", group = "Fold management" },
					{ "<leader>s", group = "LSP and Treesitter" },
					{ "<leader>t", group = "Tabs management" },
					{ "<leader>w", group = "Windows management" },
					{ "<leader>b", group = "Buffers management" },
					{ "<leader>g", group = "Git management" },
					{ "<leader>q", group = "Quickfix" },
					{ "<leader>p", group = "Picker" },
					{ "<leader>e", group = "Encoding and decoding" },
					{ "<leader>ee", group = "Encode" },
					{ "<leader>ed", group = "Decode" },
					{ "x", group = "Exchange" },
				})
			end,
		},
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
		-- NOTE not sure if we need this
		{
			"mrjones2014/smart-splits.nvim",
			version = "1.7.0",
			enabled = false,
			keys = {
				{
					"<leader>wL",
					function()
						require("smart-splits").resize_right()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to right",
				},
				{
					"<leader>wH",
					function()
						require("smart-splits").resize_left()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to left",
				},
				{
					"<leader>wK",
					function()
						require("smart-splits").resize_up()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to top",
				},
				{
					"<leader>wJ",
					function()
						require("smart-splits").resize_down()
					end,
					mode = "n",
					silent = true,
					desc = "Resize split to bottom",
				},
			},
			opts = {
				default_amount = 10,
			},
		},
		{
			"brenoprata10/nvim-highlight-colors",
			event = { "VeryLazy" },
			opts = {
				render = "virtual",
				enable_tailwind = true,
				exclude_filetypes = {
					"lazy",
					"checkhealth",
					"snacks_dashboard",
					"snacks_picker_list",
					"snacks_picker_input",
				},
				exclude_buftypes = {},
			},
		},
		{
			"lewis6991/gitsigns.nvim",
			version = "0.9.0",
			event = { "VeryLazy" },
			keys = {
				{
					"gh",
					function()
						require("gitsigns").select_hunk()
					end,
					mode = { "o", "x" },
					silent = true,
					noremap = true,
					desc = "Git hunk",
				},
				{
					"agh",
					function()
						require("gitsigns").select_hunk()
					end,
					mode = { "o", "x" },
					silent = true,
					noremap = true,
					desc = "Git hunk",
				},
				{
					"<leader>ghs",
					function()
						require("gitsigns").stage_hunk()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Stage hunk",
				},
				{
					"<leader>ghp",
					function()
						require("gitsigns").preview_hunk()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Preview hunk",
				},
				{
					"<leader>ghr",
					function()
						require("gitsigns").reset_hunk()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Reset hunk",
				},
				{
					"]gh",
					function()
						require("gitsigns").nav_hunk("next")
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Jump to next hunk",
				},
				{
					"[gh",
					function()
						require("gitsigns").nav_hunk("prev")
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Jump to previous hunk",
				},
			},
			opts = {
				on_attach = function(bufnr)
					local function startsWith(str, prefix)
						return string.sub(str, 1, #prefix) == prefix
					end

					local ft = vim.bo[bufnr].filetype
					if startsWith(ft, "Neogit") or startsWith(ft, "k8s") or ft == "trouble" or ft == "gitcommit" then
						return false
					end
				end,
				signcolumn = false,
				linehl = false,
				current_line_blame = true,
				preview_config = {
					border = "rounded",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			},
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"ramilito/kubectl.nvim",
			cmd = { "Kubectl", "Kubectx", "Kubens" },
			keys = {
				{
					"<leader>k",
					function()
						require("kubectl").toggle({ tab = true })
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open kubectl.nvim panel",
				},
			},
			dependencies = { "folke/snacks.nvim" },
			config = function()
				require("kubectl").setup({
					log_level = vim.log.levels.INFO,
					auto_refresh = {
						enabled = true,
						interval = 300,
					},
					diff = {
						bin = "kubediff",
					},
					kubectl_cmd = { cmd = "kubectl", env = {}, args = {}, persist_context_change = false },
					terminal_cmd = nil,
					namespace = "All",
					namespace_fallback = {},
					hints = true,
					context = true,
					heartbeat = true,
					lineage = {
						enabled = false,
					},
					logs = {
						prefix = true,
						timestamps = true,
						since = "5m",
					},
					alias = {
						apply_on_select_from_history = true,
						max_history = 5,
					},
					filter = {
						apply_on_select_from_history = true,
						max_history = 10,
					},
					float_size = {
						width = 0.9,
						height = 0.8,
						col = 10,
						row = 5,
					},
					obj_fresh = 5,
					skew = {
						enabled = true,
						log_level = vim.log.levels.INFO,
					},
					headers = true,
					completion = { follow_cursor = true },
				})
				local group = vim.api.nvim_create_augroup("kubectl_mappings", { clear = true })
				vim.api.nvim_create_autocmd("FileType", {
					group = group,
					pattern = "k8s_*",
					callback = function()
						local tab_id = vim.api.nvim_get_current_tabpage()
						vim.api.nvim_tabpage_set_var(tab_id, "tabtitle", "Kubectl")
					end,
				})
			end,
		},
		{
			"mistweaverco/kulala.nvim",
			version = "4.11.0",
			ft = { "http", "rest" },
			opts = {
				curl_path = "curl",
				display_mode = "split",
				split_direction = "vertical",
				debug = false,
				winbar = true,
				vscode_rest_client_environmentvars = true,
				disable_script_print_output = false,
				environment_scope = "b",
				urlencode = "always",
				show_variable_info_text = "float",
			},
		},
		{
			"mcauley-penney/visual-whitespace.nvim",
			-- this plugin is too intrusive
			enabled = false,
			opts = {},
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			dependencies = { "folke/which-key.nvim" },
			keys = {
				{
					"<leader>phu",
					function()
						Snacks.picker.undo()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search undo history",
				},
				{
					"<leader>phn",
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
					"<leader>phc",
					function()
						Snacks.picker.command_history()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search command history",
				},
				{
					"<leader>pb",
					function()
						Snacks.picker.buffers()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search buffers",
				},
				{
					"<leader>pc",
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
				{
					"<leader>pl",
					function()
						Snacks.picker.lines()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search lines in buffer",
				},
				{
					"<leader>pgs",
					function()
						Snacks.picker.git_stash()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git Stash",
				},
				{
					"<leader>pgh",
					function()
						Snacks.picker.git_diff()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git Hunks",
				},
				{
					"<leader>pw",
					function()
						Snacks.picker.grep()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Grep in files",
				},
				{
					"<leader>pf",
					function()
						Snacks.picker.files()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Find files",
				},
				{
					"<leader>pt",
					function()
						Snacks.picker.treesitter({
							filter = {
								-- default = true,
							},
						})
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Find Treesitter nodes",
				},
				{
					"<leader>ps",
					function()
						Snacks.picker.lsp_workspace_symbols()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Find LSP workspace symbols",
				},
				{
					"<leader>pgb",
					function()
						Snacks.picker.git_branches()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git branches",
				},
				{
					"<leader>pgl",
					function()
						Snacks.picker.git_log()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Search Git log",
				},
				{
					"<leader>go",
					function()
						Snacks.gitbrowse.open()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Browse files in remote Git server",
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
				{
					"<leader>pe",
					function()
						Snacks.picker.explorer({
							auto_close = false,
							jump = { close = false },
							win = {
								list = {
									keys = {
										["-"] = "explorer_up",
										["+"] = "explorer_focus",
										["<cr>"] = "confirm",
										["zc"] = "explorer_close",
										["zC"] = "explorer_close_all",
										-- NOTE Missing action that would open all directories, and we should assign zo and zO to it
										["d"] = "explorer_del",
										["c"] = "explorer_rename",
										["y"] = { "explorer_yank", mode = { "n", "x" } },
										["p"] = "explorer_paste",
										-- Use copy here, until there is a new action allows creating a new empty files or dir
										["o"] = "explorer_copy",
										["<a-i>"] = "toggle_ignored",
										["<a-h>"] = "toggle_hidden",
										["]gh"] = "explorer_git_next",
										["[gh"] = "explorer_git_prev",
										["]d"] = "explorer_diagnostic_next",
										["[d"] = "explorer_diagnostic_prev",
										-- NOTE / is searching for files, not sure if we need grep at specific dir
										-- ["<leader>/"] = "picker_grep",
										["<leader>~"] = "tcd",
										-- TODO not sure how to deal with these actions yet
										-- ["a"] = "explorer_add",
										-- ["m"] = "explorer_move",
									},
								},
							},
						})
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Explore files",
				},
			},
			config = function()
				local pickerKeys = {
					["<2-LeftMouse>"] = "confirm",
					["<leader>q"] = { "qflist", mode = { "i", "n" } },
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
						require("which-key").show({ global = false, loop = true })
					end,
				}
				local config_dir = vim.fn.stdpath("config")
				---@cast config_dir string
				require("snacks").setup({
					toggle = { enabled = true },
					gitbrowse = { enabled = true },
					bigfile = { enabled = false },
					-- dim
					image = { enabled = true },
					dashboard = {
						enabled = true,
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
						enabled = true,
						ui_select = true,
						layout = {
							cycle = true,
							preset = function()
								return vim.o.columns >= 120 and "default" or "vertical"
							end,
						},
						win = {
							input = {
								keys = pickerKeys,
							},
							list = {
								keys = pickerKeys,
							},
						},
					},
					scroll = {
						enabled = true,
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
						enabled = true,
						char = "│",
						hl = "SnacksIndent",
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
		{ "sitiom/nvim-numbertoggle", commit = "c5827153f8a955886f1b38eaea6998c067d2992f", event = { "VeryLazy" } },
		{
			"numToStr/Comment.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
			-- FIXME cant really make custom key binding works, 06-12-2024
			keys = { { "<leader>c" }, { "<leader>b" }, { "<leader>c", mode = "v" }, { "<leader>b", mode = "v" } },
			config = function()
				require("Comment").setup({
					padding = true,
					sticky = true,
					post_hook = function() end,
					pre_hook = function()
						---@diagnostic disable-next-line: missing-return
						require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
					end,
					toggler = {
						line = "<leader>cc",
						block = "<leader>bc",
					},
					opleader = {
						line = "<leader>c",
						block = "<leader>b",
					},
				})
			end,
		},
		-- {
		-- 	"petertriho/nvim-scrollbar",
		-- 	-- FIXME enable once this issue is resolved https://github.com/petertriho/nvim-scrollbar/issues/34
		-- 	enabled = false,
		-- 	config = function()
		-- 		local colors = require("tokyonight.colors").setup()
		--
		-- 		require("scrollbar").setup({
		-- 			show = true,
		-- 			show_in_active_only = false,
		-- 			set_highlights = true,
		-- 			throttle_ms = 100,
		-- 			handle = {
		-- 				text = " ",
		-- 				blend = 30,
		-- 				color = colors.bg_highlight,
		-- 				highlight = "CursorColumn",
		-- 				hide_if_all_visible = false,
		-- 			},
		-- 			excluded_filetypes = {
		-- 				"dropbar_menu",
		-- 				"dropbar_menu_fzf",
		-- 				"DressingInput",
		-- 				"cmp_docs",
		-- 				"cmp_menu",
		-- 				"noice",
		-- 				"prompt",
		-- 				"TelescopePrompt",
		-- 				"trouble",
		-- 			},
		-- 			marks = {
		-- 				Search = { color = colors.orange },
		-- 				Error = { color = colors.error },
		-- 				Warn = { color = colors.warning },
		-- 				Info = { color = colors.info },
		-- 				Hint = { color = colors.hint },
		-- 				Misc = { color = colors.purple },
		-- 			},
		-- 			handlers = {
		-- 				cursor = true,
		-- 				diagnostic = true,
		-- 				gitsigns = true,
		-- 				handle = true,
		-- 			},
		-- 		})
		-- 	end,
		-- 	dependencies = {
		-- 		"folke/tokyonight.nvim",
		-- 		"lewis6991/gitsigns.nvim",
		-- 	},
		-- },
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			event = { "VeryLazy" },
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
		-- replaced this plugin with dropbar.nvim, as it occupies less estate on screen
		{
			"nvim-treesitter/nvim-treesitter-context",
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
			"tzachar/highlight-undo.nvim",
			enabled = true,
			event = "VeryLazy",
			opts = {
				hlgroup = "Visual",
				duration = 500,
				pattern = { "*" },
				ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy", "snacks_dashboard" },
			},
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
		{
			"nvim-treesitter/nvim-treesitter",
			build = function()
				vim.cmd("TSUpdate")
			end,
			event = { "VeryLazy" },
			lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
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
				-- NOTE not sure why we need to do that
				pcall(function()
					vim.keymap.del({ "n", "v" }, "x")
				end)

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
								-- ["]cd"] = {
								-- 	query = "@comment.documentation",
								-- 	query_group = "highlights",
								-- 	desc = "Next lua doc comment",
								-- },
								["]ct"] = {
									query = "@comment.todo",
									desc = "Jump to next TODO comment",
								},
								-- ["]cn"] = {
								-- 	query = "@comment.note",
								-- 	query_group = "injections",
								-- 	desc = "Jump to next NOTE comment",
								-- },
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

						local available_textobjects =
							require("nvim-treesitter.textobjects.shared").available_textobjects()
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
		{
			"rlane/pounce.nvim",
			--NOTE relying the default f and treesitter textbobject seems to be enough
			enabled = false,
			commit = "2e36399ac09b517770c459f1a123e6b4b4c1c171",
			keys = {
				{
					"f",
					function()
						require("pounce").pounce()
					end,
					mode = { "n", "v", "o" },
					noremap = true,
					silent = true,
					desc = "Find 1 character forward",
				},
				{
					"F",
					function()
						require("pounce").pounce()
					end,
					mode = { "n", "v", "o" },
					noremap = true,
					silent = true,
					desc = "Find 1 character backward",
				},
			},
			config = function()
				-- wait for tokyonight to support these highlight group
				-- using https://github.com/folke/tokyonight.nvim/blob/355e2842291dbf51b2c5878e9e37281bbef09783/lua/tokyonight/groups/hop.lua#L5
				local c = require("tokyonight.colors").setup()
				vim.api.nvim_set_hl(0, "PounceMatch", {
					link = "Search",
				})
				vim.api.nvim_set_hl(0, "PounceAcceptBest", {
					fg = c.magenta2,
					bg = "none",
					bold = true,
				})
				vim.api.nvim_set_hl(0, "PounceAccept", {
					fg = c.blue2,
					bg = "none",
					bold = true,
				})
				vim.api.nvim_set_hl(0, "PounceUnmatched", {
					fg = c.dark3,
				})
				vim.api.nvim_set_hl(0, "PounceGap", {
					fg = c.dark3,
				})
			end,
		},
		{
			"stevearc/oil.nvim",
			version = "2.14.0",
			cmd = { "Oil" },
			keys = {
				{
					"<leader>o",
					function()
						local tab_idx = find_tab_with_filetype("oil")
						if tab_idx == -1 then
							vim.cmd("tabnew | Oil .")
							vim.cmd("leftabove vsplit | Oil .")
							return
						end
						vim.api.nvim_set_current_tabpage(tab_idx)
					end,
					mode = { "n" },
					noremap = true,
					silent = true,
					desc = "Open Oil.nvim panel",
				},
			},
			config = function()
				local show_detail = false
				local default_columns = {
					"icon",
					"permissions",
				}
				local detail_columns = vim.list_extend(vim.list_slice(default_columns), { "size", "mtime" })
				require("oil").setup({
					columns = default_columns,
					constrain_cursor = "editable",
					watch_for_changes = true,
					keymaps = {
						-- NOTE disable these bindings for now, so we force ourselves to go back to the original tab to open those files, and only use oil.nvim for manipulating files
						["<CR>"] = {
							"actions.select",
							mode = "n",
							opts = { close = false },
							desc = "Select a file",
						},
						-- ["<leader>t<CR>"] = {
						-- 	"actions.select",
						-- 	mode = "n",
						-- 	opts = { close = false, tab = true },
						-- 	desc = "Select a file and open in a new tab",
						-- },
						-- ["<leader>wv<CR>"] = {
						-- 	"actions.select",
						-- 	mode = "n",
						-- 	opts = { close = false, vertical = true },
						-- 	desc = "Select a file and open in a vertical split",
						-- },
						-- ["<leader>ws<CR>"] = {
						-- 	"actions.select",
						-- 	mode = "n",
						-- 	opts = { close = false, horizontal = true },
						-- 	desc = "Select a file and open in a horizontal split",
						-- },
						["~"] = { "actions.cd", mode = "n", desc = "Change current directory of NeoVim" },
						["<a-m>"] = {
							callback = function()
								show_detail = not show_detail
								if show_detail then
									require("oil").set_columns(detail_columns)
								else
									require("oil").set_columns(default_columns)
								end
							end,
							mode = "n",
							desc = "Toggle file detail",
						},
						["<a-h>"] = {
							"actions.toggle_hidden",
							mode = "n",
							desc = "Toggle hidden files",
						},
						["<a-s>"] = { "actions.change_sort", mode = "n" },
						["-"] = { "actions.parent", mode = "n", desc = "Go to parent directory" },
						["q"] = {
							callback = function()
								local tab_idx = find_tab_with_filetype("oil")
								if tab_idx == -1 then
									return
								end
								vim.cmd(string.format("tabclose %s", tab_idx))
							end,
							mode = "n",
							desc = "Quit Oil.nvim panel",
						},
					},
					use_default_keymaps = false,
					win_options = {
						wrap = true,
					},
					view_options = {
						show_hidden = true,
					},
					skip_confirm_for_simple_edits = true,
					float = {
						border = "none",
					},
				})
				-- REF https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
				vim.api.nvim_create_autocmd("User", {
					pattern = "OilActionsPost",
					callback = function(event)
						if event.data.actions.type == "move" then
							Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
						end
					end,
				})
			end,
			dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
		},
		{
			"Isrothy/neominimap.nvim",
			version = "v3.*.*",
			enabled = false,
			lazy = false,
			init = function()
				vim.opt.wrap = false
				vim.opt.sidescrolloff = 36 -- Set a large value
				vim.g.neominimap = {
					auto_enable = true,
					-- NOTE to have higher z-index than nvim-treesitter
					float = { z_index = 11 },
				}
			end,
		},
		{
			"stevearc/quicker.nvim",
			ft = { "qf" },
			keys = {
				{
					"<leader>qq",
					function()
						require("quicker").toggle()
					end,
					mode = { "n" },
					silent = true,
					noremap = true,
					desc = "Open quickfix list",
				},
			},
			config = function()
				vim.keymap.set({ "n" }, "<leader>qy", function()
					-- local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					-- local entries = {}
					-- for i, line in ipairs(lines) do
					-- 	table.insert(entries, { lnum = i, text = line })
					-- end
					-- vim.fn.setqflist(entries, "r")
				end, { noremap = true, silent = true, desc = "Send to Quickfix" })
				require("quicker").setup({
					keys = {},
					borders = {
						vert = "│",
					},
					opts = {
						buflisted = false,
						number = false,
						relativenumber = false,
						signcolumn = "no",
						winfixheight = true,
						wrap = false,
					},
					follow = {
						enabled = false,
					},
				})
			end,
		},
		{
			"folke/edgy.nvim",
			version = "1.10.2",
			event = "VeryLazy",
			enabled = false,
			opts = {
				animate = {
					enabled = false,
				},
				wo = {
					winbar = false,
				},
				options = {
					left = { size = 30 },
					bottom = { size = 4 },
					right = { size = 30 },
					top = { size = 10 },
				},
				left = {
					-- NOTE use oil.nvim for create/edit/delete files. For opening file, use picker is a better option
					-- {
					-- 	ft = "oil",
					-- 	size = { width = 0.25 },
					-- },
				},
				right = {
					{
						ft = "trouble",
						title = "LSP Symbols",
						filter = function(_, win)
							return vim.w[win].trouble
								and (
									vim.w[win].trouble.mode == "symbols"
									or vim.w[win].trouble.mode == "lsp_document_symbols"
								)
						end,
						size = { width = 0.2 },
					},
				},
				bottom = {
					{
						ft = "trouble",
						title = "Diagnostics",
						filter = function(_, win)
							return vim.w[win].trouble and vim.w[win].trouble.mode == "diagnostics"
						end,
						size = { width = 0.5, height = 1 },
					},
					{ ft = "qf", title = "QuickFix", size = { width = 0.5, height = 1 } },
					-- {
					-- 	ft = "trouble",
					-- 	title = "Quickfix",
					-- 	filter = function(_buf, win)
					-- 		return vim.w[win].trouble and vim.w[win].trouble.mode == "qflist"
					-- 	end,
					-- 	size = { width = 0.5, height = 1 },
					-- },
				},
				exit_when_last = true,
			},
			init = function()
				vim.opt.splitkeep = "screen"
			end,
		},
		{
			"stevearc/conform.nvim",
			version = "9.0.0",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			config = function()
				-- TODO add a key binding for formatting operator
				-- TODO jump to specific kind of comments, for example TODO
				local prettier = { "biome", "prettierd", "prettier", stop_after_first = true }
				require("conform").setup({
					formatters_by_ft = {
						ember = {},
						apex = {},
						astro = {},
						bibtex = {},
						cuda = {},
						foam = {},
						fish = {},
						glsl = {},
						hack = {},
						inko = {},
						julia = {},
						odin = {},
						tact = {},
						nasm = {},
						slang = {},
						perl = {},
						wgsl = {},
						html = prettier,
						xml = prettier,
						svg = prettier,
						css = prettier,
						scss = prettier,
						sass = prettier,
						less = prettier,
						javascript = prettier,
						javascriptreact = prettier,
						["javascript.jsx"] = prettier,
						typescript = prettier,
						typescriptreact = prettier,
						["typescript.jsx"] = prettier,
						sh = { "shfmt" },
						zsh = { "shfmt" },
						bash = { "shfmt" },
						markdown = prettier,
						json = prettier,
						jsonl = prettier,
						jsonc = prettier,
						json5 = prettier,
						yaml = prettier,
						vue = prettier,
						http = { "kulala-fmt" },
						rest = { "kulala-fmt" },
						toml = { "taplo" },
						lua = { "stylua" },
						teal = { "stylua" },
						python = function(bufnr)
							if require("conform").get_formatter_info("ruff_format", bufnr).available then
								return { "ruff_format" }
							else
								return { "isort", "black" }
							end
						end,
						rust = { "rustfmt", lsp_format = "fallback" },
						go = { "goimports", "gofmt" },
						nix = { "nixfmt" },
						nginx = { "nginxfmt" },
						ruby = { "rufo" },
						dart = { "dart_format" },
						haskell = { "hindent" },
						kotlin = { "ktlint" },
						cpp = { "clang_format" },
						c = { "clang_format" },
						cs = { "clang_format" },
						swift = { "swift_format" },
						r = { "styler" },
						elm = { "elm_format" },
						elixir = { "mix" },
						sql = { "pg_format" },
						tf = { "hcl" },
						ini = { "inifmt" },
						dosini = { "inifmt" },
						dhall = { "dhall_format" },
						fennel = { "fnlfmt" },
						svelte = prettier,
						pug = prettier,
						nunjucks = { "njkfmt" },
						liquid = { "liquidfmt" },
						nim = { "nimpretty" },
						mint = { "mintfmt" },
						kdl = { "kdlfmt" },
						just = { "just" },
						erb = { "erb_format" },
						ql = { "codeql" },
						d2 = { "d2" },
						erlang = { "efmt" },
						awk = { "gawk" },
						gleam = { "gleam" },
						rego = { "opa_fmt" },
						zig = { "zigfmt" },
					},
					default_format_opts = {
						lsp_format = "fallback",
					},
					format_on_save = function(bufnr)
						if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
							return
						end
						return { timeout_ms = 500, lsp_format = "fallback" }
					end,
					formatters = {},
				})
				vim.api.nvim_create_user_command("FormatDisable", function(args)
					if args.bang then
						-- FormatDisable! will disable formatting just for this buffer
						vim.b.disable_autoformat = true
					else
						vim.g.disable_autoformat = true
					end
				end, {
					desc = "Disable autoformat-on-save",
					bang = true,
				})
				vim.api.nvim_create_user_command("FormatEnable", function()
					vim.b.disable_autoformat = false
					vim.g.disable_autoformat = false
				end, {
					desc = "Re-enable autoformat-on-save",
				})

				-- NOTE seems to be meaningness to create a new function, when gq is an operator to format code?
				-- vim.keymap.set({ "n" }, "<leader>f", function()
				-- 	require("conform")
				-- end, { silent = true, noremap = true, desc = "Format code" })
			end,
			init = function()
				vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			end,
		},
		{
			"vyfor/cord.nvim",
			event = "VeryLazy",
			build = ":Cord update",
			opts = {
				timestamp = {
					enabled = true,
					reset_on_idle = false,
					reset_on_change = false,
				},
				editor = {
					client = "neovim",
					tooltip = "Hugo's ultimate editor",
				},
			},
		},
		{
			"neovim/nvim-lspconfig",
			version = "1.7.0",
			-- Reference the lazyload event from LazyVim
			-- REF https://github.com/LazyVim/LazyVim/blob/86ac9989ea15b7a69bb2bdf719a9a809db5ce526/lua/lazyvim/plugins/lsp/init.lua#L5
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local lspconfig = require("lspconfig")
				local util = require("lspconfig.util")

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				-- REF https://github.com/hrsh7th/nvim-cmp/issues/373
				-- capabilities.textDocument.completion.completionItem.snippetSupport = false
				capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

				-- REF https://github.com/neovim/nvim-lspconfig/blob/d0467b9574b48429debf83f8248d8cee79562586/doc/server_configurations.md#denols
				vim.g.markdown_fenced_languages = {
					"ts=typescript",
				}

				local servers = {
					"rust_analyzer",
					"astro",
					"beancount",
					"solang",
					"solargraph",
					"theme_check",
					"taplo",
					"mint",
					"bicep",
					"ansiblels",
					"vala_ls",
					"jdtls",
					"groovyls",
					"lemminx",
					"html",
					"cssls",
					"jsonls",
					"jsonnet_ls",
					"leanls",
					"dhall_lsp_server",
					"hls",
					"dartls",
					"terraformls",
					"texlab",
					"tilt_ls",
					"ccls",
					"svelte",
					"graphql",
					"elmls",
					"ocamlls",
					"puppet",
					"serve_d",
					"gdscript",
					"scry",
					"ember",
					"biome",
					"eslint",
					"angularls",
					"bashls",
					"hhvm",
					"prismals",
					"gopls",
					"docker_compose_language_service",
					"glsl_analyzer",
					"gradle_ls",
					"nimls",
					"metals",
					"julials",
					"purescriptls",
					"rescriptls",
					"racket_langserver",
					"pasls",
					"yamlls",
					"postgres_lsp",
					-- use postgres_lsp for now
					-- "sqlls",
					"vimls",
					"nixd",
					"r_language_server",
					"kotlin_language_server",
					"cmake",
					"pyright",
					"taplo",
					"cucumber_language_server",
					"slint_lsp",
					"regal",
					-- nix does not provide this package yet
					-- "snyk-ls",
					"ballerina",
					"bitbake_ls",
					"ltex",
					"csharp_ls",
				}

				for _, server in ipairs(servers) do
					lspconfig[server].setup({
						on_init = function(client)
							-- FIXME seems to be able to prevent LSP from highlighting
							client.server_capabilities.semanticTokensProvider = nil
						end,
						capabilities = capabilities,
					})
				end

				lspconfig.elixirls.setup({
					cmd = { "elixir-ls" },
					capabilities = capabilities,
				})

				lspconfig.kulala_ls.setup({
					capabilities = capabilities,
					filetypes = { "http", "rest" },
				})

				lspconfig.dockerls.setup({
					capabilities = capabilities,
					settings = {
						docker = {
							languageserver = {
								formatter = {
									ignoreMultilineInstructions = true,
								},
							},
						},
					},
				})

				lspconfig.ts_ls.setup({
					init_options = {
						--   plugins = {
						-- 	{
						-- 	  name = "@vue/typescript-plugin",
						-- 	  location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
						-- 	  languages = {"javascript", "typescript", "vue"},
						-- 	},
						--   },
					},
					filetypes = {
						"javascript",
						"typescript",
						--   "vue",
					},
				})

				-- it only works if deno.json is at the root level
				lspconfig.denols.setup({
					capabilities = capabilities,
					root_dir = util.root_pattern("deno.json", "deno.jsonc"),
				})

				lspconfig.lua_ls.setup({
					diagnostics = {
						underline = true,
						update_in_insert = false,
						severity_sort = true,
					},
					capabilities = capabilities,
					on_init = function(client)
						-- FIXME seems to be able to prevent LSP from highlighting
						client.server_capabilities.semanticTokensProvider = nil

						if client.workspace_folders then
							local path = client.workspace_folders[1].name
							if
								path ~= vim.fn.stdpath("config")
								and (
									vim.loop.fs_stat(path .. "/.luarc.json")
									or vim.loop.fs_stat(path .. "/.luarc.jsonc")
								)
							then
								return
							end
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								version = "LuaJIT",
							},
							workspace = {
								checkThirdParty = false,
								library = {},
							},
						})
					end,
					settings = {
						Lua = {
							diagnostics = {
								globals = {},
							},
							telemetry = {
								enable = false,
							},
							hint = { enable = true },
						},
					},
					inlay_hints = {
						enabled = true,
						exclude = {},
					},
					codelens = {
						enabled = true,
					},
					document_highlight = {
						enabled = true,
					},
				})
			end,
		},
		{
			"m00qek/baleia.nvim",
			version = "*",
			cmd = { "BaleiaColorize", "BaleiaLogs" },
			config = function()
				vim.g.baleia = require("baleia").setup({})

				vim.api.nvim_create_user_command("BaleiaColorize", function()
					local bufId = tonumber(vim.api.nvim_get_current_buf())
					if bufId == nil then
						vim.notify("Unable to find current buffer handle", vim.log.levels.ERROR)
						return
					end
					---@diagnostic disable-next-line: param-type-mismatch
					vim.g.baleia.once(bufId)
				end, { bang = true })

				vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
			end,
		},
		{
			"folke/trouble.nvim",
			version = "3.7.0",
			event = { "BufReadPre", "BufNewFile" },
			enabled = false,
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("trouble").setup({
					position = "bottom",
					use_diagnostic_signs = true,
					indent_lines = false,
					auto_preview = false,
					auto_close = true,
					auto_refresh = true,
					win = {
						wo = {
							wrap = true,
						},
					},
					modes = {
						diagnostics = {
							auto_open = true,
							format = "{severity_icon} {message:md} {item.source} {code}",
						},
						lsp_document_symbols = {
							auto_open = false,
							win = {
								wo = {
									wrap = false,
								},
							},
							format = "{kind_icon} {symbol.name} {text:Comment} {pos}",
						},
						symbols = {
							auto_open = false,
							format = "{kind_icon} {symbol.name}",
						},
					},
					keys = {
						["?"] = false,
						["<cr>"] = "jump",
						["<leader>ws<cr>"] = "jump_split",
						["<leader>wv<cr>"] = "jump_vsplit",
					},
				})
			end,
		},
		{ "echasnovski/mini.icons", version = false, event = "VeryLazy" },
	},
})
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local supported_modes = { "n", "v" }
		vim.keymap.set(supported_modes, "<leader>ss", function()
			-- if we call twice, we will enter the hover windows immediately after running the keybinding
			vim.lsp.buf.hover()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show hover tips" })
		vim.keymap.set(supported_modes, "<leader>sd", function()
			vim.diagnostic.open_float()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Show diagnostics message" })
		-- TODO combine all these functions, using Snacks.picker
		vim.keymap.set(supported_modes, "<leader>s1", function()
			Snacks.picker.lsp_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to definition" })
		vim.keymap.set(supported_modes, "<leader>s2", function()
			Snacks.picker.lsp_type_definitions()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to type definition" })
		vim.keymap.set(supported_modes, "<leader>s3", function()
			Snacks.picker.lsp_implementations()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to implementation" })
		vim.keymap.set(supported_modes, "<leader>s4", function()
			Snacks.picker.lsp_references()
		end, { silent = true, noremap = true, buffer = ev.buf, desc = "Jump to references", nowait = true })
		vim.keymap.set(
			supported_modes,
			"<leader>s5",
			vim.lsp.buf.rename,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Rename variable" }
		)
		vim.keymap.set(
			supported_modes,
			"<leader>s6",
			vim.lsp.buf.code_action,
			{ silent = true, noremap = true, buffer = ev.buf, desc = "Apply code action" }
		)
		pcall(function()
			-- Remove default keybinding added by lspconfig
			-- REF https://neovim.io/doc/user/lsp.html#lsp-config
			vim.keymap.del({ "n" }, "K", { buffer = ev.buf })
		end)

		vim.diagnostic.config({
			underline = true,
			virtual_text = false,
			-- NOTE only available after 0.11.0
			virtual_lines = { current_line = true },
			signs = {
				text = {
					-- FIXME: cannot customize the icon, without not showing it in signcolumn
					-- [vim.diagnostic.severity.ERROR] = ERROR_ICON,
					-- [vim.diagnostic.severity.WARN] = WARNING_ICON,
					-- [vim.diagnostic.severity.INFO] = INFO_ICON,
					-- [vim.diagnostic.severity.HINT] = HINT_ICON,
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
			update_in_insert = false,
		})
	end,
})
vim.api.nvim_create_autocmd("LspProgress", {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
		vim.notify(vim.lsp.status(), "info", {
			id = "lsp_progress",
			title = "LSP Progress",
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == "end" and " "
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})
-- ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
-- local progress = vim.defaulttable()
-- vim.api.nvim_create_autocmd("LspProgress", {
-- 	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
-- 	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
-- 		if not client or type(value) ~= "table" then
-- 			return
-- 		end
-- 		local p = progress[client.id]
--
-- 		for i = 1, #p + 1 do
-- 			if i == #p + 1 or p[i].token == ev.data.params.token then
-- 				p[i] = {
-- 					token = ev.data.params.token,
-- 					msg = ("[%3d%%] %s%s"):format(
-- 						value.kind == "end" and 100 or value.percentage or 100,
-- 						value.title or "",
-- 						value.message and (" **%s**"):format(value.message) or ""
-- 					),
-- 					done = value.kind == "end",
-- 				}
-- 				break
-- 			end
-- 		end
--
-- 		local msg = {} ---@type string[]
-- 		progress[client.id] = vim.tbl_filter(function(v)
-- 			return table.insert(msg, v.msg) or not v.done
-- 		end, p)
--
-- 		local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- 		vim.notify(table.concat(msg, "\n"), "info", {
-- 			id = "lsp_progress",
-- 			title = client.name,
-- 			opts = function(notif)
-- 				notif.icon = #progress[client.id] == 0 and " "
-- 					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
-- 			end,
-- 		})
-- 	end,
-- })

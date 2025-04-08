vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 0
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.o.encoding = "UTF-8"
vim.o.fileencoding = "UTF-8"
vim.o.confirm = true
vim.opt.termguicolors = true
vim.o.diffopt = "internal,filler,closeoff,algorithm:histogram,followwrap"
vim.o.timeoutlen = 400
vim.o.ttimeoutlen = 0
vim.o.updatetime = 300
vim.o.showmode = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.cmdheight = 1
vim.o.showmatch = true
-- FIXME how to split in right?
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.lazyredraw = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.magic = true
vim.o.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.hidden = true
vim.o.bufhidden = "unload"
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.wrap = true
vim.o.linebreak = true
vim.o.number = true
vim.opt.relativenumber = true
vim.o.signcolumn = "auto:2"
vim.o.scrolloff = 8
vim.o.fillchars = "diff:╱,eob: "
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.undofile = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
-- fold specific config
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })
vim.api.nvim_create_autocmd("WinEnter", {
	callback = function()
		if vim.wo.diff then
			local tab_id = vim.api.nvim_get_current_tabpage()
			-- lockbuffer is a custom variable we create, to disable all buffer navigation related features
			vim.api.nvim_tabpage_set_var(tab_id, "lockbuffer", true)
			local windows = vim.api.nvim_tabpage_list_wins(0)
			for _, win_id in ipairs(windows) do
				vim.wo[win_id].winfixbuf = true
				vim.wo[win_id].wrap = false

				local buf_id = vim.api.nvim_win_get_buf(win_id)
				vim.api.nvim_buf_set_var(buf_id, "lockbuffer", true)
			end
		end
	end,
})

-- Use space as leader key
vim.g.mapleader = " "
vim.o.mouse = "a"
vim.o.mousefocus = true

-- FIXME do not set folds here as it cannot reload the session correctly
-- https://github.com/neovim/neovim/issues/28692
vim.o.sessionoptions = "buffers,curdir,help,resize,tabpages,winsize,winpos,terminal"

-- NOTE hide colorscheme provided by Neovim in colorscheme picker
vim.opt.wildignore:append({
	"unokai.vim",
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
vim.cmd("filetype on")
vim.filetype.add({
	extension = {
		http = "http",
		rest = "http",
		qalc = "qalc",
	},
})

-- NOTE no longer need these bindings, just use register correctly with "+
-- vim.keymap.set(modes, "<leader>y", '"+y', { silent = true, noremap = true, desc = "Yank text to system clipboard" })
local clear_buffer_keybinding = "<leader>bc"
local delete_buffer_keybinding = "<leader>bq"
local next_buffer_keybinding = "<leader>bl"
local prev_buffer_keybinding = "<leader>bh"
vim.keymap.set({ "n" }, clear_buffer_keybinding, function()
	-- TODO
end, { silent = true, noremap = true, desc = "Unload other buffers" })
vim.keymap.set({ "n" }, delete_buffer_keybinding, function()
	Snacks.bufdelete.delete()
end, { silent = true, noremap = true, desc = "Delete current buffer" })
vim.keymap.set({ "n" }, next_buffer_keybinding, function()
	vim.cmd("bnext")
end, { silent = true, noremap = true, desc = "Go to next buffer" })
vim.keymap.set({ "n" }, prev_buffer_keybinding, function()
	vim.cmd("bprev")
end, { silent = true, noremap = true, desc = "Go to previous buffer" })
for i = 1, 9 do
	vim.keymap.set({ "n" }, "<leader>b" .. i, function()
		vim.cmd(string.format("LualineBuffersJump %s", i))
	end, { noremap = true, silent = true, desc = string.format("Jump to buffer %s", i) })
end

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function(ev)
		local ok, bufferlocked = pcall(function()
			return vim.api.nvim_buf_get_var(0, "lockbuffer")
		end)

		if not ok then
			return
		end

		if not bufferlocked then
			return
		end
		vim.keymap.set({ "n" }, clear_buffer_keybinding, "<Nop>", { buffer = ev.buf })
		vim.keymap.set({ "n" }, delete_buffer_keybinding, "<Nop>", { buffer = ev.buf })
		vim.keymap.set({ "n" }, next_buffer_keybinding, "<Nop>", { buffer = ev.buf })
		vim.keymap.set({ "n" }, prev_buffer_keybinding, "<Nop>", { buffer = ev.buf })
		for i = 1, 9 do
			vim.keymap.set({ "n" }, "<leader>b" .. i, "<Nop>", { buffer = ev.buf })
		end
	end,
})

-- NOTE make Y consistent with how C and D behave for changing or deleting to the end of the line.
vim.keymap.set({ "n", "x" }, "Y", "y$", {
	silent = true,
	noremap = true,
	desc = "Yank to EOL",
})

vim.keymap.set({ "n" }, "vv", "<C-v>", { silent = true, noremap = true, desc = "Enter Visual block mode" })

--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
vim.keymap.set(
	{ "i" },
	"<Esc>",
	"<Esc>`^",
	{ silent = true, noremap = true, desc = "Prevent the cursor move back when returning to normal mode" }
)

vim.keymap.set({ "n" }, "<leader>wv", function()
	vim.cmd("vsplit")
end, { silent = true, noremap = true, desc = "Create a vertical split" })
vim.keymap.set({ "n" }, "<leader>ws", function()
	vim.cmd("split")
end, { silent = true, noremap = true, desc = "Create a horizontal split" })
vim.keymap.set({ "n" }, "<leader>wq", function()
	vim.cmd("quit")
end, { silent = true, noremap = true, desc = "Close a split" })
vim.keymap.set({ "n" }, "<leader>wl", "<C-w>l", { silent = true, noremap = true, desc = "Navigate to left split" })
vim.keymap.set({ "n" }, "<leader>wh", "<C-w>h", { silent = true, noremap = true, desc = "Navigate to right split" })
vim.keymap.set({ "n" }, "<leader>wk", "<C-w>k", { silent = true, noremap = true, desc = "Navigate to top split" })
vim.keymap.set({ "n" }, "<leader>wj", "<C-w>j", { silent = true, noremap = true, desc = "Navigate to bottom split" })

vim.keymap.set({ "t" }, "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Back to normal mode" })
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
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

vim.keymap.set({ "n" }, "<leader>tv", function()
	vim.cmd("tabnew")
end, { silent = true, noremap = true, desc = "Create a new tab" })
vim.keymap.set({ "n" }, "<leader>tl", "gt", {
	silent = true,
	noremap = true,
	desc = "Go to the next tab page. Wraps around from the last to the first one.",
})
vim.keymap.set({ "n" }, "<leader>th", "gT", {
	silent = true,
	noremap = true,
	desc = "Go to the previous tab page. Wraps around from the first one to the last one.",
})
vim.keymap.set({ "n" }, "<leader>tq", function()
	vim.cmd("tabclose")
end, { silent = true, noremap = true, desc = "Close a tab" })
for i = 1, 9 do
	vim.keymap.set({ "n" }, "<leader>t" .. i, function()
		vim.cmd(string.format("tabn %s", i))
	end, { noremap = true, silent = true, desc = string.format("Jump to tab %s", i) })
end

vim.keymap.set({ "v" }, "p", "pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set({ "v" }, "P", "Pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set({ "n" }, "[h", "[c", { noremap = true, silent = true, desc = "Jump to the previous hunk" })
vim.keymap.set({ "n" }, "]h", "]c", { noremap = true, silent = true, desc = "Jump to the next hunk" })

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

vim.lsp.enable({
	"lua_ls",
})

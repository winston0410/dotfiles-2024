-- conform.nvim related
vim.g.disable_autoformat = true

vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
-- vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 0
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
-- vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.o.shell = "zsh"
vim.o.exrc = true
vim.o.secure = true

vim.o.incsearch = true
vim.o.wrapscan = true

vim.o.title = true
vim.o.titlestring = "%{fnamemodify(getcwd(), ':p:~')} - nvim"
vim.o.titleold = "zsh"

vim.o.spell = false
vim.opt.spelllang = "en_gb"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,localoptions,resize,tabpages,winsize,terminal,winpos,winsize"

vim.o.completeopt = "menu,popup,fuzzy"
vim.o.wildoptions = "pum,fuzzy"

-- NOTE add this so we can have fixed width or height split, prevent Neovim automatically resize for us
vim.o.equalalways = false
vim.o.encoding = "UTF-8"
vim.o.fileencoding = "UTF-8"
vim.o.confirm = true
vim.opt.termguicolors = true
vim.o.diffopt = "internal,filler,closeoff,algorithm:histogram,followwrap"
vim.o.ttimeoutlen = 0
vim.o.updatetime = 200
vim.o.showmode = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.cmdheight = 0
vim.o.showmatch = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.opt.splitkeep = "screen"
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
vim.o.wrap = false
vim.o.linebreak = true
vim.o.number = true
vim.opt.relativenumber = true
vim.o.signcolumn = "auto"
vim.o.scrolloff = 8
vim.opt.sidescrolloff = 16
vim.opt.fillchars:append({
	eob = " ",
	diff = "╱",
	lastline = " ",
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	-- TODO wait for the https://www.reddit.com/r/neovim/comments/1nxzz9i/new_foldinner_fillchar/#lightbox to land in my Neovim version
	-- foldinner = ' '
})
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smoothscroll = true
vim.o.virtualedit = "block"
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.winborder = "none"
vim.o.showcmd = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
-- fold specific config
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
-- TODO set this to 1, once foldinner is available
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({ fold = " " })

-- Use space as leader key
vim.g.mapleader = " "
vim.o.mouse = "a"
vim.o.mousefocus = true

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
		vert = "glsl",
		frag = "glsl",
		http = "http",
		rest = "http",
		k = "kcl",
		qalc = "qalc",
		kbd = "kbd",
		gr = "grain",
	},
})
-- remove tag mapping as it has been replaced by LSP
vim.keymap.del({ "n" }, "[t", {})
vim.keymap.del({ "n" }, "]t", {})
vim.keymap.del({ "n" }, "[T", {})
vim.keymap.del({ "n" }, "]T", {})
vim.keymap.del({ "n" }, "[<C-t>", {})
vim.keymap.del({ "n" }, "]<C-t>", {})
-- remove buffer navigation
vim.keymap.del({ "n" }, "[b", {})
vim.keymap.del({ "n" }, "]b", {})
vim.keymap.del({ "n" }, "[B", {})
vim.keymap.del({ "n" }, "]B", {})
-- remove location list navigation
vim.keymap.del({ "n" }, "[l", {})
vim.keymap.del({ "n" }, "]l", {})
vim.keymap.del({ "n" }, "[L", {})
vim.keymap.del({ "n" }, "]L", {})
vim.keymap.del({ "n" }, "[<C-l>", {})
vim.keymap.del({ "n" }, "]<C-l>", {})
-- remove unused arglist binding
vim.keymap.del({ "n" }, "[a", {})
vim.keymap.del({ "n" }, "]a", {})
vim.keymap.del({ "n" }, "[A", {})
vim.keymap.del({ "n" }, "]A", {})

-- remove unused quickfix list binding
vim.keymap.del({ "n" }, "[q", {})
vim.keymap.del({ "n" }, "]q", {})
vim.keymap.del({ "n" }, "[Q", {})
vim.keymap.del({ "n" }, "]Q", {})
vim.keymap.del({ "n" }, "[<C-q>", {})
vim.keymap.del({ "n" }, "]<C-q>", {})

-- remove default LSP keymap set by Neovim, as a clean Neovim wouldn't have any LSP config anyway
vim.keymap.del({ "n" }, "gra", {})
vim.keymap.del({ "n" }, "gri", {})
vim.keymap.del({ "n" }, "grn", {})
vim.keymap.del({ "n" }, "grr", {})
vim.keymap.del({ "n" }, "grt", {})
vim.keymap.del({ "n" }, "gO", {})

vim.keymap.set({ "n" }, "]<leader>q", function()
	pcall(function()
		vim.cmd.cnext()
	end)
end, { noremap = true, silent = true, desc = "Next entry in quickfix" })

vim.keymap.set({ "n" }, "[<leader>q", function()
	pcall(function()
		vim.cmd.cprev()
	end)
end, { noremap = true, silent = true, desc = "Prev entry in quickfix" })

vim.keymap.set({ "n" }, "<leader>q@", function()
    local macro_key = vim.fn.getcharstr()
    vim.cmd(string.format( "cdo normal! @%s", macro_key ))
	vim.notify(string.format( "Triggered marco for %s", macro_key ), vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Execute macros in quickfix" })

vim.keymap.set({ "n" }, "<leader>a@", function()
    local macro_key = vim.fn.getcharstr()
    vim.cmd(string.format( "argdo normal! @%s", macro_key ))
	vim.notify(string.format( "Triggered marco for %s", macro_key ), vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Execute macros in arglist" })

-- NOTE we won't be using arglist or quickfix list that often with vanilla Neovim anyway. Remapping to <leader><key>, so we can add more custom keybinding to each of them
vim.keymap.set({ "n" }, "]<leader>a", function()
	pcall(function()
		vim.cmd.next()
	end)
end, { noremap = true, silent = true, desc = "Next entry in arglist" })
vim.keymap.set({ "n" }, "[<leader>a", function()
	pcall(function()
		vim.cmd.prev()
	end)
end, { noremap = true, silent = true, desc = "Prev entry in arglist" })
vim.keymap.set({ "n" }, "<leader>aa", function()
	vim.cmd.argadd()
	vim.cmd.argdedupe()
	vim.notify("Added current buffer into arglist", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Add current buffer to arglist" })

vim.keymap.set({ "n" }, "<leader>ad", function()
	vim.cmd.argdelete()
	vim.notify("Removed current buffer from arglist", vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Delete current buffer from arglist" })

vim.keymap.set({ "n" }, "gp", "`[v`]", { remap = true, silent = true, desc = "Select previously pasted region" })
-- Native Neovim commenting. Block commenting is not available in Neovim yet
vim.keymap.set({ "n", "x" }, "<leader>c", "gc", { remap = true, silent = true, desc = "Comment" })
vim.keymap.set({ "n" }, "<leader>cc", "gcc", { remap = true, silent = true, desc = "Comment Line" })
vim.keymap.set({ "n" }, "<leader>T", function()
	vim.cmd.term()
end, { remap = true, silent = true, desc = "Open terminal" })

-- NOTE make Y consistent with how C and D behave for changing or deleting to the end of the line.
vim.keymap.set({ "n", "x" }, "Y", "y$", {
	silent = true,
	noremap = true,
	desc = "Yank to EOL",
})

-- NOTE this prevent which-key.nvim from showing hints for registers.
vim.keymap.set(
	"i",
	"<C-r>",
	"<C-r><C-o>",
	{ noremap = true, desc = "Insert contents of named register. Inserts text literally, not as if you typed it." }
)

--  https://stackoverflow.com/questions/2295410/how-to-prevent-the-cursor-from-moving-back-one-character-on-leaving-insert-mode
vim.keymap.set(
	{ "i" },
	"<Esc>",
	"<Esc>`^",
	{ silent = true, noremap = true, desc = "Prevent the cursor move back when returning to normal mode" }
)

-- NOTE o is older or out, i is newer or in. Just the the default key binding for now
-- vim.keymap.set({ "n" }, "<C-o>", "<C-i>", { silent = true, noremap = true, desc = "Jump forward" })
-- vim.keymap.set({ "n" }, "<C-i>", "<C-o>", { silent = true, noremap = true, desc = "Jump backward" })

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

-- NOTE not really sure if we need keybinding for creating tab
-- vim.keymap.set({ "n" }, "<leader>tv", function()
-- 	vim.cmd("tabnew")
-- end, { silent = true, noremap = true, desc = "Create a new tab" })
-- vim.keymap.set({ "n" }, "<leader>to", "gt", {
-- 	silent = true,
-- 	noremap = true,
-- 	desc = "Go to the next tab page",
-- })
-- vim.keymap.set({ "n" }, "<leader>ti", "gT", {
-- 	silent = true,
-- 	noremap = true,
-- 	desc = "Go to the previous tab page",
-- })
-- vim.keymap.set({ "n" }, "<leader>tq", function()
-- 	pcall(function()
-- 		vim.cmd("tabclose")
-- 	end)
-- end, { silent = true, noremap = true, desc = "Close a tab" })
-- for i = 1, 9 do
-- 	vim.keymap.set({ "n" }, "<leader>t" .. i, function()
-- 		vim.cmd(string.format("tabn %s", i))
-- 	end, { noremap = true, silent = true, desc = string.format("Jump to tab %s", i) })
-- end

vim.keymap.set({ "n" }, "<leader>xd", function()
	local wins = vim.api.nvim_tabpage_list_wins(0)

	local has_diff = false
	for _, w in ipairs(wins) do
		if vim.api.nvim_win_get_option(w, "diff") then
			has_diff = true
			break
		end
	end

	for _, w in ipairs(wins) do
		vim.api.nvim_set_current_win(w)
		if has_diff then
			vim.cmd("diffoff!")
		else
			vim.cmd.diffthis()
		end
	end
end, { silent = true, noremap = true, desc = "Toggle diff for current buffers" })
vim.keymap.set({ "v" }, "p", "pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
vim.keymap.set({ "v" }, "P", "Pgvy", { silent = true, noremap = true, desc = "Paste without copying" })
-- NOTE remove additional wrapper around * and #
vim.keymap.set({ "n" }, "*", "g*", { silent = true, noremap = true, desc = "Search word under cursor forward" })
vim.keymap.set({ "n" }, "#", "g#", { silent = true, noremap = true, desc = "Search word under cursor backward" })
vim.keymap.set(
	{ "x" },
	"*",
	'y/<C-r>"<CR>',
	{ noremap = true, silent = false, desc = "Search word under cursor forward" }
)
vim.keymap.set(
	{ "x" },
	"#",
	'y?<C-r>"<CR>',
	{ noremap = true, silent = false, desc = "Search word under cursor backward" }
)
vim.keymap.set({ "n", "x" }, "gf", "gF", { silent = true, noremap = true, desc = "Go to file under cursor" })
vim.keymap.set(
	{ "n" },
	"<C-w>f",
	"<C-w>F",
	{ silent = true, noremap = true, desc = "Split and go to file under cursor" }
)

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
-- REF https://neovim.io/doc/user/lsp.html#lsp-semantic-highlight
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end
	end,
})

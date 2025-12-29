vim.pack.add({
	{ src = "https://github.com/winston0410/syringe.nvim" },
	{ src = "https://github.com/mcauley-penney/visual-whitespace.nvim", version = "main" },
	{ src = "https://github.com/GCBallesteros/jupytext.nvim" },
	{ src = "https://github.com/folke/ts-comments.nvim" },
	{ src = "https://github.com/MeanderingProgrammer/treesitter-modules.nvim", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/ravsii/tree-sitter-d2" },
	{ src = "https://github.com/OXY2DEV/markview.nvim", version = vim.version.range("27.x") },
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		if ev.data.spec.name ~= "tree-sitter-d2" then
			return
		end
		vim.system({ "make", "nvim-install" }, { cwd = ev.data.path }, function(res)
			if res.code ~= 0 then
				vim.notify("Build failed for " .. ev.data.spec.name, vim.log.levels.ERROR)
			else
				vim.notify("Build succeeded for " .. ev.data.spec.name, vim.log.levels.INFO)
			end
		end)
	end,
})

local function setup()
	local comment_hl = vim.api.nvim_get_hl(0, { name = "@comment", link = false })
	local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
	require("visual-whitespace").setup({
		highlight = { fg = comment_hl.fg, bg = visual_hl.bg },
	})
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function(event)
		setup()
	end,
})

setup()

require("jupytext").setup({
	style = "markdown",
	output_extension = "md",
	force_ft = "markdown",
})

require("treesitter-modules").setup({
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = false,
			node_incremental = "+",
			node_decremental = "-",
			scope_incremental = false,
		},
	},
})

require("nvim-treesitter").setup({})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter.setup", {}),
	callback = function(args)
		local filetype = args.match

		local language = vim.treesitter.language.get_lang(filetype) or filetype
		if not vim.treesitter.language.add(language) then
			return
		end
		vim.treesitter.start(args.buf, language)
	end,
})

local function conceal_tag(icon, hl_group)
	return {
		on_node = { hl_group = hl_group },
		on_closing_tag = { conceal = "" },
		on_opening_tag = {
			conceal = "",
			virt_text_pos = "inline",
			virt_text = { { icon .. " ", hl_group } },
		},
	}
end
require("markview").setup({
	html = {
		container_elements = {
			["^buf$"] = conceal_tag("", "CodeCompanionChatVariable"),
			["^file$"] = conceal_tag("", "CodeCompanionChatVariable"),
			["^help$"] = conceal_tag("󰘥", "CodeCompanionChatVariable"),
			["^image$"] = conceal_tag("", "CodeCompanionChatVariable"),
			["^symbols$"] = conceal_tag("", "CodeCompanionChatVariable"),
			["^url$"] = conceal_tag("󰖟", "CodeCompanionChatVariable"),
			["^var$"] = conceal_tag("", "CodeCompanionChatVariable"),
			["^tool$"] = conceal_tag("", "CodeCompanionChatTool"),
			["^user_prompt$"] = conceal_tag("", "CodeCompanionChatTool"),
			["^group$"] = conceal_tag("", "CodeCompanionChatToolGroup"),
		},
	},
	-- FIXME known issue, it is giving out an error when open CodeCompanionChat
	preview = {
		hybrid_modes = { "n" },
		icon_provider = "devicons",
		filetypes = { "markdown", "codecompanion", "md", "rmd", "quarto", "yaml", "typst" },
		ignore_buftypes = {},
	},
	markdown = {
		headings = {
			shift_width = 0,
		},
		code_blocks = {
			style = "simple",
			sign = false,
		},
	},
})

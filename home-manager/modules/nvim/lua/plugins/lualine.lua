local M = {}

local godot = require("custom.godot")

vim.pack.add({
	{ src = "https://github.com/Zeioth/heirline-components.nvim", version = vim.version.range("3.x") },
	{ src = "https://github.com/rebelot/heirline.nvim", version = vim.version.range("1.x") },
})

local function buf_in_arglist(buf_id)
	local name = vim.api.nvim_buf_get_name(buf_id)
	if name == "" then
		return false
	end

	local argv = vim.fn.argv()
	assert(type(argv) == "table", "vim.fn.argv() must be a table")

	for _, arg in ipairs(argv) do
		if vim.fn.fnamemodify(arg, ":p") == name then
			return true
		end
	end
	return false
end

vim.o.mousemoveevent = true
vim.o.showtabline = 2
vim.o.laststatus = 3

local Space = { provider = " " }
---@param text string
---@param opts PaddingOpts
---@return string
local function handle_padding(text, opts)
	local result = text
	for _ = 1, opts.left do
		result = Space.provider .. result
	end
	for _ = 1, opts.right do
		result = result .. Space.provider
	end

	return result
end

---@param parts string[]
---@return string[]
local function process_path_parts(parts)
	local modified_parts = {}
	for idx, part in ipairs(parts) do
		local icon, hl = MiniIcons.get("directory", part)
		if idx == #parts then
			icon, hl = MiniIcons.get("file", part)
			if vim.bo.modified then
				part = string.format("%s ", part)
			end
		end
		-- REF https://www.reddit.com/r/neovim/comments/tz6p7i/how_can_we_set_color_for_each_part_of_statusline/
		-- %#<string>% is to highlight a string
		-- %* is to reset the highlight for the remaining content
		table.insert(modified_parts, string.format("%%#%s#%s %%*%s", hl, icon, part))
	end
	return modified_parts
end

require("heirline-components").setup({
	icons = {
		GitBranch = "",
	},
})

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local heirline = require("heirline")
local heirline_components = require("heirline-components.all")
local heirline_components_provider = require("heirline-components.core.provider")
local heirline_components_condition = require("heirline-components.core.condition")

heirline_components.init.subscribe_to_events()
-- FIXME heirline-compoments would reload color after colorscheme has changed, we need to set our custom color again as well
heirline.load_colors(heirline_components.hl.get_colors())

-- find symbol such as :2, :3
---@return integer
local find_git_rev = function (items)
    for idx, item in ipairs(items) do
        if item == ":2" or item == ":3" then
            return idx
        end
    end
end

local is_file_buffer = function()
	local buf = vim.api.nvim_get_current_buf()
	return vim.bo[buf].buftype == ""
end

---@param opts CustomComponentOpts
local DapSessionStatus = function(opts)
	return {
		condition = function()
			local ok, session = pcall(function()
				return require("dap").session()
			end)
			if not ok then
				return false
			end
			return session ~= nil
		end,
		provider = function()
			return handle_padding("󰂓", opts.padding)
		end,
	}
end
---@param opts CustomComponentOpts
local SudoStatus = function(opts)
	return {
		update = { "VimEnter" },
		condition = function()
			local uid = vim.loop.getuid()
			return uid == 0
		end,
		provider = function()
			return handle_padding("ROOT", opts.padding)
		end,
		hl = function()
			return "Error"
		end,
	}
end
---@param opts CustomComponentOpts
local ReadOnlyStatus = function(opts)
	return {
		condition = function()
			local buf_nr = vim.api.nvim_get_current_buf()
			return vim.bo[buf_nr].readonly
		end,
		provider = function()
			return handle_padding("󰌾 Read-only", opts.padding)
		end,
	}
end
---@param opts CustomComponentOpts
local CopilotStatus = function(opts)
	return {
		condition = function()
			local ok, _ = pcall(function()
				vim.fn["copilot#Enabled"]()
			end)
			return ok
		end,
		provider = function()
			local copilot_status = vim.fn["copilot#Enabled"]()
			local status_icon = ""
			if copilot_status == 0 then
				status_icon = ""
			end
			return handle_padding(status_icon, opts.padding)
		end,
	}
end
---@param opts CustomComponentOpts
local DiffStatus = function(opts)
	return {
		condition = function()
			local win = vim.api.nvim_get_current_win()
			local is_diff = vim.wo[win].diff
			return is_diff
		end,
		provider = function()
			return handle_padding(" Diff", opts.padding)
		end,
	}
end
---@param opts CustomComponentOpts
local SearchCount = function(opts)
	local search_func = vim.tbl_isempty(opts or {}) and function()
		return vim.fn.searchcount()
	end or function()
		return vim.fn.searchcount(opts)
	end
	return {
		condition = heirline_components_condition.is_hlsearch,
		provider = function()
			local search_ok, search = pcall(search_func)
			if search_ok and type(search) == "table" and search.total then
				local search_reg = vim.fn.getreg("/")
				local TRIM_THRESHOLD = 32
				if #search_reg > TRIM_THRESHOLD then
					search_reg = search_reg:sub(1, TRIM_THRESHOLD) .. "..."
				end

				return handle_padding(
					string.format(
						" %s %s%d/%s%d",
						search_reg,
						search.current > search.maxcount and ">" or "",
						math.min(search.current, search.maxcount),
						search.incomplete == 2 and ">" or "",
						math.min(search.total, search.maxcount)
					),
					opts.padding
				)
			end
		end,
	}
end
vim.api.nvim_create_autocmd("RecordingLeave", {
	desc = "Trace recorded macro",
	nested = true,
	callback = function()
		if type(vim.g.MacroNamedRegister) ~= "string" then
			vim.g.MacroNamedRegister = ""
		end
		local reg = vim.fn.reg_recording()
		local reg_list = vim.split(vim.g.MacroNamedRegister, ",", { trimempty = true })
		table.insert(reg_list, reg)
		local dedup_list = vim.list.unique(reg_list)
		-- REF https://github.com/neovim/neovim/blob/6525832a8c4d44a8ebabba02a5ea1ce09b389a4f/runtime/lua/vim/_options.lua#L58
		-- We have to reassign the value for Neovim to rerender
		local result = table.concat(dedup_list, ",")
		vim.g.MacroNamedRegister = result

		if type(vim.g.YankNamedRegister) ~= "string" then
			return
		end
		-- clean up text yank named register list
		local named_reg_list = vim.split(vim.g.YankNamedRegister, ",", { trimempty = true })
		local filtered_named_reg_list = vim.iter(named_reg_list):filter(function(named_reg)
			return named_reg ~= reg
		end)
		vim.g.YankNamedRegister = table.concat(filtered_named_reg_list, ",")
	end,
})
vim.api.nvim_create_autocmd("TextYankPost", {
	nested = true,
	desc = "Track Named Register",
	callback = function()
		-- REF https://neovim.io/doc/user/starting.html#views-sessions
		-- Only variable starts with Uppercase can be restored. It can only restore variable with string or number, not dictionary/table
		if type(vim.g.YankNamedRegister) ~= "string" then
			vim.g.YankNamedRegister = ""
		end
		local reg = vim.v.event.regname
		if reg == nil then
			return
		end
		if not reg:match("[a-z]") then
			return
		end
		local reg_list = vim.split(vim.g.YankNamedRegister, ",", { trimempty = true })
		table.insert(reg_list, reg)
		local dedup_list = vim.list.unique(reg_list)
		-- REF https://github.com/neovim/neovim/blob/6525832a8c4d44a8ebabba02a5ea1ce09b389a4f/runtime/lua/vim/_options.lua#L58
		-- We have to reassign the value for Neovim to rerender
		local result = table.concat(dedup_list, ",")
		vim.g.YankNamedRegister = result
		-- clean up macro named register list
		if type(vim.g.MacroNamedRegister) ~= "string" then
			return
		end
		local macro_reg_list = vim.split(vim.g.MarcroNamedRegister, ",", { trimempty = true })
		local filtered_macro_reg_list = vim.iter(macro_reg_list):filter(function(macro_reg)
			return macro_reg ~= reg
		end)
		vim.g.MacroNamedRegister = table.concat(filtered_macro_reg_list, ",")
	end,
})
---@param opts CustomComponentOpts
local YankRegisters = function(opts)
	return {
		condition = function()
			if type(vim.g.YankNamedRegister) ~= "string" then
				return false
			end
			local regs = vim.split(vim.g.YankNamedRegister, ",", { trimempty = true })
			return #regs > 0
		end,
		update = { "TextYankPost", "RecordingLeave" },
		provider = function()
			return handle_padding("󱓥 " .. vim.g.YankNamedRegister, opts.padding)
		end,
		hl = function()
			return "DiagnosticHint"
		end,
	}
end
---@param opts CustomComponentOpts
local MacroRegisters = function(opts)
	return {
		condition = function()
			if type(vim.g.MacroNamedRegister) ~= "string" then
				return false
			end
			local regs = vim.split(vim.g.MacroNamedRegister, ",", { trimempty = true }, ",", { trimempty = true })
			return #regs > 0
		end,
		update = { "RecordingLeave" },
		provider = function()
			return handle_padding(" " .. vim.g.MacroNamedRegister, opts.padding)
		end,
		hl = function()
			return "DiagnosticHint"
		end,
	}
end

---@param opts CustomComponentOpts
local FileSize = function(opts)
	return {
		condition = is_file_buffer,
		provider = function()
			-- stackoverflow, compute human readable file size
			local suffix = { "b", "k", "M", "G", "T", "P", "E" }
			local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
			fsize = (fsize < 0 and 0) or fsize
			if fsize < 1024 then
				return fsize .. suffix[1]
			end
			local i = math.floor((math.log(fsize) / math.log(1024)))
			return handle_padding(string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1]), opts.padding)
		end,
	}
end

local Tabpage = function()
	return {
		provider = function(self)
			return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
		end,
		hl = function(self)
			if not self.is_active then
				return "TabLine"
			else
				return "TabLineFill"
			end
		end,
	}
end

local TabPages = function()
	return {
		condition = function()
			return true
		end,
		utils.make_tablist(Tabpage()),
	}
end

---@param opts CustomComponentOpts
local GoDotExternalEditor = function(opts)
	return {
		condition = function()
			return vim.tbl_contains(vim.fn.serverlist(), godot.GODOT_EXTERNAL_EDITOR_PIPE)
		end,
		provider = function()
			return handle_padding(" Godot", opts.padding)
		end,
	}
end
-- add padding right 1 to this component
---@param opts CustomComponentOpts
local ArglistIndex = function(opts)
	return {
		condition = function()
			return vim.fn.argc() > 0
		end,
		provider = function()
			local arglist_idx = vim.fn.argidx() + 1
			local arglist_count = vim.fn.argc()
			local buf_nr = vim.api.nvim_get_current_buf()
			local in_arglist = buf_in_arglist(buf_nr)

			if in_arglist then
				return handle_padding(string.format("󰐷 %s/%s", arglist_idx, arglist_count), opts.padding)
			end

			return handle_padding(string.format("󰐷 %s", arglist_count), opts.padding)
		end,
		hl = function()
			return "DiagnosticHint"
		end,
	}
end
---@param opts CustomComponentOpts
local QuickfixIndex = function(opts)
	return {
		condition = function()
			local qf = vim.fn.getqflist()
			return #qf > 0
		end,
		-- FIXME use the following autocmd to limit update is not working. It is missing some update. Use an update function instead
		-- update = {"QuickFixCmdPre", "QuickFixCmdPost", "CursorMoved"},
		provider = function()
			-- NOTE it doesn't make sense, but using 0 as the value in what would be a getter to that property.
			local qf = vim.fn.getqflist({ idx = 0, items = 0 })
			return handle_padding(string.format("󰖷 %s/%s", qf.idx, #qf.items), opts.padding)
		end,
		hl = function()
			return "DiagnosticWarn"
		end,
	}
end
---@param opts CustomComponentOpts
local LocationListIndex = function(opts)
	return {
		condition = function()
			local location_list = vim.fn.getloclist(0)
			return #location_list > 0
		end,
		provider = function()
			-- NOTE it doesn't make sense, but using 0 as the value in what would be a getter to that property.
			local location_list = vim.fn.getloclist(0, { idx = 0, items = 0 })
			return handle_padding(string.format("󰖷 %s/%s", location_list.idx, #location_list.items), opts.padding)
		end,
		hl = function()
			return "DiagnosticHint"
		end,
	}
end
---@param opts CustomComponentOpts
local Ruler = function(opts)
	return {
		condition = is_file_buffer,
		provider = function()
			local line = vim.fn.line(".")
			local char = vim.fn.virtcol(".")
			local padding_str = string.format("%%%dd:%%-%dd", 3, 2)
			return handle_padding(string.format(padding_str, line, char), opts.padding)
		end,
		update = { "CursorMoved", "CursorMovedI", "BufEnter" },
	}
end
---@class PaddingOpts
---@field left number
---@field right number

---@class CustomComponentOpts
---@field padding PaddingOpts

require("heirline").setup({
	statusline = {
		heirline_components.component.mode({ mode_text = {} }),
		-- Mode,
		-- FIXME no idea why its position is fixed
		-- heirline_components.component.git_diff(),
		heirline_components.component.file_encoding({
			file_format = { padding = { left = 0, right = 0 } },
		}),
		FileSize({ padding = { left = 1, right = 0 } }),
		Ruler({ padding = { left = 1, right = 0 } }),
		DiffStatus({ padding = { left = 1, right = 0 } }),
		ReadOnlyStatus({ padding = { left = 1, right = 0 } }),
		DapSessionStatus({ padding = { left = 1, right = 0 } }),
		heirline_components.component.fill(),
		heirline_components.component.lsp({ lsp_client_names = false, padding = { left = 1, right = 0 } }),
		SearchCount({ padding = { left = 1, right = 0 } }),
		heirline_components.component.diagnostics(),
		-- heirline_components.component.cmd_info(),
		LocationListIndex({ padding = { left = 1, right = 0 } }),
	},
	winbar = {
		{
            provider = function()
                table.unpack = table.unpack or unpack
                local relative_path = vim.fs.normalize(vim.fn.expand("%:."), { expand_env = true })

                local CODEDIFF_PROTOCOL_MATCHER = "^codediff:"
                local is_codediff = relative_path:match(CODEDIFF_PROTOCOL_MATCHER)

                local parts = vim.split(relative_path, "/", { trimempty = true })

                if not is_codediff then
                    local modified_parts = process_path_parts(parts)
                    return table.concat(modified_parts, "  ")
                end

                local git_ref_idx = find_git_rev(parts)
                local side = parts[git_ref_idx]
                parts = { table.unpack(parts, git_ref_idx + 1) }
                local metadata = require("custom.git").get_merge_metadata(side)
                local modified_parts = process_path_parts(parts)
                local rev = string.format("%s(%s)", metadata.branch, metadata.sha)

                table.insert(modified_parts, string.format( "%%=%s", rev ))

                return table.concat(modified_parts, "  ")
            end,
            update = { "BufWinEnter" },
		},
	},
	statuscolumn = {
		heirline_components.component.signcolumn(),
		heirline_components.component.numbercolumn(),
		{
			provider = "%C",
		},
	},
	tabline = {
		CopilotStatus({ padding = { left = 1, right = 0 } }),
		SudoStatus({ padding = { left = 1, right = 0 } }),
		GoDotExternalEditor({ padding = { left = 1, right = 0 } }),
		ArglistIndex({ padding = { left = 1, right = 0 } }),
		QuickfixIndex({ padding = { left = 1, right = 0 } }),
		YankRegisters({ padding = { left = 1, right = 0 } }),
		MacroRegisters({ padding = { left = 1, right = 0 } }),
		heirline_components.component.fill(),
		heirline_components.component.git_branch({ padding = { left = 0, right = 0 } }),
		TabPages(),
	},
	opts = {
		colors = {
			hydra_window = utils.get_highlight("Constant").fg,
			hydra_treewalk = utils.get_highlight("@comment.info").fg,
			hydra_surround = utils.get_highlight("@comment.info").fg,
			hydra_kulala = utils.get_highlight("@comment.info").fg,
			hydra_exchange = utils.get_highlight("@comment.info").fg,
		},
		disable_winbar_cb = function(args)
			return require("heirline.conditions").buffer_matches({
				buftype = { "nofile", "help", "quickfix" },
				filetype = {
					"OverseerForm",
					"dashboard",
					"^k8s_*",
					"terminal",
					"snacks_terminal",
					"oil",
					"qf",
					"trouble",
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
				},
			}, args.buf)
		end,
	},
})

return M

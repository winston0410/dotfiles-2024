-- local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local godot = require("custom.godot")

vim.pack.add({
    { src = "https://github.com/Zeioth/heirline-components.nvim", version = vim.version.range("3.x") },
    { src = "https://github.com/Bekaboo/dropbar.nvim",            version = vim.version.range("14.x") },
    { src = "https://github.com/rebelot/heirline.nvim",           version = vim.version.range("1.x") },
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

require("heirline-components").setup({
    icons = {
        GitBranch = "",
    },
})

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
        path = {
            modified = function(sym)
                return sym:merge({
                    name = sym.name .. "[+]",
                })
            end,
        },
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
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")
local heirline = require("heirline")
local heirline_components = require("heirline-components.all")
local heirline_components_provider = require("heirline-components.core.provider")
local heirline_components_condition = require("heirline-components.core.condition")

heirline_components.init.subscribe_to_events()
-- FIXME heirline-compoments would reload color after colorscheme has changed, we need to set our custom color again as well
heirline.load_colors(heirline_components.hl.get_colors())

local is_file_buffer = function()
    local buf = vim.api.nvim_get_current_buf()
    return vim.bo[buf].buftype == ""
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
        end
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
        end
    }
end
---@param opts CustomComponentOpts
local SearchCount = function(opts)
    return {
        condition = heirline_components_condition.is_hlsearch,
        provider = heirline_components_provider.search_count({
            padding = opts.padding,
            icon = { kind = "SearchCount", padding = { right = 1 } },
        }),
    }
end
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Track Named Register",
  callback = function()
      -- REF https://neovim.io/doc/user/starting.html#views-sessions
      -- Only variable starts with Uppercase can be restored. It can only restore variable with string or number, not dictionary/table
      print("check type",  vim.g.YankNamedRegister, type( vim.g.YankNamedRegister) )
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
      local result = table.concat( dedup_list, ",")
      vim.g.YankNamedRegister = result
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
        update = { "TextYankPost" },
        provider = function()
            return handle_padding("󱓥 " .. vim.g.YankNamedRegister, opts.padding)
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
                return _G.dropbar()
            end,
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
        GoDotExternalEditor({ padding = { left = 1, right = 0 } }),
        ArglistIndex({ padding = { left = 1, right = 0 } }),
        QuickfixIndex({ padding = { left = 1, right = 0 } }),
        YankRegisters({ padding = { left = 1, right = 0 } }),
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

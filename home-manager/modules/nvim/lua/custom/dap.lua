--- https://github.com/mfussenegger/nvim-dap/issues/198#issuecomment-2764679167
--- Debug/DAP helpers

local M = {}
local dap = require("dap")
local breakpoints = require("dap.breakpoints")

--- Store all breakpoints in a global variable to be persisted in the session
M.store_breakpoints = function()
    local bps = {}
    for buffer_id, buffer_breakpoints in pairs(breakpoints.get()) do
        local filename = vim.api.nvim_buf_get_name(buffer_id)
        bps[filename] = buffer_breakpoints
    end
    vim.g.BREAKPOINTS = bps
end

--- Load existing breakpoints for all open buffers in the session
M.load_breakpoints = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local filename = vim.api.nvim_buf_get_name(buf)
        local buffer_breakpoints = vim.g.BREAKPOINTS[filename]
        if buffer_breakpoints ~= nil then
            for _, bp in pairs(buffer_breakpoints) do
                local line = bp.line
                local opts = {
                    condition = bp.condition,
                    log_message = bp.logMessage,
                    hit_condition = bp.hitCondition,
                }
                breakpoints.set(opts, buf, line)
            end
        end
    end
end

--- Toggle a breakpoint and ensure it is persisted in the session
M.toggle_breakpoint = function()
    dap.toggle_breakpoint()
    M.store_breakpoints()
end

M.toggle_advanced_breakpoint = function()
    local message = vim.fn.input("Log point message: ")
    local condition = vim.fn.input("Breakpoint condition: ")
    local hit_condition = vim.fn.input("Breakpoint hit condition: ")
    dap.set_breakpoint(condition, hit_condition, message)
    M.store_breakpoints()
end

--- Clear all breakpoints and ensure they are persisted in the session
M.clear_breakpoints = function()
    dap.clear_breakpoints()
    M.store_breakpoints()
end

return M

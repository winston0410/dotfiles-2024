-- # Config principle
-- 1. When defining mappings are related with operators and textobjects, follow the verb -> noun convention, so we don't have to go into visual mode all the time to get things done like in Helix
-- 2. When defining mappings that are not related with operators and textobjects, follow the noun -> verb convention, as there could be conflicting actions between different topics, making mappings definition difficult
-- 3. Following the default Vim's mapping semantic and enhance it

-- ## Operators
-- REF https://neovim.io/doc/user/motion.html#operator
-- We only use c, d, y, p, >, <, <leader>c, gq and ~ operator for manipulating textobjects.
-- And finally gx for opening url in neovim.
-- For compound operators, for example change surround, the topic specific operator should precede generic operator( i.e. we should use sc instead of cs. ), so that we will not confuse the topic speicifc operator with textobjects.

-- ## Register
-- for deleting without polluting the current register, use blackhold register _, for example "_dd
require("custom.essential")
local godot = require("custom.godot")

require("plugins.lualine")
require("plugins.theme")
require("plugins.highlight")
require("plugins.lsp")
require("plugins.completion")
if not vim.g.disable_snacks then
    require("plugins.snacks")
end
require("plugins.editing-support")
if not vim.g.disable_session then
    require("plugins.session-manager")
    require("plugins.file-manager")
    require("plugins.conform")
    require("plugins.dap")
    require("plugins.task-runner")
    require("plugins.test")
    require("plugins.ai")
end
if not vim.g.disable_diff_support then
    require("plugins.diff")
end
-- Neogit is slow with big repo, and not fully customizable
-- require("plugins.git")

local completion_args = { 'extra' }

vim.api.nvim_create_user_command(
  "EnableFeature",
  function(opts)
    for _, arg in ipairs(opts.fargs) do
        if arg == "extra" then
            require("plugins.extra")
        end
    end
  end,
  {
    nargs = "*",
    complete = function (_)
        return completion_args
    end
  }
)

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local cwd = vim.fn.getcwd()
		local godot_dir = cwd .. "/.godot"

		if vim.fn.isdirectory(godot_dir) == 1 then
			godot.listen_godot_external_editor_pipe()
		end
	end,
	desc = "Connect to godot external editor pipe",
})


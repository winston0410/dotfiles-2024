local M = {};

M.GODOT_EXTERNAL_EDITOR_PIPE = vim.fn.stdpath("state") .. "/godot-nvim.pipe"

M.listen_godot_external_editor_pipe = function ()
    if not vim.loop.fs_stat(M.GODOT_EXTERNAL_EDITOR_PIPE) then
      vim.fn.serverstart(M.GODOT_EXTERNAL_EDITOR_PIPE)
    end
end

return M;

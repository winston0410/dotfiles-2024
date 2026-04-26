vim.pack.add({
	{ src = "https://github.com/carlos-algms/agentic.nvim" },
}, { confirm = false })

require("agentic").setup({
    diff_preview = {
      enabled = true,
      layout = "split",
    },
    windows = {
      width = "38.2%"
    },
    keymaps = {
      widget = {
        change_mode = {
          {
            "<Tab>",
            mode = { "n" }
          },
        },
      },
    }
})

local providers = {
  claude    = "claude-agent-acp",
  codex     = "codex-acp",
  opencode  = "opencode-acp",
}

vim.keymap.set({ "n", "x" }, "<leader>ca", function()
  require("agentic").add_selection_or_file_to_context()
end, { desc = "Add file or selection to Agentic to Context", silent = true, noremap = true })

vim.keymap.set("n", "<leader>cs", function()
  local keys = vim.tbl_keys(providers)
  table.sort(keys)
  vim.ui.select(keys, { prompt = "Select agent provider:" }, function(choice)
    if choice then
      require("agentic").new_session({ provider = providers[choice] or choice })
    end
  end)
end, { desc = "Start Agentic session (select provider)", silent = true, noremap = true })

vim.api.nvim_create_user_command("Agent", function(opts)
  local provider = providers[opts.args] or opts.args
  require("agentic").new_session({ provider = provider })
end, {
  nargs = 1,
  complete = function(arglead)
    local keys = vim.tbl_keys(providers)
    table.sort(keys)
    return vim.tbl_filter(function(p)
      return p:find(arglead, 1, true) == 1
    end, keys)
  end,
})


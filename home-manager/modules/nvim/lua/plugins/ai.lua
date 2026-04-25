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

local providers = { "claude", "codex", "opencode" }

vim.api.nvim_create_user_command("Agent", function(opts)
  local provider = opts.args
  if provider == "claude" then
    provider = "claude-agent-acp"
  elseif provider == "codex" then
      provider = "codex-acp"
  elseif provider == "opencode" then
      provider = "opencode-acp"
  end
  require("agentic").new_session({ provider = provider })
end, {
  nargs = 1,
  complete = function(arglead)
    return vim.tbl_filter(function(p)
      return p:find(arglead, 1, true) == 1
    end, providers)
  end,
})


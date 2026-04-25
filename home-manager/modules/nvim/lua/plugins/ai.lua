vim.pack.add({
	{ src = "https://github.com/carlos-algms/agentic.nvim" },
}, { confirm = false })

require("agentic").setup({
    windows = {
      width = "38.2%"
    },
})

local providers = { "claude", "codex", "opencode" }

vim.api.nvim_create_user_command("Agent", function(opts)
  local provider = opts.args
  if provider == "claude" then
    provider = "claude-agent-acp"
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


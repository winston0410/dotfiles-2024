vim.pack.add({
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/esmuellert/codediff.nvim", version = vim.version.range("2.x") },
}, { confirm = false })
require("codediff").setup({
    -- :1 is base, :2 is ours, :3 is theirs, :4 is merged
    diff = {
        hide_merge_artifacts = true,
        original_position = "left",
        conflict_ours_position = "right",
        max_computation_time_ms = 100,
        compute_moves = true,
    },

    -- IMPORTANT current = ours, incoming = theirs. Current would be the current branch that we are in, during a rebase it would be the rebase target
    keymaps = {
        conflict = {
            accept_incoming = "<LocalLeader>xt",
            accept_current = "<LocalLeader>xo",
            accept_both = "<LocalLeader>xa",
            discard = "<LocalLeader>xn",
            next_conflict = "]x",
            prev_conflict = "[x",
        },
    },
})

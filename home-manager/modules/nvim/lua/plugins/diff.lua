vim.pack.add({
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/esmuellert/codediff.nvim", version = vim.version.range("2.x") },
})
require("codediff").setup({
    -- :1 is base, :2 is ours, :3 is theirs, :4 is merged
    diff = {
        hide_merge_artifacts = true,
        original_position = "left",
        conflict_ours_position = "right",
    },

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

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Copilot = { "zbirenbaum/copilot.lua" }

Copilot.opts = {
    filetypes = {
        lua = true,
        markdown = true
    },
    suggestion = {
        auto_trigger = true,
        enabled = true,
        keymap = {
            accept = "<M-a>",
            accept_word = false,
            accept_line = false,
            next = "<M-n>",
            prev = "<M-p>",
            dismiss = "<M-BS>",
        },
    },
    panel = {
        enbled = true
    }
}

Copilot.config = function(_, opts)
    require("copilot").setup(opts)
end

return Copilot

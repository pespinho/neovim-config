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
            accept = "<C-S-CR>",
            accept_word = false,
            accept_line = false,
            next = "<C-S-n>",
            prev = "<C-S-p>",
            dismiss = "<C-S-BS>",
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

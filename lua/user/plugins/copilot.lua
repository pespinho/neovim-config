-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Copilot = { "zbirenbaum/copilot.lua" }

Copilot.tag = "v2.0.2"

Copilot.cmd = "Copilot"
Copilot.event = "InsertEnter"

Copilot.opts = {
    filetypes = {
        ["*"] = false,
    },
    suggestion = {
        enabled = false,
        auto_trigger = true,
        keymap = {
            accept = "<M-y>",
            next = "<M-n>",
            prev = "<M-p>",
            dismiss = "<M-e>",
        },
    },
}

Copilot.config = function(_, opts)
    require("copilot").setup(opts)
end

return Copilot

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Copilot = { "zbirenbaum/copilot.lua" }

Copilot.opts = {
    filetypes = {
        lua = true
    },
    suggestion = {
        enabled = false
    },
    panel = {
        enbled = false
    }
}

Copilot.config = function(_, opts)
    require("copilot").setup(opts)
end

return Copilot

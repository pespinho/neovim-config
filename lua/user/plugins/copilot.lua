-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Copilot = { "zbirenbaum/copilot.lua" }

Copilot.opts = {
    filetypes = {
        lua = true
    },
    suggestion = {
        auto_trigger = true
    }
}

Copilot.config = function(_, opts)
    require("copilot").setup(opts)
end

return Copilot

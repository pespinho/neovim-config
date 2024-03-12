-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local CopilotCmp = { "zbirenbaum/copilot-cmp" }

CopilotCmp.config = function()
    require("copilot_cmp").setup()
end

return CopilotCmp

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Undotree = { "mbbill/undotree" }

Undotree.cmd = "UndotreeToggle"

Undotree.keys = {
    { "<leader><F5>", ":UndotreeToggle<CR>", desc = "Toggle Undotree" },
}

return Undotree

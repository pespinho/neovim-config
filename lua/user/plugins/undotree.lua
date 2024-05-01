-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Undotree = { "mbbill/undotree" }

Undotree.cmd = "UndotreeToggle"

Undotree.keys = {
    { "<leader>u", ":UndotreeToggle<CR>", desc = "Toggle [U]ndotree" },
}

return Undotree

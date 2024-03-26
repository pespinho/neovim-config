-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Diffview = { "sindrets/diffview.nvim" }

Diffview.config = function()
    require("diffview").setup()
end

return Diffview

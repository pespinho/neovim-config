-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Gitsigns = { "lewis6991/gitsigns.nvim" }

-- git stuff
Gitsigns.opts = {
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
    }
}

Gitsigns.config = function(_, opts)
    require("gitsigns").setup(opts)
end

return Gitsigns

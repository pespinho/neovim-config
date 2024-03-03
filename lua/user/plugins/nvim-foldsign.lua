-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimFoldsign = { "yaocccc/nvim-foldsign" }

NvimFoldsign.event = "CursorHold"

NvimFoldsign.opts = {
    offset = -2,
    foldsigns = {
        open = '', -- mark the beginning of a fold
        close = '', -- show a closed fold
        seps = { '│' }, -- open fold middle marker
    }
}

NvimFoldsign.config = function(_, opts)
    require('nvim-foldsign').setup(opts)
end

return NvimFoldsign

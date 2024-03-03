-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimWebDevicons = { "nvim-tree/nvim-web-devicons" }

NvimWebDevicons.config = function(_, opts)
    require("nvim-web-devicons").setup(opts)
end

return NvimWebDevicons

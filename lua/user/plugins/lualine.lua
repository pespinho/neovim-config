-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Lualine = { 'nvim-lualine/lualine.nvim' }

Lualine.dependencies = { 'nvim-tree/nvim-web-devicons' }

Lualine.opts = {
    extensions = { 'nvim-tree' },
    options = {
        theme = "catppuccin-mocha"
    }
}

Lualine.config = function(_, opts)
    require('lualine').setup(opts)
end

return Lualine

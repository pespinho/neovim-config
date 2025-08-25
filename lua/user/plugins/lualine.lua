-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Lualine = { 'nvim-lualine/lualine.nvim' }

Lualine.dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/noice.nvim',
}

Lualine.opts = function()
    return {
        extensions = { 'nvim-tree' },
        options = {
            theme = "catppuccin-" .. vim.g.catppuccin
        },
        sections = {
            lualine_x = {
                {
                    require("noice").api.statusline.mode.get,
                    cond = require("noice").api.statusline.mode.has,
                }
            }
        }
    }
end

Lualine.config = function(_, opts)
    require('lualine').setup(opts)
end

return Lualine

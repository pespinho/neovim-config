-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local WhichKey = { "folke/which-key.nvim" }

WhichKey.event = 'VeryLazy'

WhichKey.init = function()
    require('which-key').add({
        "<leader>?",
        function()
            require("which-key").show()
        end
        ,
        desc = "Which-Key[?]",
        icon = ''
    })
end

WhichKey.opts = {
    preset = "helix",
    icons = { rules = false },
    keys = {
        scroll_down = "<c-f>", -- binding to scroll down inside the popup
        scroll_up = "<c-b>",   -- binding to scroll up inside the popup
    }
}

WhichKey.config = function(_, opts)
    require("which-key").setup(opts)

    -- Document existing key chains
    require('which-key').add {
        { '<leader>b', group = '[B]uffer', icon = '' },
        { '<leader>bg', group = '[G]o to', icon = '' },
        { '<leader>bo', group = '[O]rder', icon = '' },
        { '<leader>d', group = '[D]AP', icon = '' },
        { '<leader>f', group = '[F]ind', icon = '' },
        { '<leader>c', group = '[C]opilot', icon = '' },
        { '<leader>cs', group = '[S]ticky', icon = '' }, -- Copilot sticky prompts
        { '<leader>l', group = '[L]SP', icon = '󱡄' },
        { '<leader>n', group = '[N]vimTree', icon = '' },
        { '<leader>q', group = '[Q]uickfix', icon = '' },
        { '<leader>t', group = '[T]rouble', icon = '' },
        { '<leader>T', group = '[T]erminal', icon = '' },
    }
end

return WhichKey

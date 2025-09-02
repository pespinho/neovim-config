-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local WhichKey = { "folke/which-key.nvim" }

WhichKey.event = 'VeryLazy'

WhichKey.keys = {
    {
        "<leader>?",
        function()
            require("which-key").show({ global = false })
        end,
        desc = "Which-Key[?]",
    }
}

WhichKey.opts = {
}

WhichKey.config = function(_, opts)
    require("which-key").setup(opts)

    -- Document existing key chains
    require('which-key').add {
        { '<leader>b', group = '[B]uffer', icon = '' },
        { '<leader>bg', group = '[G]o to', icon = '' },
        { '<leader>bo', group = '[O]rder', icon = '' },
        { '<leader>d', group = '[D]AP', icon = '' },
        { '<leader>g', group = '[G]it', icon = '' },
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

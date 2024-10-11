-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local WhichKey = { "folke/which-key.nvim" }

WhichKey.event = 'VeryLazy'

WhichKey.init = function()
    vim.keymap.set(
        "n",
        "<leader>wk",
        function() vim.cmd("WhichKey") end,
        { desc = "All [k]eymaps" }
    )

    vim.keymap.set(
        "n",
        "<leader>wq",
        function()
            local input = vim.fn.input("WhichKey: ")
            vim.cmd("WhichKey " .. input)
        end,
        { desc = "[Q]uery lookup" }
    )
end

WhichKey.opts = {
    icons = { mappings = false }
}

WhichKey.config = function(_, opts)
    require("which-key").setup(opts)

    -- Document existing key chains
    require('which-key').add {
        { '<leader>b',  group = '[B]uffer' },
        { '<leader>bg', group = '[G]o to' },
        { '<leader>bo', group = '[O]rder' },
        { '<leader>d',  group = '[D]AP' },
        { '<leader>f',  group = '[F]ind' },
        { '<leader>h',  group = '[H]arpoon' },
        { '<leader>c',  group = '[C]opilot' },
        { '<leader>l',  group = '[L]SP' },
        { '<leader>n',  group = '[N]vimTree' },
        { '<leader>q',  group = '[Q]uickfix' },
        { '<leader>t',  group = '[T]rouble' },
        { '<leader>T',  group = '[T]erminal' },
        { '<leader>w',  group = '[W]hich-Key' },
    }
end

return WhichKey

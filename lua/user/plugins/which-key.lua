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

WhichKey.config = function(_, opts)
    require("which-key").setup(opts)

    -- Document existing key chains
    require('which-key').register {
        ['<leader>b'] = { name = '[B]uffer', _ = 'which_key_ignore' },
        ['<leader>bg'] = { name = '[G]o to', _ = 'which_key_ignore' },
        ['<leader>bo'] = { name = '[O]rder', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]AP', _ = 'which_key_ignore' },
        ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = '[H]arpoon', _ = 'which_key_ignore' },
        ['<leader>c'] = { name = '[C]opilot', _ = 'which_key_ignore' },
        ['<leader>l'] = { name = '[L]SP', _ = 'which_key_ignore' },
        ['<leader>q'] = { name = '[Q]uickfix', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]rouble', _ = 'which_key_ignore' },
        ['<leader>T'] = { name = '[T]erminal', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]hich-Key', _ = 'which_key_ignore' },
    }
end

return WhichKey

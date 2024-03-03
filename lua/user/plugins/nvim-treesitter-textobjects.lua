-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimTreesitterTextobjects = { "nvim-treesitter/nvim-treesitter-textobjects" }

NvimTreesitterTextobjects.dependencies = { "nvim-treesitter/nvim-treesitter" }

NvimTreesitterTextobjects.opts = {
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = { query = "@function.outer", desc = "Select function outer" },
                ["if"] = { query = "@function.inner", desc = "Select function inner" },
                ["ab"] = { query = "@block.outer", desc = "Select block outer" },
                ["ib"] = { query = "@block.inner", desc = "Select block inner" },
                ["ap"] = { query = "@parameter.outer", desc = "Select parameter outer" },
                ["ip"] = { query = "@parameter.inner", desc = "Select parameter inner" },
                ["ac"] = { query = "@call.outer", desc = "Select call outer" },
                ["ic"] = { query = "@call.inner", desc = "Select call inner" },
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]f"] = "@function.outer",
            },
            goto_next_end = {
                ["]F"] = "@function.outer",
            },
            goto_previous_start = {
                ["[f"] = "@function.outer",
            },
            goto_previous_end = {
                ["[F"] = "@function.outer",
            },
        },
    },
}


NvimTreesitterTextobjects.config = function(_, opts)
    require 'nvim-treesitter.configs'.setup(opts)
end

return NvimTreesitterTextobjects

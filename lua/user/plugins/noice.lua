-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Noice = { "folke/noice.nvim" }

Noice.dependencies = {
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
}

Noice.opts = {
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true,        -- add a border to hover docs and signature help
    },
    cmdline = {
        view = "cmdline"
    }
}

Noice.config = function(_, opts)
    require("noice").setup(opts)
end

return Noice

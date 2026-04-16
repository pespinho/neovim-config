-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Noice = { "folke/noice.nvim" }

Noice.tag = "v4.10.0"

Noice.dependencies = {
    "MunifTanjim/nui.nvim",
}

Noice.opts = {
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
        },
        message = {
            view = "cmdline"
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        long_message_to_split = true, -- long messages will be sent to a split
    },
    cmdline = {
        view = "cmdline"
    },
}

Noice.config = function (_, opts)
    require("noice").setup(opts)
end

return Noice

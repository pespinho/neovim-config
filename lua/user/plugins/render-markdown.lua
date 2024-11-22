-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local RenderMarkdown = { "MeanderingProgrammer/render-markdown.nvim" }

RenderMarkdown.dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.icons"
}

RenderMarkdown.opts = {
    enabled = false,
    anti_conceal = {
        enabled = false,
    }
}

return RenderMarkdown

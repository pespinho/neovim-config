-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local IndentBlankline = { "lukas-reineke/indent-blankline.nvim" }

IndentBlankline.tag = "v3.9.1"

IndentBlankline.opts = {
    scope = {
        show_start = false,
        show_end = false,
    }
}

IndentBlankline.config = function (_, opts)
    require("ibl").setup(opts)
end

return IndentBlankline

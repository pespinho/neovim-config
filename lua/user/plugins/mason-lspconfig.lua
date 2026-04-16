-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local MasonLspconfig = { "mason-org/mason-lspconfig.nvim" }

MasonLspconfig.tag = "v2.1.0"

MasonLspconfig.dependencies = {
    "mason-org/mason.nvim",
    "neovim/nvim-lspconfig",
}

MasonLspconfig.opts = {
    automatic_enable = true,
}

MasonLspconfig.config = function (_, opts)
    require("mason-lspconfig").setup(opts)
end

return MasonLspconfig

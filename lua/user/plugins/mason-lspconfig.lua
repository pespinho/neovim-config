-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local MasonLspconfig = { 'mason-org/mason-lspconfig.nvim' }

MasonLspconfig.dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
}

MasonLspconfig.opts = {
    automatic_enable = true,
}

MasonLspconfig.config = function(_, opts)
    require('mason-lspconfig').setup(opts)
end

return MasonLspconfig

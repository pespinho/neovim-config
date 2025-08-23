-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local MasonLspconfig = { 'williamboman/mason-lspconfig.nvim' }

MasonLspconfig.dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
}

MasonLspconfig.opts = function()
    local opts = {
        ensure_installed = {},
    }

    return opts
end

MasonLspconfig.config = function(_, opts)
    require('mason-lspconfig').setup(opts)
end

return MasonLspconfig

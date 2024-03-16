-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local LspZero = { 'VonHeikemen/lsp-zero.nvim' }

LspZero.branch = 'v3.x'

LspZero.dependencies = {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip'
}

LspZero.config = function(_, opts)
    local lsp_zero = require('lsp-zero')
    lsp_zero.on_attach(require('user.lsp_on_attach'))
end

return LspZero

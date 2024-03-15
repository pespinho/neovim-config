-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local LspZero = { 'VonHeikemen/lsp-zero.nvim' }

LspZero.branch = 'v3.x'

LspZero.dependencies = {
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
}

LspZero.init = function()
    _G["LSP_on_attach_state"] = {}
end

LspZero.opts = function()
    local opts = {}

    opts.on_attach = require('user.lsp_on_attach')

    opts.capabilities = vim.lsp.protocol.make_client_capabilities()

    opts.capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    }

    -- Tell the server the capability of foldingRange,
    -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
    opts.capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
    }

    return opts
end

LspZero.config = function(_, opts)
    local lsp_zero = require('lsp-zero')

    lsp_zero.on_attach = opts.on_attach

    -- to learn how to use mason.nvim with lsp-zero
    -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
            lsp_zero.default_setup,
            lua_ls = function()
                local lua_opts = lsp_zero.nvim_lua_ls()

                lua_opts.capabilities = opts.capabilities
                lua_opts.on_attach = opts.on_attach

                lua_opts.settings.Lua.format = {
                    defaultConfig = {
                        ident_size = 4
                    },
                    enable = true
                }

                require('lspconfig').lua_ls.setup(lua_opts)
            end,
            clangd = function()
                local clangd_opts = {
                    on_attach = opts.on_attach,
                    cmd = {
                        "clangd",
                        "--offset-encoding=utf-16",
                    },
                }

                require('lspconfig').clangd.setup(clangd_opts)
            end
        },
    })
end

return LspZero

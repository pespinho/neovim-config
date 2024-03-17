-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local MasonLspconfig = { 'williamboman/mason-lspconfig.nvim' }

MasonLspconfig.dependencies = {
    'VonHeikemen/lsp-zero.nvim',
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
    'Issafalcon/lsp-overloads.nvim'
}

MasonLspconfig.opts = function()
    local opts = {}

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

MasonLspconfig.config = function(_, opts)
    local lsp_zero = require('lsp-zero')

    -- to learn how to use mason.nvim with lsp-zero
    -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
    require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
            lsp_zero.default_setup,
            lua_ls = function()
                local lua_opts = lsp_zero.nvim_lua_ls()

                lua_opts.capabilities = opts.capabilities

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
                    cmd = {
                        "clangd",
                        "--offset-encoding=utf-16",
                    },
                }

                require('lspconfig').clangd.setup(clangd_opts)
            end,
            omnisharp = function()
                require('lspconfig').omnisharp.setup({})
            end
        },
    })
end

return MasonLspconfig

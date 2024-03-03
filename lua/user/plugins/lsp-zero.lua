-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local function on_attach(client, bufnr)
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end,
        { desc = "LSP declaration", buffer = bufnr })
    vim.keymap.set("n", "gd", require('telescope.builtin').lsp_definitions,
        { desc = "LSP definition", buffer = bufnr })

    local hover = function()
        local winid = require('ufo').peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end

    vim.keymap.set("n", "K", hover, { desc = "LSP hover", buffer = bufnr })

    vim.keymap.set("n", "gi", require('telescope.builtin').lsp_implementations,
        { desc = "LSP implementation", buffer = bufnr })

    vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.signature_help() end,
        { desc = "LSP signature help", buffer = bufnr })

    vim.keymap.set("n", "<leader>D", require('telescope.builtin').lsp_type_definitions,
        { desc = "LSP definition type", buffer = bufnr })

    vim.keymap.set("n", "<leader>ra", function() vim.lsp.buf.rename() end,
        { desc = "LSP rename", buffer = bufnr })

    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
        { desc = "LSP code action", buffer = bufnr })

    vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references,
        { desc = "LSP references", buffer = bufnr })

    vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float { border = "rounded" } end,
        { desc = "Floating diagnostic", buffer = bufnr })

    vim.keymap.set("n", "[d",
        function() vim.diagnostic.goto_prev { float = { border = "rounded" } } end,
        { desc = "Goto prev", buffer = bufnr })

    vim.keymap.set("n", "]d",
        function() vim.diagnostic.goto_next { float = { border = "rounded" } } end,
        { desc = "Goto next", buffer = bufnr })

    vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end,
        { desc = "Diagnostic setloclist", buffer = bufnr })

    vim.keymap.set("n", "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end,
        { desc = "Add workspace folder", buffer = bufnr })

    vim.keymap.set("n", "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end,
        { desc = "Remove workspace folder", buffer = bufnr })

    vim.keymap.set("n", "<leader>wl",
        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
        { desc = "List workspace folders", buffer = bufnr })

    vim.keymap.set("n", "<leader>lo", require('telescope.builtin').lsp_document_symbols,
        { desc = "Outline symbols", buffer = bufnr })

    vim.keymap.set("n", "<leader>ws", require('telescope.builtin').lsp_dynamic_workspace_symbols,
        { desc = "Workspace symbols", buffer = bufnr })

    vim.keymap.set("v", "<leader>ca", function() vim.lsp.buf.code_action() end,
        { desc = "LSP code action", buffer = bufnr })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    require("lsp-zero").buffer_autoformat()

    local function lspSymbol(name, icon)
        local hl = "DiagnosticSign" .. name
        vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
    end

    lspSymbol("Error", "󰅙")
    lspSymbol("Info", "󰋼")
    lspSymbol("Hint", "󰌵")
    lspSymbol("Warn", "")

    vim.diagnostic.config {
        virtual_text = {
            prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
    }
end

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

LspZero.opts = function()
    local opts = {}

    opts.on_attach = on_attach

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
            -- clangd = function()
            --   require('lspconfig').clangd.setup({
            --     on_init = function(client)
            --       client.server_capabilities.semanticTokensProvider = nil
            --     end,
            --   })
            -- end
        },
    })
end

return LspZero

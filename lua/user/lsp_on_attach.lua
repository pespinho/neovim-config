-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local map = vim.keymap.set

local function apply(curr, win)
    local newName = vim.trim(vim.fn.getline ".")
    vim.api.nvim_win_close(win, true)

    if #newName > 0 and newName ~= curr then
        local params = vim.lsp.util.make_position_params()
        params.newName = newName

        vim.lsp.buf_request(0, "textDocument/rename", params)
    end
end

local function renamer()
    local position = vim.api.nvim_win_get_cursor(0)
    local currName = vim.fn.expand "<cword>" .. " "

    local win = require("plenary.popup").create(currName, {
        title = "LSP Rename",
        style = "minimal",
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        relative = "cursor",
        highlight = "TelescopePromptNormal",
        borderhighlight = "TelescopeBorder",
        titlehighlight = "TelescopeTitle",
        focusable = true,
        width = 25,
        height = 1,
        line = "cursor+2",
        col = "cursor-1",
    })

    vim.cmd "normal A"
    vim.cmd "startinsert"

    map({ "i", "n" }, "<Esc>", function()
        vim.api.nvim_win_close(win, true)
        local id; id = vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            callback = function()
                vim.api.nvim_win_set_cursor(0, position)
                vim.api.nvim_del_autocmd(id)
            end
        })
        vim.cmd.stopinsert()
    end, { buffer = 0 })

    map({ "i", "n" }, "<CR>", function()
        apply(currName, win)
        local id; id = vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            callback = function()
                vim.api.nvim_win_set_cursor(0, position)
                vim.api.nvim_del_autocmd(id)
            end
        })
        vim.cmd.stopinsert()
    end, { buffer = 0 })
end

-------------------------------------------------------------------------------
-- MODULE
-------------------------------------------------------------------------------

local LspOnAttach = function(client, bufnr)
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

    if client.server_capabilities.signatureHelpProvider then
        require('lsp-overloads').setup(client, {
            keymaps = {
                next_signature = "<C-j>",
                previous_signature = "<C-k>",
                next_parameter = "<C-l>",
                previous_parameter = "<C-h>",
                close_signature = "<C-e>"
            },
        })
    end

    if pcall(function() return vim.api.nvim_buf_get_var(bufnr, "lsp_on_attach_called") end) then
        return
    end

    vim.api.nvim_buf_set_var(bufnr, "lsp_on_attach_called", true)

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

    vim.keymap.set("n", "<leader>li", require('telescope.builtin').lsp_implementations,
        { desc = "[I]mplementation", buffer = bufnr })

    vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.signature_help() end,
        { desc = "[S]ignature help", buffer = bufnr })

    vim.keymap.set("n", "<leader>lD", require('telescope.builtin').lsp_type_definitions,
        { desc = "[D]efinition type", buffer = bufnr })

    vim.keymap.set("n", "<leader>lr", function() renamer() end,
        { desc = "[R]ename", buffer = bufnr })

    vim.keymap.set({ "n", "v" }, "<leader>la", function() vim.lsp.buf.code_action() end,
        { desc = "Code [a]ction", buffer = bufnr })

    vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references,
        { desc = "LSP [r]eferences", buffer = bufnr })

    vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float { border = "rounded" } end,
        { desc = "Floating [d]iagnostic", buffer = bufnr })

    vim.keymap.set("n", "[d",
        function() vim.diagnostic.goto_prev { float = { border = "rounded" } } end,
        { desc = "Go to prev [d]iagnostic", buffer = bufnr })

    vim.keymap.set("n", "]d",
        function() vim.diagnostic.goto_next { float = { border = "rounded" } } end,
        { desc = "Go to next [d]iagnostic", buffer = bufnr })

    vim.keymap.set("n", "<leader>lo", require('telescope.builtin').lsp_document_symbols,
        { desc = "[O]utline symbols", buffer = bufnr })

    vim.keymap.set("n", "<leader>lf",
        function() vim.lsp.buf.format({ async = true }) end, { desc = "[F]ormat buffer" })

    require("lsp-zero").buffer_autoformat()

    local function lsp_symbol(name, icon)
        local hl = "DiagnosticSign" .. name
        vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
    end

    lsp_symbol("Error", "󰅙")
    lsp_symbol("Warn", "")
    lsp_symbol("Info", "󰋼")
    lsp_symbol("Hint", "󰌵")
    lsp_symbol("Ok", "")

    vim.diagnostic.config {
        virtual_text = {
            prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
    }
end

return LspOnAttach

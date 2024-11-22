vim.api.nvim_create_user_command("DiagnosticToggle", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "toggle diagnostic" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('user-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = 'Visual' })
    end,
})

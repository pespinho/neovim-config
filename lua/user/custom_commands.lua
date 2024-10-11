vim.api.nvim_create_user_command("DiagnosticToggle", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "toggle diagnostic" })

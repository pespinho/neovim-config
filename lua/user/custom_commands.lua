vim.api.nvim_create_user_command("DiagnosticToggle", function()
    local is_disabled = vim.diagnostic.is_disabled(0)
    if is_disabled then
        vim.diagnostic.enable(0)
    else
        vim.diagnostic.disable(0)
        vim.diagnostic.reset(nil, 0)
    end
end, { desc = "toggle diagnostic" })

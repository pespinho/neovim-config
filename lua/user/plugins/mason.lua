-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Mason = { "mason-org/mason.nvim" }

Mason.tag = "v2.2.1"

Mason.cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" }

Mason.opts = {
    ensure_installed = {
        "ansible-lint",
        "ansible-language-server",
        "clangd",
        "basedpyright",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "markdownlint",
        "ruff",
        "vacuum"
    } -- not an option from mason.nvim
}

Mason.config = function (_, opts)
    require("mason").setup(opts)

    local install_all = function ()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
    end

    vim.api.nvim_create_user_command("MasonInstallAll", install_all,
        { desc = "Install all mason binaries listed in the ensure_installed option" })

    vim.g.mason_binaries_list = opts.ensure_installed
end

return Mason

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Mason = { "williamboman/mason.nvim" }

Mason.cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" }

Mason.opts = function()
    return {
        ensure_installed = { "lua-language-server", "clangd" }, -- not an option from mason.nvim

        PATH = "skip",

        ui = {
            icons = {
                package_pending = " ",
                package_installed = "󰄳 ",
                package_uninstalled = " 󰚌",
            },

            keymaps = {
                toggle_server_expand = "<CR>",
                install_server = "i",
                update_server = "u",
                check_server_version = "c",
                update_all_servers = "U",
                check_outdated_servers = "C",
                uninstall_server = "X",
                cancel_installation = "<C-c>",
            },
        },

        max_concurrent_installers = 10,
    }
end

Mason.config = function(_, opts)
    require("mason").setup(opts)

    local install_all = function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
    end

    vim.api.nvim_create_user_command("MasonInstallAll", install_all,
        { desc = "Install all mason binaries listed in the ensure_installed option" })

    vim.g.mason_binaries_list = opts.ensure_installed
end

return Mason

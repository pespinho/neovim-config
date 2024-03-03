-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local autocmds = {

    insert_leave = function()
        local luasnip = require("luasnip")

        if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
            luasnip.unlink_current()
        end
    end
}

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local LuaSnip = { "L3MON4D3/LuaSnip" }

LuaSnip.dependencies = "rafamadriz/friendly-snippets"

LuaSnip.opts = {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    region_check_events = "InsertEnter",
    delete_check_events = "TextChanged,InsertLeave",
}

LuaSnip.config = function(_, opts)
    local luasnip = require("luasnip")

    local loaders = {
        from_vscode = require("luasnip.loaders.from_vscode"),
        from_snipmate = require("luasnip.loaders.from_snipmate"),
        from_lua = require("luasnip.loaders.from_lua"),
    }

    luasnip.config.set_config(opts)

    -- vscode format
    loaders.from_vscode.load()
    loaders.from_vscode.lazy_load { paths = vim.g.vscode_snippets_path or "" }

    -- snipmate format
    loaders.from_snipmate.load()
    loaders.from_snipmate.lazy_load { paths = vim.g.snipmate_snippets_path or "" }

    -- lua format
    loaders.from_lua.load()
    loaders.from_lua.lazy_load { paths = vim.g.lua_snippets_path or "" }

    vim.api.nvim_create_autocmd("InsertLeave", { callback = autocmds.insert_leave })
end

return LuaSnip

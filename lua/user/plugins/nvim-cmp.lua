-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local formatting_style = {
    -- default fields order i.e completion word + item.kind + item.kind icons
    fields = { "abbr", "kind", "menu" },

    format = function(_, item)
        local icon = ""

        icon = (" " .. icon .. " ") or icon
        item.kind = string.format("%s %s", icon, item.kind or "")

        return item
    end,
}

local function border(hl_name)
    return {
        { "╭", hl_name },
        { "─", hl_name },
        { "╮", hl_name },
        { "│", hl_name },
        { "╯", hl_name },
        { "─", hl_name },
        { "╰", hl_name },
        { "│", hl_name },
    }
end

local function tab_keymap(fallback)
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    if cmp.visible() then
        cmp.confirm()
    elseif luasnip.expand_or_jumpable() then
        local characters = vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true)
        vim.fn.feedkeys(characters, "")
    else
        fallback()
    end
end

local function shift_tab_keymap(fallback)
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    if cmp.visible() then
        cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
        local characters = vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true)
        vim.fn.feedkeys(characters, "")
    else
        fallback()
    end
end


-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimCmp = { "hrsh7th/nvim-cmp" }

NvimCmp.event = "InsertEnter"

NvimCmp.dependencies = {
    "L3MON4D3/LuaSnip",
    "windwp/nvim-autopairs",
    -- cmp sources plugins
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
}

NvimCmp.opts = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    return {

        completion = {
            completeopt = "menu,menuone",
        },
        window = {
            completion = {
                border = border("CmpBorder"),
                side_padding = 1,
                scrollbar = false,
            },

            documentation = {
                border = border("CmpDocBorder"),
                winhighlight = "Normal:CmpDoc",
            },
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        formatting = formatting_style,
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-a>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
            ["<Tab>"] = cmp.mapping(tab_keymap, { "i", "s", }),
            ["<S-Tab>"] = cmp.mapping(shift_tab_keymap, { "i", "s", }),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "path" },
        },
    }
end

NvimCmp.config = function(_, opts)
    require "cmp".setup(opts)
end

return NvimCmp

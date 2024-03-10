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

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function tab_keymap(fallback)
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- that way you will only jump inside the snippet region
    elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end

local function shift_tab_keymap(fallback)
    local luasnip = require "luasnip"

    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
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
            ["<Up>"] = cmp.mapping.select_prev_item(),
            ["<Down>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-a>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<Tab>"] = cmp.mapping(tab_keymap, { "i", "s", }),
            ["<S-Tab>"] = cmp.mapping(shift_tab_keymap, { "i", "s", }),
        },
        sources = {
            { name = "copilot" },
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

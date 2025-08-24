-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
}

local formatting_style = {
    -- default fields order i.e completion word + item.kind + item.kind icons
    fields = { "abbr", "kind", "menu" },

    format = function(entry, vim_item)
        local lspkind_ok, lspkind = pcall(require, "lspkind")
        if not lspkind_ok then
            -- From kind_icons array
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
                latex_symbols = "[LaTeX]",
            })[entry.source.name]
            return vim_item
        else
            -- From lspkind
            return lspkind.cmp_format()(entry, vim_item)
        end
    end

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
    local luasnip = require "luasnip"

    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
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
    "saadparwaiz1/cmp_luasnip",
    "windwp/nvim-autopairs",
    -- cmp sources plugins
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "onsails/lspkind.nvim",
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
            ["<C-y>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<C-a>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
            ["<Tab>"] = cmp.mapping(tab_keymap, { "i", "s", }),
            ["<S-Tab>"] = cmp.mapping(shift_tab_keymap, { "i", "s", }),
        },
        sources = {
            { name = "nvim_lsp" },
            { name = 'nvim_lsp_signature_help' },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "path" },
            { name = "cmdline" },
        },
    }
end

NvimCmp.config = function(_, opts)
    local cmp = require("cmp")

    cmp.setup(opts)

    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'nvim_lsp_document_symbol' }
        }, {
            { name = 'buffer' }
        })
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
    })
end

return NvimCmp

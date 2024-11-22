-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local highlight_factories = {
    barbar = function(colors)
        return {
            BufferCurrent = { bg = colors.base, fg = colors.text },
            BufferCurrentIndex = { bg = colors.base, fg = colors.blue },
            BufferCurrentMod = { bg = colors.base, fg = colors.yellow },
            BufferCurrentSign = { bg = colors.base, fg = colors.blue },
            BufferCurrentTarget = { bg = colors.base, fg = colors.red },

            BufferAlternate = { bg = colors.mantle, fg = colors.text },
            BufferAlternateIndex = { bg = colors.mantle, fg = colors.blue },
            BufferAlternateMod = { bg = colors.mantle, fg = colors.overlay0 },
            BufferAlternateSign = { bg = colors.mantle, fg = colors.overlay0 },
            BufferAlternateTarget = { bg = colors.mantle, fg = colors.red },

            BufferVisibleSign = { bg = colors.mantle, fg = colors.overlay0 },
            BufferVisibleMod = { bg = colors.mantle, fg = colors.overlay0 },

            BufferInactiveSign = { bg = colors.mantle, fg = colors.overlay0 },
            BufferInactiveMod = { bg = colors.mantle, fg = colors.overlay0 },
        }
    end,
    trouble = function(colors)
        return {
            TroubleNormal = { bg = colors.mantle, fg = colors.text },
        }
    end,
    neovim = function(colors)
        return {
            MsgArea = { bg = colors.mantle, fg = colors.text },
        }
    end,
}

local function custom_highlights(colors)
    local highlights = {}

    for _, highlight_factory in pairs(highlight_factories) do
        local highlight_group = highlight_factory(colors)

        for key, value in pairs(highlight_group) do
            highlights[key] = value
        end
    end

    return highlights
end

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Catppuccin = { "catppuccin/nvim" }

Catppuccin.name = "catppuccin"

Catppuccin.priority = 1000

Catppuccin.opts = {
    flavour = vim.g.catppuccin,
    integrations = {
        indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
        },
        barbar = true,
        harpoon = true,
        leap = true,
        mason = true,
        -- treesitter_context = true,
        lsp_trouble = true,
        which_key = true
    },
    custom_highlights = custom_highlights,
}

Catppuccin.init = function()
    vim.cmd.colorscheme("catppuccin")
end

return Catppuccin

-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local function setup_autopairs_cmp()
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimAutopairs = { "windwp/nvim-autopairs" }

NvimAutopairs.opts = {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
}

NvimAutopairs.config = function(_, opts)
    require("nvim-autopairs").setup(opts)
    setup_autopairs_cmp()
end

return NvimAutopairs

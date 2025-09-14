-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NoneLs = { "nvimtools/none-ls.nvim" }

NoneLs.dependencies = {
    'VonHeikemen/lsp-zero.nvim',
}

NoneLs.opts = function()
    local null_ls = require("null-ls")

    return {
        sources = {
            null_ls.builtins.diagnostics.ansiblelint,
            null_ls.builtins.formatting.csharpier,
            null_ls.builtins.diagnostics.markdownlint,
            null_ls.builtins.formatting.markdownlint,
        },
        on_attach = require('user.lsp_on_attach')
    }
end

NoneLs.config = function(_, opts)
    require("null-ls").setup(opts)
end

return NoneLs

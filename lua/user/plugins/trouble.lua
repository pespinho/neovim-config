-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local autocmds = {
    file_type = {
        pattern = "Trouble",
        callback = function()
            vim.wo.colorcolumn = ""
        end
    }
}

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Trouble = { "folke/trouble.nvim" }

Trouble.dependencies = { "nvim-tree/nvim-web-devicons" }

Trouble.init = function()
    vim.keymap.set("n", "<leader>tx", "<cmd>TroubleToggle<CR>", { desc = "Trouble toggle" })
end

Trouble.opts = {
    padding = false
}

Trouble.config = function(_, opts)
    require("trouble").setup(opts)

    vim.api.nvim_create_autocmd("FileType", autocmds.file_type)
end

return Trouble

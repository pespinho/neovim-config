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
    vim.keymap.set("n", "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<CR>",
        { desc = "Toggle [w]orkspace diagnostics" })
    vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle todo<CR>", { desc = "Toggle [t]odo" })
    vim.keymap.set("n", "<leader>td", "<cmd>TroubleToggle document_diagnostics<CR>",
        { desc = "Toggle [d]ocument diagnostics" })
    vim.keymap.set("n", "<leader>tc", function() require("trouble").close() end, { desc = "Toggle [c]lose" })
    vim.keymap.set("n", "<leader>tn", function() require("trouble").next({ skip_groups = true, jump = true }) end,
        { desc = "Toggle [n]ext" })
    vim.keymap.set("n", "<leader>tp", function() require("trouble").previous({ skip_groups = true, jump = true }) end,
        { desc = "Toggle [p]revious" })
end

Trouble.opts = {
    padding = false
}

Trouble.config = function(_, opts)
    require("trouble").setup(opts)

    vim.api.nvim_create_autocmd("FileType", autocmds.file_type)
end

return Trouble

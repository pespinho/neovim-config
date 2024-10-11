-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Trouble = { "folke/trouble.nvim" }

Trouble.dependencies = { "nvim-tree/nvim-web-devicons" }

Trouble.init = function()
    vim.keymap.set("n", "<leader>tw", "<cmd>Trouble diagnostics toggle<CR>",
        { desc = "Toggle [w]orkspace diagnostics" })
    vim.keymap.set("n", "<leader>tt", "<cmd>Trouble todo toggle<CR>", { desc = "Toggle [t]odo" })
    vim.keymap.set("n", "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
        { desc = "Toggle [d]ocument diagnostics" })
    vim.keymap.set("n", "<leader>tc", function() require("trouble").close() end, { desc = "Toggle [c]lose" })
    vim.keymap.set("n", "<leader>tn", function() require("trouble").next({ skip_groups = true, jump = true }) end,
        { desc = "Toggle [n]ext" })
    vim.keymap.set("n", "<leader>tp", function() require("trouble").previous({ skip_groups = true, jump = true }) end,
        { desc = "Toggle [p]revious" })
end

Trouble.opts = {
    win = {
        wo = { colorcolumn = "" }
    }
}

Trouble.config = function(_, opts)
    require("trouble").setup(opts)
end

return Trouble

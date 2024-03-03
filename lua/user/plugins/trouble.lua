-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Trouble = { "folke/trouble.nvim" }

Trouble.dependencies = { "nvim-tree/nvim-web-devicons" }

Trouble.init = function()
    vim.keymap.set("n", "<leader>tx", "<cmd>TroubleToggle<CR>", { desc = "Trouble toggle" })
end

return Trouble

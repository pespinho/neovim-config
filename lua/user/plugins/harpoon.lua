-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Harpoon = { "ThePrimeagen/harpoon" }

Harpoon.branch = "harpoon2"

Harpoon.dependencies = { "nvim-lua/plenary.nvim" }

Harpoon.init = function()
    local harpoon = require('harpoon')

    vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end,
        { desc = "Add current file to harpoon" })
    vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Toggle harpoon menu" })

    vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end,
        { desc = "Change to 1st harpoon file" })
    vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end,
        { desc = "Change to 2st harpoon file" })
    vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end,
        { desc = "Change to 3st harpoon file" })
    vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end,
        { desc = "Change to 4st harpoon file" })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end,
        { desc = "Previous harpoon file" })
    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end,
        { desc = "Next harpoon file" })
end

Harpoon.opts = {
    settings = {
        save_on_toggle = true,
    },
}

Harpoon.config = function(_, opts)
    require("harpoon").setup(opts)
end

return Harpoon

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Nvterm = { "NvChad/nvterm" }

Nvterm.init = function()
    -- toggle in terminal mode
    vim.keymap.set("t", "<A-i>", function() require("nvterm.terminal").toggle "float" end,
        { desc = "Toggle floating term" })

    vim.keymap.set("t", "<A-h>", function() require("nvterm.terminal").toggle "horizontal" end,
        { desc = "Toggle horizontal term" })

    vim.keymap.set("t", "<A-v>", function() require("nvterm.terminal").toggle "vertical" end,
        { desc = "Toggle vertical term", })

    -- toggle in normal mode
    vim.keymap.set("n", "<A-i>", function() require("nvterm.terminal").toggle "float" end,
        { desc = "Toggle floating term" })

    vim.keymap.set("n", "<A-h>", function() require("nvterm.terminal").toggle "horizontal" end,
        { desc = "Toggle horizontal term" })

    vim.keymap.set("n", "<A-v>", function() require("nvterm.terminal").toggle "vertical" end,
        { desc = "Toggle vertical term" })

    -- new
    vim.keymap.set("n", "<leader>th", function() require("nvterm.terminal").new "horizontal" end,
        { desc = "New horizontal term" })

    vim.keymap.set("n", "<leader>tv", function() require("nvterm.terminal").new "vertical" end,
        { desc = "New vertical term" })
end

Nvterm.opts = {
    terminals = {
        shell = "bash --login",
    },
}

Nvterm.config = function(_, opts)
    require("nvterm").setup(opts)
end

return Nvterm

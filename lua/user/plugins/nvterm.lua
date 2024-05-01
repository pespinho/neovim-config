-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Nvterm = { "NvChad/nvterm" }

Nvterm.init = function()
    vim.keymap.set("n", "<leader>Tf", function() require("nvterm.terminal").toggle "float" end,
        { desc = "Toggle [f]loating term" })
    vim.keymap.set("n", "<leader>Th", function() require("nvterm.terminal").new "horizontal" end,
        { desc = "New [h]orizontal term" })
    vim.keymap.set("n", "<leader>Tv", function() require("nvterm.terminal").new "vertical" end,
        { desc = "New [v]ertical term" })
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

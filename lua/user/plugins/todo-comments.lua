-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local TodoComments = { "folke/todo-comments.nvim" }

TodoComments.dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim"
}

TodoComments.init = function()
    -- Add telescope keymap.
    vim.keymap.set('n', '<leader>ft', "<cmd> TodoTelescope <CR>", { desc = 'Search [t]odo comments' })
end

TodoComments.config = function(_, opts)
    require("todo-comments").setup(opts)
end

return TodoComments

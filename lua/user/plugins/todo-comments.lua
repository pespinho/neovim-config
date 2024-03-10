-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local TodoComments = { "folke/todo-comments.nvim" }

TodoComments.dependencies = { "nvim-lua/plenary.nvim" }

TodoComments.config = function(_, opts)
    require("todo-comments").setup(opts)
end

return TodoComments

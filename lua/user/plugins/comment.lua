-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Comment = { "numToStr/Comment.nvim" }

Comment.keys = {}

Comment.init = function()
    -- toggle comment in both modes
    vim.keymap.set(
        "n",
        "<leader>/",
        function() require("Comment.api").toggle.linewise.current() end,
        { desc = "Toggle comment ([/] as in C line comments)" }
    )

    vim.keymap.set(
        "v",
        "<leader>/",
        function() require('Comment.api').toggle.linewise(vim.fn.visualmode()) end,
        { desc = "Toggle comment ([/] as in C line comments)" })
end

Comment.config = function(_, opts)
    require("Comment").setup(opts)
end

return Comment

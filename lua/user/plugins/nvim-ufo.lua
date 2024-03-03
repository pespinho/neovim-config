-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimUfo = { "kevinhwang91/nvim-ufo" }

NvimUfo.dependencies = { 'kevinhwang91/promise-async' }

NvimUfo.config = function()
    vim.o.foldcolumn = '0' -- '0' is not bad
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require('ufo').setup()

    vim.keymap.set("n", "zR", function() require('ufo').openAllFolds() end, { desc = "open all folds" })
    vim.keymap.set("n", "zM", function() require('ufo').closeAllFolds() end, { desc = "close all folds" })
    vim.keymap.set("n", "K", function() require('ufo').peekFoldedLinesUnderCursor() end, { desc = "hover" })
end

return NvimUfo

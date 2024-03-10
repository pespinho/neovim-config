-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Barbar = { 'romgrk/barbar.nvim' }

Barbar.dependencies = {
    'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
}

Barbar.init = function()
    vim.g.barbar_auto_setup = false

    -- Move to previous/next
    vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', { desc = "Previous buffer", silent = true })
    vim.keymap.set('n', '<Tab>', '<Cmd>BufferNext<CR>', { desc = "Next buffer", silent = true })
    -- Re-order to previous/next
    vim.keymap.set('n', '<leader>B<', '<Cmd>BufferMovePrevious<CR>', { desc = "Swap buffer left", silent = true })
    vim.keymap.set('n', '<leader>B>', '<Cmd>BufferMoveNext<CR>', { desc = "Swap buffer right", silent = true })
    -- Goto buffer in position...
    vim.keymap.set('n', '<leader>B1', '<Cmd>BufferGoto 1<CR>', { desc = "Go to buffer 1", silent = true })
    vim.keymap.set('n', '<leader>B2', '<Cmd>BufferGoto 2<CR>', { desc = "Go to buffer 2", silent = true })
    vim.keymap.set('n', '<leader>B3', '<Cmd>BufferGoto 3<CR>', { desc = "Go to buffer 3", silent = true })
    vim.keymap.set('n', '<leader>B4', '<Cmd>BufferGoto 4<CR>', { desc = "Go to buffer 4", silent = true })
    vim.keymap.set('n', '<leader>B5', '<Cmd>BufferGoto 5<CR>', { desc = "Go to buffer 5", silent = true })
    vim.keymap.set('n', '<leader>B6', '<Cmd>BufferGoto 6<CR>', { desc = "Go to buffer 6", silent = true })
    vim.keymap.set('n', '<leader>B7', '<Cmd>BufferGoto 7<CR>', { desc = "Go to buffer 7", silent = true })
    vim.keymap.set('n', '<leader>B8', '<Cmd>BufferGoto 8<CR>', { desc = "Go to buffer 8", silent = true })
    vim.keymap.set('n', '<leader>B9', '<Cmd>BufferGoto 9<CR>', { desc = "Go to buffer 9", silent = true })
    vim.keymap.set('n', '<leader>B0', '<Cmd>BufferLast<CR>', { desc = "Go to last buffer", silent = true })
    -- Pin/unpin buffer
    vim.keymap.set('n', '<leader>Bp', '<Cmd>BufferPin<CR>', { desc = "Pin buffer", silent = true })
    -- Close buffer
    vim.keymap.set('n', '<leader>x', '<Cmd>BufferClose<CR>', { desc = "Close buffer", silent = true })
    -- Wipeout buffer
    --                 :BufferWipeout
    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight
    -- Magic buffer-picking mode
    vim.keymap.set('n', '<leader>Bg', '<Cmd>BufferPick<CR>', { desc = "Go to buffer", silent = true })
    -- Sort automatically by...
    vim.keymap.set('n', '<leader>Bn', '<Cmd>BufferOrderByBufferNumber<CR>',
        { desc = "Order buffer by number", silent = true })
    vim.keymap.set('n', '<leader>Bd', '<Cmd>BufferOrderByDirectory<CR>',
        { desc = "Order buffer by directory", silent = true })
    vim.keymap.set('n', '<leader>Bl', '<Cmd>BufferOrderByLanguage<CR>',
        { desc = "Order buffer by language", silent = true })
    vim.keymap.set('n', '<leader>Bw', '<Cmd>BufferOrderByWindowNumber<CR>',
        { desc = "Order buffer by window number", silent = true })
end

Barbar.opts = {
    sidebar_filetypes = {
        NvimTree = true,
    },
    filetype = {
        enabled = true,
    },
    auto_hide = false,
    icons = {
        separator_at_end = false,
    },
    no_name_title = "New Buffer"
}

return Barbar

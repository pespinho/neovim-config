-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

--- Close all open buffers.
--- @return nil
local function close_all()
    local barbar = {
        bbye = require('barbar.bbye'),
        render = { ui = require('barbar.ui.render') },
        state = require('barbar.state'),
    }

    for _, buffer_number in ipairs(barbar.state.buffers) do
        barbar.bbye.bdelete(false, buffer_number)
    end

    barbar.render.ui.update()
end

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
    vim.keymap.set('n', '<leader>b<', '<Cmd>BufferMovePrevious<CR>', { desc = "Swap buffer left", silent = true })
    vim.keymap.set('n', '<leader>b>', '<Cmd>BufferMoveNext<CR>', { desc = "Swap buffer right", silent = true })
    -- Goto buffer in position...
    vim.keymap.set('n', '<leader>bg1', '<Cmd>BufferGoto 1<CR>', { desc = "Buffer [1]", silent = true })
    vim.keymap.set('n', '<leader>bg2', '<Cmd>BufferGoto 2<CR>', { desc = "Buffer [2]", silent = true })
    vim.keymap.set('n', '<leader>bg3', '<Cmd>BufferGoto 3<CR>', { desc = "Buffer [3]", silent = true })
    vim.keymap.set('n', '<leader>bg4', '<Cmd>BufferGoto 4<CR>', { desc = "Buffer [4]", silent = true })
    vim.keymap.set('n', '<leader>bg5', '<Cmd>BufferGoto 5<CR>', { desc = "Buffer [5]", silent = true })
    vim.keymap.set('n', '<leader>bg6', '<Cmd>BufferGoto 6<CR>', { desc = "Buffer [6]", silent = true })
    vim.keymap.set('n', '<leader>bg7', '<Cmd>BufferGoto 7<CR>', { desc = "Buffer [7]", silent = true })
    vim.keymap.set('n', '<leader>bg8', '<Cmd>BufferGoto 8<CR>', { desc = "Buffer [8]", silent = true })
    vim.keymap.set('n', '<leader>bg9', '<Cmd>BufferGoto 9<CR>', { desc = "Buffer [9]", silent = true })
    vim.keymap.set('n', '<leader>bgf', '<Cmd>BufferFirst<CR>', { desc = "[F]irst buffer", silent = true })
    vim.keymap.set('n', '<leader>bgl', '<Cmd>BufferLast<CR>', { desc = "[L]ast buffer", silent = true })
    -- Pin/unpin buffer
    vim.keymap.set('n', '<leader>bP', '<Cmd>BufferPin<CR>', { desc = "[P]in buffer", silent = true })
    -- Close buffer
    vim.keymap.set('n', '<leader>x', '<Cmd>BufferClose<CR>', { desc = "Close buffer (click the [x])", silent = true })
    -- Wipeout buffer
    --                 :BufferWipeout
    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight
    -- Magic buffer-picking mode
    vim.keymap.set('n', '<leader>bp', '<Cmd>BufferPick<CR>', { desc = "[p]ick buffer", silent = true })
    -- Sort automatically by...
    vim.keymap.set('n', '<leader>bon', '<Cmd>BufferOrderByBufferNumber<CR>',
        { desc = "Order buffer by number", silent = true })
    vim.keymap.set('n', '<leader>bod', '<Cmd>BufferOrderByDirectory<CR>',
        { desc = "Order buffer by directory", silent = true })
    vim.keymap.set('n', '<leader>bol', '<Cmd>BufferOrderByLanguage<CR>',
        { desc = "Order buffer by language", silent = true })
    vim.keymap.set('n', '<leader>bow', '<Cmd>BufferOrderByWindowNumber<CR>',
        { desc = "Order buffer by window number", silent = true })

    vim.api.nvim_create_user_command('BufferCloseAll', close_all, { desc = 'Close every buffer' })
    vim.keymap.set('n', '<leader>ba', '<Cmd>BufferCloseAll<CR>', { desc = "Close [a]ll buffers", silent = true })
    vim.keymap.set('n', '<leader>bc', '<Cmd>BufferCloseAllButCurrent<CR>',
        { desc = "Keep only [c]urrent", silent = true })
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

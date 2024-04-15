-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local QfHelper = { 'stevearc/qf_helper.nvim' }

QfHelper.init = function()
    vim.keymap.set('n', '<leader>qd', '<Cmd>Reject<CR>', { desc = "[d]elete entry", silent = true })
    vim.keymap.set('n', '<leader>qc', '<Cmd>Cclear<CR>', { desc = "[c]lear", silent = true })
    vim.keymap.set('n', '<leader>qt', '<Cmd>QFToggle!<CR>', { desc = "[t]oggle quickfix window", silent = true })
    vim.keymap.set('n', '<leader>qn', '<Cmd>QFNext<CR>', { desc = "[n]ext", silent = true })
    vim.keymap.set('n', '<leader>qp', '<Cmd>QFPrev<CR>', { desc = "[p]revious", silent = true })
end

QfHelper.opts = {
    quickfix = {
        default_bindings = false
    },
    loclist = {
        default_bindings = false
    }
}

QfHelper.config = function(_, opts)
    require("qf_helper").setup(opts)
end

return QfHelper

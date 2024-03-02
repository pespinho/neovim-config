-- go to  beginning and end
vim.keymap.set("i", "<C-b>", "<ESC>^i", { desc = "Move to first non-blank character" })
vim.keymap.set("i", "<C-e>", "<End>", { desc = "Move to end of line" })

-- navigate within insert mode
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move cursor right" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move cursor down" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move cursor up" })

-- Clear search highlights on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Move between windows with Ctrl+h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Move focus to left window" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Move focus to right Window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Move focus to window beneath" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Move focus to window above" })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set("n", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("n", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })
vim.keymap.set("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move down", expr = true })
vim.keymap.set("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })

vim.keymap.set("n", "<leader>Eb", "<cmd> enew <CR>", { desc = "New [b]uffer" })
vim.keymap.set('n', '<leader>En', '<cmd> set nu! <CR>', { desc = "Toggle line [n]umber" })
vim.keymap.set('n', '<leader>Er', '<cmd> set rnu! <CR>', { desc = "Toggle line [r]elative number" })

vim.keymap.set("n", "<leader>lf",
    function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP [f]ormatting" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center" })
vim.keymap.set("n", "<n>", "nzzzv", { desc = "Search next and center" })
vim.keymap.set("n", "<N>", "Nzzzv", { desc = "Search previous and center" })

vim.keymap.set("n", "H", "^", { desc = "Move to first non-blank character" })
vim.keymap.set("n", "L", "$", { desc = "Move to end of line" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move focus to left window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move focus to right Window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move focus to window beneath" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move focus to window above" })

vim.keymap.set("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move down", expr = true })
vim.keymap.set("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })
vim.keymap.set("v", "H", "^", { desc = "Move to first non-blank character" })
vim.keymap.set("v", "L", "$", { desc = "Move to end of line" })

vim.keymap.set("x", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "Move down", expr = true })
vim.keymap.set("x", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "Move up", expr = true })

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
vim.keymap.set("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Dont copy replaced text", silent = true })

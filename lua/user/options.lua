-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- nvim-tree instruction: disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set-catppuccin flavor (latte, frappe, macchiato, mocha)
vim.g.catppuccin = "mocha"

-- IDENTATION SETTINGS (check plugin `tpope/vim-sleuth` later, to see if this is necessary)
-- Use the appropriate number of spaces to insert a <Tab>.
vim.opt.expandtab = true
-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4
-- Do smart autoindenting when starting a new line.
vim.opt.smartindent = true
-- Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4
-- Number of spaces that a <Tab> counts for while performing editing operations,
-- like inserting a <Tab> or using <BS>.
vim.opt.softtabstop = 4

-- Do not fill empty lines with a tilde (~).
vim.opt.fillchars = { eob = " " }

-- Make line numbers default.
vim.opt.number = true
-- Show relative line numbers.
vim.opt.relativenumber = true
-- Minimal number of columns to use for the line number.
vim.opt.numberwidth = 2

-- Show the line and column number of the cursor position, separated by a comma.
vim.opt.ruler = false

-- This option helps to avoid all the |hit-enter| prompts caused by file messages
--
-- s: don't give "search hit BOTTOM, continuing at TOP" or	*shm-s* "search hit TOP, continuing at BOTTOM" messages;
--    when using the search count do not show "W" after the count message.
-- I: don't give the intro message when starting Vim
vim.opt.shortmess:append("sI")

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Only the last window will have a status line.
vim.opt.laststatus = 3

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Enables 24-bit RGB color in the |TUI|.  Uses "gui" |:highlight| attributes instead of "cterm" attributes.
vim.opt.termguicolors = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Disable linebreak
vim.opt.linebreak = false

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time:
-- If this many milliseconds nothing is typed the swap file will be written to disk (see |crash-recovery|).
-- Also used for the |CursorHold| autocommand event.
vim.opt.updatetime = 50
-- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.timeoutlen = 400

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Go to previous/next line with h,l,left arrow and right arrow when cursor reaches end/beginning of line:
-- Allow specified keys that move the cursor left/right to move to the previous/next line when the cursor is on the
-- first/last character in the line.
vim.opt.whichwrap:append "<>[]hl"

-- Sets how neovim will display certain whitespace in the editor.
--  See :help 'list'
--  and :help 'listchars'
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- Color the nth column of the editor.
vim.opt.colorcolumn = { "80", "120" }

-- Don't wrap text by default.
vim.opt.wrap = false

-- When there is a previous search pattern, highlight all its matches.
vim.opt.hlsearch = true
-- While typing a search command, show where the pattern, as it was typed so far, matches.
vim.opt.incsearch = true

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

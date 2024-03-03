-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- nvim-tree instruction: disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Setting options ]]

require('user.options')

-- [[ Setting PATH of neovim (still don't know where to put this) ]]

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- [[ Basic Keymaps ]]

require('user.keymaps')

-- [[ Install `lazy.nvim` plugin manager ]]

local Lazy = require("user.lazy")

Lazy.install()

-- [[ Configure and install plugins ]]

Lazy.setup()

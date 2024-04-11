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

-- [[ Basic Keymaps ]]

require('user.keymaps')

-- [[ Custom Commands ]]

require('user.custom_commands')

-- [[ Install `lazy.nvim` plugin manager ]]

local Lazy = require("user.lazy")

Lazy.install()

-- [[ Configure and install plugins ]]

Lazy.setup()

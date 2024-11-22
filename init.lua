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

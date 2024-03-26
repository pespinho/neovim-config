-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

---Echoes a message to the user.
---@param str string The message to echo
local echo = function(str)
    vim.cmd("redraw")
    vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

---Calls an external shell command.
---@param args string[] The command and its arguments.
local function shell_call(args)
    local output = vim.fn.system(args)
    assert(vim.v.shell_error == 0, "External call failed with error code: " .. vim.v.shell_error .. "\n" .. output)
end

---Returns the lazy plugin specification for a given plugin name.
---@return table plugin_spec The lazy plugin specification.
local function plugin(name)
    return require("user.plugins." .. name)
end

---The list of plugins to install and configure.
local specs = {
    plugin("barbar"),
    plugin("catppuccin"),
    plugin("comment"),
    plugin("copilot-chat"),
    plugin("copilot"),
    plugin("diffview"),
    plugin("fidget"),
    plugin("gitsigns"),
    plugin("harpoon"),
    plugin("indent-blankline"),
    plugin("leap"),
    plugin("lsp-overloads"),
    plugin("lsp-zero"),
    plugin("lua-snip"),
    plugin("lualine"),
    plugin("mason-lspconfig"),
    plugin("mason"),
    plugin("none-ls"),
    plugin("nvim-autopairs"),
    plugin("nvim-cmp"),
    plugin("nvim-dap-ui"),
    plugin("nvim-dap"),
    plugin("nvim-foldsign"),
    plugin("nvim-lspconfig"),
    plugin("nvim-soil"),
    plugin("nvim-tree"),
    plugin("nvim-treesitter-context"),
    plugin("nvim-treesitter-playground"),
    plugin("nvim-treesitter-textobjects"),
    plugin("nvim-treesitter"),
    plugin("nvim-ufo"),
    plugin("nvim-web-devicons"),
    plugin("nvterm"),
    plugin("plenary"),
    plugin("promise-async"),
    plugin("rainbow_csv"),
    plugin("telescope-fzf-native"),
    plugin("telescope-ui-select"),
    plugin("telescope"),
    plugin("todo-comments"),
    plugin("trouble"),
    plugin("undotree"),
    plugin("vim-razor"),
    plugin("vim-tmux-navigator"),
    plugin("which-key"),
}

---The lazy plugin manager options.
local opts = {
    install = { colorscheme = { "catppuccin-mocha" } },

    ui = {
        icons = {
            ft = "",
            lazy = "󰂠 ",
            loaded = "",
            not_loaded = "",
        },
    },
}


-------------------------------------------------------------------------------
-- MODULE
-------------------------------------------------------------------------------

local Lazy = {}

-------------------------------------------------------------------------------
-- MODULE - FUNCTIONS
-------------------------------------------------------------------------------

---Installs the lazy plugin manager.
function Lazy.install()
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

    if not vim.loop.fs_stat(lazypath) then
        echo "  Installing lazy.nvim & plugins ..."
        local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
        shell_call({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    end

    vim.opt.rtp:prepend(lazypath)
end

---Sets up the lazy plugin manager and install the configured plugins.
function Lazy.setup()
    require('lazy').setup(specs, opts)
end

return Lazy

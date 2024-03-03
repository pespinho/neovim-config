-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local ensure_installed = {
    "html",
    "vim",
    "vimdoc",
    "lua",
    "c",
    "cpp",
    "bash",
    "markdown",
    "markdown_inline",
    "regex",
    "c_sharp",
    "jsonc",
    "yaml",
    "xml"
}

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimTreesitter = { "nvim-treesitter/nvim-treesitter" }

NvimTreesitter.cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" }

NvimTreesitter.build = ":TSUpdate"

NvimTreesitter.opts = {
    ensure_installed = ensure_installed,
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false
    },

    -- Autoinstall languages that are not installed
    auto_install = true,

    indent = { enable = true },
}

NvimTreesitter.config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
end

return NvimTreesitter

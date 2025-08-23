-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local Telescope = { "nvim-telescope/telescope.nvim" }

Telescope.dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzf-native.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-tree/nvim-web-devicons',
}

Telescope.cmd = "Telescope"

Telescope.init = function()
    vim.keymap.set(
        "n",
        "<leader>fa",
        "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
        { desc = "Find [a]ll" }
    )

    local builtin = require 'telescope.builtin'
    vim.keymap.set("n", "<leader>ft", builtin.git_status, { desc = "Git s[t]atus" })
    vim.keymap.set("n", "<leader>fc", builtin.git_commits, { desc = "Search git [c]ommits" })
    vim.keymap.set("n", "<leader>fv", builtin.git_files, { desc = "Search in git [v]ersioned files" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Search [h]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Search [k]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Search [f]iles' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[S]elect Telescope' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Search current [w]ord' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Search by [g]rep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Search [d]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Search [r]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = 'Search Recent Files ([.] for repeat)' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find existing [b]uffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>fz', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end, { desc = 'Fu[z]zily search in current buffer' })

    -- Also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
        }
    end, { desc = 'Search [/] in Open Files' })

    -- Shortcut for searching your neovim configuration files
    vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Search [n]eovim files' })
end

Telescope.opts = function()
    return {
        defaults = {
            vimgrep_arguments = {
                "rg",
                "-L",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            },
            prompt_prefix = "   ",
            selection_caret = "  ",
            entry_prefix = "  ",
            initial_mode = "insert",
            selection_strategy = "reset",
            sorting_strategy = "ascending",
            layout_strategy = "horizontal",
            layout_config = {
                horizontal = {
                    prompt_position = "top",
                    preview_width = 0.55,
                    results_width = 0.8,
                },
                vertical = {
                    mirror = false,
                },
                width = 0.87,
                height = 0.80,
                preview_cutoff = 120,
            },
            file_sorter = require("telescope.sorters").get_fuzzy_file,
            file_ignore_patterns = { "node_modules" },
            generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
            path_display = { "truncate" },
            winblend = 0,
            border = {},
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            color_devicons = true,
            set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
            file_previewer = require("telescope.previewers").vim_buffer_cat.new,
            grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
            qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
            mappings = {
                n = { ["q"] = require("telescope.actions").close },
            },
        },
        extensions_list = {
            ['ui-select'] = {
                require('telescope.themes').get_dropdown(),
            },
        },
    }
end

Telescope.config = function(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)

    -- load extensions
    for ext, _ in pairs(opts.extensions_list) do
        telescope.load_extension(ext)
    end

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
end

return Telescope

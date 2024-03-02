-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
-- See `:help vim.opt`

require('options')

-- [[ Setting PATH of neovim (still don't know where to put this) ]]

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

require('mappings')

-- [[ Basic Autocommands ]]
--  See :help lua-guide-autocommands

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info

local echo = function(str)
  vim.cmd("redraw")
  vim.api.nvim_echo({ { str, "Bold" } }, true, {})
end

local function shell_call(args)
  local output = vim.fn.system(args)
  assert(vim.v.shell_error == 0, "External call failed with error code: " .. vim.v.shell_error .. "\n" .. output)
end

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  echo "  Installing lazy.nvim & plugins ..."
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  shell_call({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins, you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({

    -- [[ Plugin Specs list ]]

    {
      "nvim-lua/plenary.nvim"
    },

    {
      "nvim-tree/nvim-web-devicons",
      config = function(_, opts)
        require("nvim-web-devicons").setup(opts)
      end,
    },

    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("ibl").setup({
          scope = {
            show_start = false,
            show_end = false,
          },
        })
      end,
    },

    -- git stuff
    {
      "lewis6991/gitsigns.nvim",
      opts = function()
        return {
          signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "󰍵" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "│" },
          }
        }
      end,
      config = function(_, opts)
        require("gitsigns").setup(opts)
      end,
    },

    -- lsp stuff
    {
      "williamboman/mason.nvim",
      cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
      opts = function()
        return {
          ensure_installed = { "lua-language-server" }, -- not an option from mason.nvim

          PATH = "skip",

          ui = {
            icons = {
              package_pending = " ",
              package_installed = "󰄳 ",
              package_uninstalled = " 󰚌",
            },

            keymaps = {
              toggle_server_expand = "<CR>",
              install_server = "i",
              update_server = "u",
              check_server_version = "c",
              update_all_servers = "U",
              check_outdated_servers = "C",
              uninstall_server = "X",
              cancel_installation = "<C-c>",
            },
          },

          max_concurrent_installers = 10,
        }
      end,
      config = function(_, opts)
        ---@diagnostic disable-next-line: different-requires
        require("mason").setup(opts)

        -- custom nvchad cmd to install all mason binaries listed
        vim.api.nvim_create_user_command("MasonInstallAll", function()
          if opts.ensure_installed and #opts.ensure_installed > 0 then
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
          end
        end, {})

        vim.g.mason_binaries_list = opts.ensure_installed
      end,
    },

    {
      "neovim/nvim-lspconfig",
    },

    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      init = function()
        require("catppuccin").setup({
          flavour = "mocha",
          integrations = {
            indent_blankline = {
              enabled = true,
              colored_indent_levels = false,
            },
            barbar = true,
            harpoon = true,
            leap = true,
            mason = true,
            -- treesitter_context = true,
            -- lsp_trouble = true,
            which_key = true
          },
          custom_highlights = function(colors)
            return {
              BufferCurrent = { bg = colors.base, fg = colors.text },
              BufferCurrentIndex = { bg = colors.base, fg = colors.blue },
              BufferCurrentMod = { bg = colors.base, fg = colors.yellow },
              BufferCurrentSign = { bg = colors.base, fg = colors.blue },
              BufferCurrentTarget = { bg = colors.base, fg = colors.red },

              BufferAlternate = { bg = colors.mantle, fg = colors.text },
              BufferAlternateIndex = { bg = colors.mantle, fg = colors.blue },
              BufferAlternateMod = { bg = colors.mantle, fg = colors.yellow },
              BufferAlternateSign = { bg = colors.mantle, fg = colors.overlay0 },
              BufferAlternateTarget = { bg = colors.mantle, fg = colors.red },

              BufferVisibleSign = { bg = colors.mantle, fg = colors.overlay0 },

              BufferInactiveSign = { bg = colors.mantle, fg = colors.overlay0 },
            }
          end
        })
        vim.cmd.colorscheme("catppuccin")
      end,
    },

    -- load luasnips + cmp related in insert mode only
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        {
          -- snippet plugin
          "L3MON4D3/LuaSnip",
          dependencies = "rafamadriz/friendly-snippets",
          opts = {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            region_check_events = "InsertEnter",
            delete_check_events = "TextChanged,InsertLeave",
          },
          config = function(_, opts)
            require("luasnip").config.set_config(opts)

            -- vscode format
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

            -- snipmate format
            require("luasnip.loaders.from_snipmate").load()
            require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

            -- lua format
            require("luasnip.loaders.from_lua").load()
            require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

            vim.api.nvim_create_autocmd("InsertLeave", {
              callback = function()
                if
                    require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                    and not require("luasnip").session.jump_active
                then
                  require("luasnip").unlink_current()
                end
              end,
            })
          end,
        },

        -- autopairing of (){}[] etc
        {
          "windwp/nvim-autopairs",
          opts = {
            fast_wrap = {},
            disable_filetype = { "TelescopePrompt", "vim" },
          },
          config = function(_, opts)
            require("nvim-autopairs").setup(opts)

            -- setup cmp for autopairs
            local cmp_autopairs = require "nvim-autopairs.completion.cmp"
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
          end,
        },

        -- cmp sources plugins
        {
          "saadparwaiz1/cmp_luasnip",
          "hrsh7th/cmp-nvim-lua",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
        },
      },
      opts = function()
        local cmp = require "cmp"

        local cmp_ui = {
          icons = true,
          lspkind_text = true,
          style = "default",            -- default/flat_light/flat_dark/atom/atom_colored
          border_color = "grey_fg",     -- only applicable for "default" style, use color names from base30 variables
          selected_item_bg = "colored", -- colored / simple
        }

        local formatting_style = {
          -- default fields order i.e completion word + item.kind + item.kind icons
          fields = { "abbr", "kind", "menu" },

          format = function(_, item)
            local icon = ""

            icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
            item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")

            return item
          end,
        }

        local function border(hl_name)
          return {
            { "╭", hl_name },
            { "─", hl_name },
            { "╮", hl_name },
            { "│", hl_name },
            { "╯", hl_name },
            { "─", hl_name },
            { "╰", hl_name },
            { "│", hl_name },
          }
        end

        local options = {
          completion = {
            completeopt = "menu,menuone",
          },

          window = {
            completion = {
              border = border("CmpBorder"),
              side_padding = 1,
              scrollbar = false,
            },

            documentation = {
              border = border("CmpDocBorder"),
              winhighlight = "Normal:CmpDoc",
            },
          },

          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },

          formatting = formatting_style,

          mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<CR>"] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            },
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
              else
                fallback()
              end
            end, {
              "i",
              "s",
            }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
              else
                fallback()
              end
            end, {
              "i",
              "s",
            }),
          },
          sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "nvim_lua" },
            { name = "path" },
          },
        }

        return options
      end,
      config = function(_, opts)
        require("cmp").setup(opts)
      end,
    },

    {
      "numToStr/Comment.nvim",
      keys = {
        { "gcc", mode = "n",          desc = "Comment toggle current line" },
        { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
        { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
        { "gbc", mode = "n",          desc = "Comment toggle current block" },
        { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
        { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
      },
      init = function()
        -- toggle comment in both modes
        vim.keymap.set("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end,
          { desc = "Toggle comment" })

        vim.keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
          { desc = "Toggle comment" })
      end,
      config = function(_, opts)
        require("Comment").setup(opts)
      end,
    },

    -- file managing , picker etc
    {
      "nvim-tree/nvim-tree.lua",
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      init = function()
        -- toggle
        vim.keymap.set("n", "<C-n>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })
        -- focus
        vim.keymap.set("n", "<leader>e", "<cmd> NvimTreeFocus <CR>", { desc = "Focus nvimtree" })
      end,
      opts = function()
        return {
          filters = {
            dotfiles = false,
            exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
          },
          disable_netrw = true,
          hijack_netrw = true,
          hijack_cursor = true,
          hijack_unnamed_buffer_when_opening = false,
          sync_root_with_cwd = true,
          update_focused_file = {
            enable = true,
            update_root = false,
          },
          view = {
            adaptive_size = false,
            side = "left",
            width = 30,
            preserve_window_proportions = true,
          },
          git = {
            enable = false,
            ignore = true,
          },
          filesystem_watchers = {
            enable = true,
          },
          actions = {
            open_file = {
              resize_window = false,
            },
          },
          renderer = {
            root_folder_label = false,
            highlight_git = false,
            highlight_opened_files = "none",

            indent_markers = {
              enable = false,
            },

            icons = {
              show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = false,
              },

              glyphs = {
                default = "󰈚",
                symlink = "",
                folder = {
                  default = "",
                  empty = "",
                  empty_open = "",
                  open = "",
                  symlink = "",
                  symlink_open = "",
                  arrow_open = "",
                  arrow_closed = "",
                },
                git = {
                  unstaged = "✗",
                  staged = "✓",
                  unmerged = "",
                  renamed = "➜",
                  untracked = "★",
                  deleted = "",
                  ignored = "◌",
                },
              },
            },
          },
        }
      end,
      config = function(_, opts)
        require("nvim-tree").setup(opts)
      end,
    },

    {
      "nvim-treesitter/nvim-treesitter",
      cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "html", "vim", "vimdoc", "lua", "c", "cpp", "bash",
            "markdown", "markdown_inline", "regex", "c_sharp", "jsonc", "yaml", "xml" },
          highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = false
          },

          -- Autoinstall languages that are not installed
          auto_install = true,

          indent = { enable = true },
        })
      end,
    },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for install instructions
          'nvim-telescope/telescope-fzf-native.nvim',

          -- `build` is used to run some command when the plugin is installed/updated.
          -- This is only run then, not every time Neovim starts up.
          build = 'make',

          -- `cond` is a condition used to determine whether this plugin should be
          -- installed and loaded.
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Useful for getting pretty icons, but requires special font.
        --  If you already have a Nerd Font, or terminal set up with fallback fonts
        --  you can enable this
        { 'nvim-tree/nvim-web-devicons' }
      },
      cmd = "Telescope",
      init = function()
        -- find
        vim.keymap.set("n", "<leader>ff", "<cmd> Telescope find_files <CR>", { desc = "Find files" })
        vim.keymap.set("n", "<leader>fa", "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
          { desc = "Find all" })
        vim.keymap.set("n", "<leader>fw", "<cmd> Telescope live_grep <CR>", { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", "<cmd> Telescope buffers <CR>", { desc = "Find buffers" })
        vim.keymap.set("n", "<leader>fh", "<cmd> Telescope help_tags <CR>", { desc = "Help page" })
        vim.keymap.set("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>", { desc = "Find oldfiles" })
        vim.keymap.set("n", "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <CR>",
          { desc = "Find in current buffer" })
        vim.keymap.set("n", "<leader>fg", require("telescope.builtin").git_files, { desc = "Help page" })

        -- git
        vim.keymap.set("n", "<leader>cm", "<cmd> Telescope git_commits <CR>", { desc = "Git commits" })
        vim.keymap.set("n", "<leader>gt", "<cmd> Telescope git_status <CR>", { desc = "Git status" })

        -- pick a hidden term
        vim.keymap.set("n", "<leader>pt", "<cmd> Telescope terms <CR>", { desc = "Pick hidden term" })

        vim.keymap.set("n", "<leader>ma", "<cmd> Telescope marks <CR>", { desc = "telescope bookmarks" })
      end,
      opts = function()
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

          extensions_list = {},
        }
      end,
      config = function(_, opts)
        ---@diagnostic disable-next-line: different-requires
        local telescope = require("telescope")
        telescope.setup(opts)

        -- load extensions
        for _, ext in ipairs(opts.extensions_list) do
          telescope.load_extension(ext)
        end
      end,
    },

    -- Only load whichkey after all the gui
    {
      "folke/which-key.nvim",
      keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
      init = function()
        vim.keymap.set("n", "<leader>wK", function() vim.cmd("WhichKey") end, { desc = "Which-key all keymaps" })
        vim.keymap.set(
          "n",
          "<leader>wk",
          function()
            local input = vim.fn.input "WhichKey: "
            vim.cmd("WhichKey " .. input)
          end,
          { desc = "Which-key query lookup" }
        )
      end,
      cmd = "WhichKey",
      config = function(_, opts)
        require("which-key").setup(opts)
      end,
    },

    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function()
        vim.g.barbar_auto_setup = false

        -- Move to previous/next
        vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferPrevious<CR>', { desc = "Previous buffer", silent = true })
        vim.keymap.set('n', '<Tab>', '<Cmd>BufferNext<CR>', { desc = "Next buffer", silent = true })
        -- Re-order to previous/next
        -- vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', { desc = "", silent = true })
        -- Goto buffer in position...
        -- vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', { desc = "", silent = true })
        -- Pin/unpin buffer
        -- vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', { desc = "", silent = true })
        -- Close buffer
        vim.keymap.set('n', '<leader>x', '<Cmd>BufferClose<CR>', { desc = "Close buffer", silent = true })
        -- Wipeout buffer
        --                 :BufferWipeout
        -- Close commands
        --                 :BufferCloseAllButCurrent
        --                 :BufferCloseAllButPinned
        --                 :BufferCloseAllButCurrentOrPinned
        --                 :BufferCloseBuffersLeft
        --                 :BufferCloseBuffersRight
        -- Magic buffer-picking mode
        -- vim.keymap.set('n', '<C-p>', '<Cmd>BufferPick<CR>', { desc = "", silent = true })
        -- Sort automatically by...
        -- vim.keymap.set('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', { desc = "", silent = true })
        -- vim.keymap.set('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', { desc = "", silent = true })
      end,
      opts = {
        -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
        -- animation = true,
        -- insert_at_start = true,
        -- …etc.
        -- Set the filetypes which barbar will offset itself for
        sidebar_filetypes = {
          NvimTree = true,
        },
        filetype = {
          enabled = true,
        },
        auto_hide = 1,
        icons = {
          separator_at_end = false,
        }
      },
    },

    {
      "NvChad/nvterm",
      init = function()
        -- toggle in terminal mode
        vim.keymap.set("t", "<A-i>", function() require("nvterm.terminal").toggle "float" end,
          { desc = "Toggle floating term" })

        vim.keymap.set("t", "<A-h>", function() require("nvterm.terminal").toggle "horizontal" end,
          { desc = "Toggle horizontal term" })

        vim.keymap.set("t", "<A-v>", function() require("nvterm.terminal").toggle "vertical" end,
          { desc = "Toggle vertical term", })

        -- toggle in normal mode
        vim.keymap.set("n", "<A-i>", function() require("nvterm.terminal").toggle "float" end,
          { desc = "Toggle floating term" })

        vim.keymap.set("n", "<A-h>", function() require("nvterm.terminal").toggle "horizontal" end,
          { desc = "Toggle horizontal term" })

        vim.keymap.set("n", "<A-v>", function() require("nvterm.terminal").toggle "vertical" end,
          { desc = "Toggle vertical term" })

        -- new
        vim.keymap.set("n", "<leader>th", function() require("nvterm.terminal").new "horizontal" end,
          { desc = "New horizontal term" })

        vim.keymap.set("n", "<leader>tv", function() require("nvterm.terminal").new "vertical" end,
          { desc = "New vertical term" })
      end,
      config = function()
        require("nvterm").setup {
          terminals = {
            shell = "bash --login",
          },
        }
      end,
    },

    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup({
          extensions = { 'nvim-tree' },
          options = {
            theme = "catppuccin-mocha"
          }
        })
      end
    },

    {
      "christoomey/vim-tmux-navigator",
      init = function()
        vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Move to left window" })
        vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Move to right window" })
        vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Move to window beneath" })
        vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Move to window above" })
      end,
    },

    {
      "nvim-treesitter/playground",
    },

    {
      "mbbill/undotree",
      keys = {
        { "<leader><F5>", ":UndotreeToggle<CR>", desc = "Toggle Undotree" },
      },
    },

    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      init = function()
        local harpoon = require('harpoon')
        vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end,
          { desc = "Add current file to harpoon" })
        vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
          { desc = "Toggle harpoon menu" })

        vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end,
          { desc = "Change to 1st harpoon file" })
        vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end,
          { desc = "Change to 2st harpoon file" })
        vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end,
          { desc = "Change to 3st harpoon file" })
        vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end,
          { desc = "Change to 4st harpoon file" })

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Previous harpoon file" })
        vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Next harpoon file" })
      end,
      config = function()
        require("harpoon").setup()
      end
    },

    {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v3.x',
      dependencies = {
        'neovim/nvim-lspconfig',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/nvim-cmp',
        'L3MON4D3/LuaSnip',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
      },
      opts = function()
        local opts = {}
        opts.on_attach = function(_, bufnr)
          vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end,
            { desc = "LSP declaration", buffer = bufnr })
          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "LSP definition", buffer = bufnr })

          local hover = function()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            if not winid then
              vim.lsp.buf.hover()
            end
          end

          vim.keymap.set("n", "K", hover, { desc = "LSP hover", buffer = bufnr })

          vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end,
            { desc = "LSP implementation", buffer = bufnr })

          vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.signature_help() end,
            { desc = "LSP signature help", buffer = bufnr })

          vim.keymap.set("n", "<leader>D", function() vim.lsp.buf.type_definition() end,
            { desc = "LSP definition type", buffer = bufnr })

          vim.keymap.set("n", "<leader>ra", function() require("nvchad.renamer").open() end,
            { desc = "LSP rename", buffer = bufnr })

          vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
            { desc = "LSP code action", buffer = bufnr })

          vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, { desc = "LSP references", buffer = bufnr })

          vim.keymap.set("n", "<leader>fd", function() vim.diagnostic.open_float { border = "rounded" } end,
            { desc = "Floating diagnostic", buffer = bufnr })

          vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev { float = { border = "rounded" } } end,
            { desc = "Goto prev", buffer = bufnr })

          vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next { float = { border = "rounded" } } end,
            { desc = "Goto next", buffer = bufnr })

          vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end,
            { desc = "Diagnostic setloclist", buffer = bufnr })

          vim.keymap.set("n", "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end,
            { desc = "Add workspace folder", buffer = bufnr })

          vim.keymap.set("n", "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end,
            { desc = "Remove workspace folder", buffer = bufnr })

          vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            { desc = "List workspace folders", buffer = bufnr })

          vim.keymap.set("v", "<leader>ca", function() vim.lsp.buf.code_action() end,
            { desc = "LSP code action", buffer = bufnr })

          require("lsp-zero").buffer_autoformat()

          local function lspSymbol(name, icon)
            local hl = "DiagnosticSign" .. name
            vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
          end

          lspSymbol("Error", "󰅙")
          lspSymbol("Info", "󰋼")
          lspSymbol("Hint", "󰌵")
          lspSymbol("Warn", "")

          vim.diagnostic.config {
            virtual_text = {
              prefix = "",
            },
            signs = true,
            underline = true,
            update_in_insert = false,
          }
        end

        opts.capabilities = vim.lsp.protocol.make_client_capabilities()

        opts.capabilities.textDocument.completion.completionItem = {
          documentationFormat = { "markdown", "plaintext" },
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        }

        -- Tell the server the capability of foldingRange,
        -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
        opts.capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true
        }

        return opts
      end,
      config = function(_, opts)
        local lsp_zero = require('lsp-zero')

        lsp_zero.on_attach = opts.on_attach

        -- to learn how to use mason.nvim with lsp-zero
        -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
        require('mason').setup({})
        require('mason-lspconfig').setup({
          ensure_installed = {},
          handlers = {
            lsp_zero.default_setup,
            lua_ls = function()
              local lua_opts = lsp_zero.nvim_lua_ls()

              lua_opts.capabilities = opts.capabilities
              lua_opts.on_attach = opts.on_attach

              lua_opts.settings.Lua.format = {
                defaultConfig = {
                  ident_size = 4
                },
                enable = true
              }

              require('lspconfig').lua_ls.setup(lua_opts)
            end,
            -- clangd = function()
            --   require('lspconfig').clangd.setup({
            --     on_init = function(client)
            --       client.server_capabilities.semanticTokensProvider = nil
            --     end,
            --   })
            -- end
          },
        })
      end
    },

    {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      init = function()
        vim.keymap.set("n", "<leader>tx", "<cmd>TroubleToggle<CR>", { desc = "Trouble toggle" })
      end,
    },

    {
      "mfussenegger/nvim-dap",
      config = function()
        local dap = require('dap')
        dap.adapters.lldb = {
          type = 'executable',
          command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- adjust as needed, must be absolute path
          name = 'lldb'
        }
        dap.adapters["local-lua"] = {
          type = "executable",
          command = "node",
          args = {
            "/home/sxa2lol/dev/repos/local-lua-debugger-vscode/extension/debugAdapter.js"
          },
          enrich_config = function(config, on_config)
            if not config["extensionPath"] then
              local c = vim.deepcopy(config)
              -- 💀 If this is missing or wrong you'll see
              -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
              c.extensionPath = "/home/sxa2lol/dev/repos/local-lua-debugger-vscode/"
              on_config(c)
            else
              on_config(config)
            end
          end,
        }

        dap.configurations.cpp = {
          {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            -- 💀
            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Otherwise you might get the following error:
            --
            --    Error on launch: Failed to attach to the target process
            --
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            runInTerminal = true,
          },
        }

        dap.configurations.lua = {
          {
            name = 'Debug',
            type = 'local-lua',
            request = 'launch',
            program = {
              lua = "lua5.3",
              file = function()
                return vim.fn.input('Path to lua script: ', './', 'file')
              end
            },
            cwd = function()
              return vim.fn.input('Path to workspace: ', vim.fn.getcwd() .. '/', 'file')
            end,
            stopOnEntry = false,
            -- 💀
            -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
            --
            --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
            --
            -- Otherwise you might get the following error:
            --
            --    Error on launch: Failed to attach to the target process
            --
            -- But you should be aware of the implications:
            -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
            runInTerminal = true,
          },
        }


        vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '' })
        vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '' })
        vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '' })

        vim.fn.sign_define('DapBreakpoint', {
          text = '',
          texthl = 'DapBreakpoint',
          linehl = '',
          numhl = ''
        })
        vim.fn.sign_define('DapBreakpointCondition',
          { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointRejected',
          { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
        vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped', { text = '󰜴', texthl = 'DapStopped', linehl = '', numhl = '' })


        require('dap.ext.vscode').load_launchjs(nil, { lldb = { 'c', 'cpp' } })

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          pattern = { "launch.json" },
          callback = function()
            require('dap.ext.vscode').load_launchjs(nil, { lldb = { 'c', 'cpp' } })
            return false
          end
        })
      end,
      keys = {
        { '<F5>',    function() require('dap').continue() end,          desc = "Debug continue" },
        { '<S-F5>',  function() require('dap').terminate() end,         desc = "Debug terminate" },
        { '<F10>',   function() require('dap').step_over() end,         desc = "Step Over" },
        { '<F11>',   function() require('dap').step_into() end,         desc = "Step Into" },
        { '<S-F11>', function() require('dap').step_out() end,          desc = "Step Out" },
        { '<F9>',    function() require('dap').toggle_breakpoint() end, desc = "Toggle Breakpoint" },
        {
          '<leader>dh',
          function() require('dap.ui.widgets').hover() end,
          mode = { "n", "v" },
          desc =
          "DAP Hover"
        },
        {
          '<leader>dp',
          function() require('dap.ui.widgets').preview() end,
          mode = { "n", "v" },
          desc =
          "DAP Preview"
        },
        {
          '<leader>df',
          function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
          end,
          mode = { "n" },
          desc = "DAP Frames"
        },
        {
          '<leader>ds',
          function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
          end,
          mode = { "n" },
          desc = "DAP Scopes"
        },
      }
    },

    {
      "rcarriga/nvim-dap-ui",
      config = function()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close()
        end
      end
    },

    {
      "nvim-treesitter/nvim-treesitter-context",
      config = function()
        require 'treesitter-context'.setup {
          enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
          max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
          min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
          line_numbers = true,
          multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
          trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
          mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
          -- Separator between context and content. Should be a single character string, like '-'.
          -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
          separator = nil,
          zindex = 20,     -- The Z-index of the context window
          on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
        }
      end
    },

    {
      "jlcrochet/vim-razor",
    },

    {
      "ggandor/leap.nvim",
      config = function()
        require('leap').add_default_mappings()
      end
    },

    {
      'javiorfo/nvim-soil',
      lazy = false,
      ft = "plantuml",
      config = function()
        -- If you want to change default configurations
      end
    },

    {
      "folke/todo-comments.nvim",
      lazy = false,
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    },

    {
      "nvimtools/none-ls.nvim",
      lazy = false,
      config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
          sources = {
            null_ls.builtins.diagnostics.markdownlint,
            null_ls.builtins.formatting.markdownlint,
          },
        })
      end
    },

    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = false,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter" }
      },
      config = function()
        require 'nvim-treesitter.configs'.setup {
          textobjects = {
            select = {
              enable = true,

              -- Automatically jump forward to textobj, similar to targets.vim
              lookahead = true,

              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = { query = "@function.outer", desc = "Select function outer" },
                ["if"] = { query = "@function.inner", desc = "Select function inner" },
                ["ab"] = { query = "@block.outer", desc = "Select block outer" },
                ["ib"] = { query = "@block.inner", desc = "Select block inner" },
                ["ap"] = { query = "@parameter.outer", desc = "Select parameter outer" },
                ["ip"] = { query = "@parameter.inner", desc = "Select parameter inner" },
                ["ac"] = { query = "@call.outer", desc = "Select call outer" },
                ["ic"] = { query = "@call.inner", desc = "Select call inner" },
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                ["]f"] = "@function.outer",
              },
              goto_next_end = {
                ["]F"] = "@function.outer",
              },
              goto_previous_start = {
                ["[f"] = "@function.outer",
              },
              goto_previous_end = {
                ["[F"] = "@function.outer",
              },
            },
          },
        }
      end
    },

    {
      "zbirenbaum/copilot.lua",
      config = function()
        require("copilot").setup({
          filetypes = {
            lua = true
          },
          suggestion = {
            auto_trigger = true
          }
        })
      end
    },

    {
      "kevinhwang91/nvim-ufo",
      init = function()
        vim.keymap.set("n", "zR", function() require('ufo').openAllFolds() end, { desc = "open all folds" })
        vim.keymap.set("n", "zM", function() require('ufo').closeAllFolds() end, { desc = "close all folds" })
        vim.keymap.set("n", "K", function() require('ufo').peekFoldedLinesUnderCursor() end, { desc = "hover" })
      end,
      config = function()
        vim.o.foldcolumn = '0' -- '0' is not bad
        vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        require('ufo').setup()
        vim.keymap.set("n", "zR", function() require('ufo').openAllFolds() end, { desc = "open all folds" })
        vim.keymap.set("n", "zM", function() require('ufo').closeAllFolds() end, { desc = "close all folds" })
        vim.keymap.set("n", "K", function() require('ufo').peekFoldedLinesUnderCursor() end, { desc = "hover" })
      end,
      dependencies = {
        { 'kevinhwang91/promise-async' }
      }
    },

    {
      "yaocccc/nvim-foldsign",
      event = "CursorHold",
      config = function()
        require('nvim-foldsign').setup({
          offset = -2,
          foldsigns = {
            open = '', -- mark the beginning of a fold
            close = '', -- show a closed fold
            seps = { '│' }, -- open fold middle marker
          }
        })
      end
    },

    {
      'cameron-wags/rainbow_csv.nvim',
      config = true,
      ft = {
        'csv',
        'tsv',
        'csv_semicolon',
        'csv_whitespace',
        'csv_pipe',
        'rfc_csv',
        'rfc_semicolon'
      },
      cmd = {
        'RainbowDelim',
        'RainbowDelimSimple',
        'RainbowDelimQuoted',
        'RainbowMultiDelim'
      }
    }

    -- -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
    -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    --
    -- -- NOTE: Plugins can also be added by using a table,
    -- -- with the first argument being the link and the following
    -- -- keys can be used to configure plugin behavior/loading/etc.
    -- --
    -- -- Use `opts = {}` to force a plugin to be loaded.
    -- --
    -- --  This is equivalent to:
    -- --    require('Comment').setup({})
    --
    -- -- "gc" to comment visual regions/lines
    -- { 'numToStr/Comment.nvim',    opts = {} },
    --
    -- -- Here is a more advanced example where we pass configuration
    -- -- options to `gitsigns.nvim`. This is equivalent to the following lua:
    -- --    require('gitsigns').setup({ ... })
    -- --
    -- -- See `:help gitsigns` to understand what the configuration keys do
    -- { -- Adds git related signs to the gutter, as well as utilities for managing changes
    --   'lewis6991/gitsigns.nvim',
    --   opts = {
    --     signs = {
    --       add = { text = '+' },
    --       change = { text = '~' },
    --       delete = { text = '_' },
    --       topdelete = { text = '‾' },
    --       changedelete = { text = '~' },
    --     },
    --   },
    -- },
    --
    -- -- NOTE: Plugins can also be configured to run lua code when they are loaded.
    -- --
    -- -- This is often very useful to both group configuration, as well as handle
    -- -- lazy loading plugins that don't need to be loaded immediately at startup.
    -- --
    -- -- For example, in the following configuration, we use:
    -- --  event = 'VeryLazy'
    -- --
    -- -- which loads which-key after all the UI elements are loaded. Events can be
    -- -- normal autocommands events (:help autocomd-events).
    -- --
    -- -- Then, because we use the `config` key, the configuration only runs
    -- -- after the plugin has been loaded:
    -- --  config = function() ... end
    --
    -- {                     -- Useful plugin to show you pending keybinds.
    --   'folke/which-key.nvim',
    --   event = 'VeryLazy', -- Sets the loading event to 'VeryLazy'
    --   config = function() -- This is the function that runs, AFTER loading
    --     require('which-key').setup()
    --
    --     -- Document existing key chains
    --     require('which-key').register {
    --       ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    --       ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
    --       ['<leader>E'] = { name = '[E]ditor', _ = 'which_key_ignore' },
    --       ['<leader>l'] = { name = '[L]SP', _ = 'which_key_ignore' },
    --       ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
    --       ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
    --       ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    --     }
    --   end,
    -- },
    --
    -- NOTE: Plugins can specify dependencies.
    --
    -- The dependencies are proper plugin specifications as well - anything
    -- you do for a plugin at the top level, you can do for a dependency.
    --
    -- Use the `dependencies` key to specify the dependencies of a particular plugin

    -- { -- Fuzzy Finder (files, lsp, etc)
    --   'nvim-telescope/telescope.nvim',
    --   event = 'VeryLazy',
    --   branch = '0.1.x',
    --   dependencies = {
    --     'nvim-lua/plenary.nvim',
    --     { -- If encountering errors, see telescope-fzf-native README for install instructions
    --       'nvim-telescope/telescope-fzf-native.nvim',
    --
    --       -- `build` is used to run some command when the plugin is installed/updated.
    --       -- This is only run then, not every time Neovim starts up.
    --       build = 'make',
    --
    --       -- `cond` is a condition used to determine whether this plugin should be
    --       -- installed and loaded.
    --       cond = function()
    --         return vim.fn.executable 'make' == 1
    --       end,
    --     },
    --     { 'nvim-telescope/telescope-ui-select.nvim' },
    --
    --     -- Useful for getting pretty icons, but requires special font.
    --     --  If you already have a Nerd Font, or terminal set up with fallback fonts
    --     --  you can enable this
    --     -- { 'nvim-tree/nvim-web-devicons' }
    --   },
    --   config = function()
    --     -- Telescope is a fuzzy finder that comes with a lot of different things that
    --     -- it can fuzzy find! It's more than just a "file finder", it can search
    --     -- many different aspects of Neovim, your workspace, LSP, and more!
    --     --
    --     -- The easiest way to use telescope, is to start by doing something like:
    --     --  :Telescope help_tags
    --     --
    --     -- After running this command, a window will open up and you're able to
    --     -- type in the prompt window. You'll see a list of help_tags options and
    --     -- a corresponding preview of the help.
    --     --
    --     -- Two important keymaps to use while in telescope are:
    --     --  - Insert mode: <c-/>
    --     --  - Normal mode: ?
    --     --
    --     -- This opens a window that shows you all of the keymaps for the current
    --     -- telescope picker. This is really useful to discover what Telescope can
    --     -- do as well as how to actually do it!
    --
    --     -- [[ Configure Telescope ]]
    --     -- See `:help telescope` and `:help telescope.setup()`
    --     require('telescope').setup {
    --       -- You can put your default mappings / updates / etc. in here
    --       --  All the info you're looking for is in `:help telescope.setup()`
    --       --
    --       -- defaults = {
    --       --   mappings = {
    --       --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
    --       --   },
    --       -- },
    --       -- pickers = {}
    --       extensions = {
    --         ['ui-select'] = {
    --           require('telescope.themes').get_dropdown(),
    --         },
    --       },
    --     }
    --
    --     -- Enable telescope extensions, if they are installed
    --     pcall(require('telescope').load_extension, 'fzf')
    --     pcall(require('telescope').load_extension, 'ui-select')
    --
    --     -- See `:help telescope.builtin`
    --     local builtin = require 'telescope.builtin'
    --     vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    --     vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    --     vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    --     vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    --     vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    --     vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    --     vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    --     vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    --     vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    --     vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    --
    --     -- Slightly advanced example of overriding default behavior and theme
    --     vim.keymap.set('n', '<leader>/', function()
    --       -- You can pass additional configuration to telescope to change theme, layout, etc.
    --       builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --         winblend = 10,
    --         previewer = false,
    --       })
    --     end, { desc = '[/] Fuzzily search in current buffer' })
    --
    --     -- Also possible to pass additional configuration options.
    --     --  See `:help telescope.builtin.live_grep()` for information about particular keys
    --     vim.keymap.set('n', '<leader>s/', function()
    --       builtin.live_grep {
    --         grep_open_files = true,
    --         prompt_title = 'Live Grep in Open Files',
    --       }
    --     end, { desc = '[S]earch [/] in Open Files' })
    --
    --     -- Shortcut for searching your neovim configuration files
    --     vim.keymap.set('n', '<leader>sn', function()
    --       builtin.find_files { cwd = vim.fn.stdpath 'config' }
    --     end, { desc = '[S]earch [N]eovim files' })
    --   end,
    -- },
    --
    -- { -- LSP Configuration & Plugins
    --   'neovim/nvim-lspconfig',
    --   dependencies = {
    --     -- Automatically install LSPs and related tools to stdpath for neovim
    --     'williamboman/mason.nvim',
    --     'williamboman/mason-lspconfig.nvim',
    --     'WhoIsSethDaniel/mason-tool-installer.nvim',
    --
    --     -- Useful status updates for LSP.
    --     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    --     { 'j-hui/fidget.nvim', opts = {} },
    --   },
    --   config = function()
    --     -- Brief Aside: **What is LSP?**
    --     --
    --     -- LSP is an acronym you've probably heard, but might not understand what it is.
    --     --
    --     -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    --     -- and language tooling communicate in a standardized fashion.
    --     --
    --     -- In general, you have a "server" which is some tool built to understand a particular
    --     -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
    --     -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    --     -- processes that communicate with some "client" - in this case, Neovim!
    --     --
    --     -- LSP provides Neovim with features like:
    --     --  - Go to definition
    --     --  - Find references
    --     --  - Autocompletion
    --     --  - Symbol Search
    --     --  - and more!
    --     --
    --     -- Thus, Language Servers are external tools that must be installed separately from
    --     -- Neovim. This is where `mason` and related plugins come into play.
    --     --
    --     -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    --     -- and elegantly composed help section, :help lsp-vs-treesitter
    --
    --     --  This function gets run when an LSP attaches to a particular buffer.
    --     --    That is to say, every time a new file is opened that is associated with
    --     --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --     --    function will be executed to configure the current buffer
    --
    --     vim.api.nvim_create_autocmd('LspAttach', {
    --       group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    --       callback = function(event)
    --         -- NOTE: Remember that lua is a real programming language, and as such it is possible
    --         -- to define small helper and utility functions so you don't have to repeat yourself
    --         -- many times.
    --         --
    --         -- In this case, we create a function that lets us more easily define mappings specific
    --         -- for LSP related items. It sets the mode, buffer and description for us each time.
    --         local map = function(keys, func, desc)
    --           vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    --         end
    --
    --         -- Jump to the definition of the word under your cursor.
    --         --  This is where a variable was first declared, or where a function is defined, etc.
    --         --  To jump back, press <C-T>.
    --         map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    --
    --         -- Find references for the word under your cursor.
    --         map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    --
    --         -- Jump to the implementation of the word under your cursor.
    --         --  Useful when your language has ways of declaring types without an actual implementation.
    --         map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    --
    --         -- Jump to the type of the word under your cursor.
    --         --  Useful when you're not sure what type a variable is and you want to see
    --         --  the definition of its *type*, not where it was *defined*.
    --         map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    --
    --         -- Fuzzy find all the symbols in your current document.
    --         --  Symbols are things like variables, functions, types, etc.
    --         map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    --
    --         -- Fuzzy find all the symbols in your current workspace
    --         --  Similar to document symbols, except searches over your whole project.
    --         map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    --
    --         -- Rename the variable under your cursor
    --         --  Most Language Servers support renaming across files, etc.
    --         map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    --
    --         -- Execute a code action, usually your cursor needs to be on top of an error
    --         -- or a suggestion from your LSP for this to activate.
    --         map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    --
    --         -- Opens a popup that displays documentation about the word under your cursor
    --         --  See `:help K` for why this keymap
    --         map('K', vim.lsp.buf.hover, 'Hover Documentation')
    --
    --         -- WARN: This is not Goto Definition, this is Goto Declaration.
    --         --  For example, in C this would take you to the header
    --         map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    --
    --         -- The following two autocommands are used to highlight references of the
    --         -- word under your cursor when your cursor rests there for a little while.
    --         --    See `:help CursorHold` for information about when this is executed
    --         --
    --         -- When you move your cursor, the highlights will be cleared (the second autocommand).
    --         local client = vim.lsp.get_client_by_id(event.data.client_id)
    --         if client and client.server_capabilities.documentHighlightProvider then
    --           vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    --             buffer = event.buf,
    --             callback = vim.lsp.buf.document_highlight,
    --           })
    --
    --           vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    --             buffer = event.buf,
    --             callback = vim.lsp.buf.clear_references,
    --           })
    --         end
    --       end,
    --     })
    --
    --     -- LSP servers and clients are able to communicate to each other what features they support.
    --     --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --     --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --     --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    --     local capabilities = vim.lsp.protocol.make_client_capabilities()
    --     capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    --
    --     -- Enable the following language servers
    --     --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --     --
    --     --  Add any additional override configuration in the following tables. Available keys are:
    --     --  - cmd (table): Override the default command used to start the server
    --     --  - filetypes (table): Override the default list of associated filetypes for the server
    --     --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --     --  - settings (table): Override the default settings passed when initializing the server.
    --     --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    --     local servers = {
    --       -- clangd = {},
    --       -- gopls = {},
    --       -- pyright = {},
    --       -- rust_analyzer = {},
    --       -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
    --       --
    --       -- Some languages (like typescript) have entire language plugins that can be useful:
    --       --    https://github.com/pmizio/typescript-tools.nvim
    --       --
    --       -- But for many setups, the LSP (`tsserver`) will work just fine
    --       -- tsserver = {},
    --       --
    --
    --       lua_ls = {
    --         -- cmd = {...},
    --         -- filetypes { ...},
    --         -- capabilities = {},
    --         settings = {
    --           Lua = {
    --             runtime = { version = 'LuaJIT' },
    --             workspace = {
    --               checkThirdParty = false,
    --               -- Tells lua_ls where to find all the Lua files that you have loaded
    --               -- for your neovim configuration.
    --               library = {
    --                 '${3rd}/luv/library',
    --                 unpack(vim.api.nvim_get_runtime_file('', true)),
    --               },
    --               -- If lua_ls is really slow on your computer, you can try this instead:
    --               -- library = { vim.env.VIMRUNTIME },
    --             },
    --             -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
    --             -- diagnostics = { disable = { 'missing-fields' } },
    --           },
    --         },
    --       },
    --     }
    --
    --     -- Ensure the servers and tools above are installed
    --     --  To check the current status of installed tools and/or manually install
    --     --  other tools, you can run
    --     --    :Mason
    --     --
    --     --  You can press `g?` for help in this menu
    --     require('mason').setup()
    --
    --     -- You can add other tools here that you want Mason to install
    --     -- for you, so that they are available from within Neovim.
    --     local ensure_installed = vim.tbl_keys(servers or {})
    --     vim.list_extend(ensure_installed, {
    --       'stylua', -- Used to format lua code
    --     })
    --     require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    --
    --     require('mason-lspconfig').setup {
    --       handlers = {
    --         function(server_name)
    --           local server = servers[server_name] or {}
    --           require('lspconfig')[server_name].setup {
    --             cmd = server.cmd,
    --             settings = server.settings,
    --             filetypes = server.filetypes,
    --             -- This handles overriding only values explicitly passed
    --             -- by the server configuration above. Useful when disabling
    --             -- certain features of an LSP (for example, turning off formatting for tsserver)
    --             capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}),
    --           }
    --         end,
    --       },
    --     }
    --   end,
    -- },
    --
    -- { -- Autoformat
    --   'stevearc/conform.nvim',
    --   opts = {
    --     notify_on_error = false,
    --     format_on_save = {
    --       timeout_ms = 500,
    --       lsp_fallback = true,
    --     },
    --     formatters_by_ft = {
    --       lua = { 'stylua' },
    --       -- Conform can also run multiple formatters sequentially
    --       -- python = { "isort", "black" },
    --       --
    --       -- You can use a sub-list to tell conform to run *until* a formatter
    --       -- is found.
    --       -- javascript = { { "prettierd", "prettier" } },
    --     },
    --   },
    -- },
    --
    -- { -- Autocompletion
    --   'hrsh7th/nvim-cmp',
    --   event = 'InsertEnter',
    --   dependencies = {
    --     -- Snippet Engine & its associated nvim-cmp source
    --     {
    --       'L3MON4D3/LuaSnip',
    --       build = (function()
    --         -- Build Step is needed for regex support in snippets
    --         -- This step is not supported in many windows environments
    --         -- Remove the below condition to re-enable on windows
    --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
    --           return
    --         end
    --         return 'make install_jsregexp'
    --       end)(),
    --     },
    --     'saadparwaiz1/cmp_luasnip',
    --
    --     -- Adds other completion capabilities.
    --     --  nvim-cmp does not ship with all sources by default. They are split
    --     --  into multiple repos for maintenance purposes.
    --     'hrsh7th/cmp-nvim-lsp',
    --     'hrsh7th/cmp-path',
    --
    --     -- If you want to add a bunch of pre-configured snippets,
    --     --    you can use this plugin to help you. It even has snippets
    --     --    for various frameworks/libraries/etc. but you will have to
    --     --    set up the ones that are useful for you.
    --     -- 'rafamadriz/friendly-snippets',
    --   },
    --   config = function()
    --     -- See `:help cmp`
    --     local cmp = require 'cmp'
    --     local luasnip = require 'luasnip'
    --     luasnip.config.setup {}
    --
    --     cmp.setup {
    --       snippet = {
    --         expand = function(args)
    --           luasnip.lsp_expand(args.body)
    --         end,
    --       },
    --       completion = { completeopt = 'menu,menuone,noinsert' },
    --
    --       -- For an understanding of why these mappings were
    --       -- chosen, you will need to read `:help ins-completion`
    --       --
    --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --       mapping = cmp.mapping.preset.insert {
    --         -- Select the [n]ext item
    --         ['<C-n>'] = cmp.mapping.select_next_item(),
    --         -- Select the [p]revious item
    --         ['<C-p>'] = cmp.mapping.select_prev_item(),
    --
    --         -- Accept ([y]es) the completion.
    --         --  This will auto-import if your LSP supports it.
    --         --  This will expand snippets if the LSP sent a snippet.
    --         ['<C-y>'] = cmp.mapping.confirm { select = true },
    --
    --         -- Manually trigger a completion from nvim-cmp.
    --         --  Generally you don't need this, because nvim-cmp will display
    --         --  completions whenever it has completion options available.
    --         ['<C-Space>'] = cmp.mapping.complete {},
    --
    --         -- Think of <c-l> as moving to the right of your snippet expansion.
    --         --  So if you have a snippet that's like:
    --         --  function $name($args)
    --         --    $body
    --         --  end
    --         --
    --         -- <c-l> will move you to the right of each of the expansion locations.
    --         -- <c-h> is similar, except moving you backwards.
    --         -- ['<C-l>'] = cmp.mapping(function()
    --         --   if luasnip.expand_or_locally_jumpable() then
    --         --     luasnip.expand_or_jump()
    --         --   end
    --         -- end, { 'i', 's' }),
    --         -- ['<C-h>'] = cmp.mapping(function()
    --         --   if luasnip.locally_jumpable(-1) then
    --         --     luasnip.jump(-1)
    --         --   end
    --         -- end, { 'i', 's' }),
    --       },
    --       sources = {
    --         { name = 'nvim_lsp' },
    --         { name = 'luasnip' },
    --         { name = 'path' },
    --       },
    --     }
    --   end,
    -- },
    --
    -- { -- You can easily change to a different colorscheme.
    --   -- Change the name of the colorscheme plugin below, and then
    --   -- change the command in the config to whatever the name of that colorscheme is
    --   --
    --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
    --   'folke/tokyonight.nvim',
    --   lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    --   priority = 1000, -- make sure to load this before all the other start plugins
    --   config = function()
    --     -- Load the colorscheme here
    --     vim.cmd.colorscheme 'tokyonight-night'
    --
    --     -- You can configure highlights by doing something like
    --     vim.cmd.hi 'Comment gui=none'
    --   end,
    -- },
    --
    -- -- Highlight todo, notes, etc in comments
    -- { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
    --
    -- { -- Collection of various small independent plugins/modules
    --   'echasnovski/mini.nvim',
    --   config = function()
    --     -- Better Around/Inside textobjects
    --     --
    --     -- Examples:
    --     --  - va)  - [V]isually select [A]round [)]parenthen
    --     --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --     --  - ci'  - [C]hange [I]nside [']quote
    --     require('mini.ai').setup { n_lines = 500 }
    --
    --     -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --     --
    --     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    --     -- - sd'   - [S]urround [D]elete [']quotes
    --     -- - sr)'  - [S]urround [R]eplace [)] [']
    --     require('mini.surround').setup()
    --
    --     -- Simple and easy statusline.
    --     --  You could remove this setup call if you don't like it,
    --     --  and try some other statusline plugin
    --     require('mini.statusline').setup()
    --     MiniStatusline.section_location = function()
    --       return '%2l:%-2v'
    --     end
    --
    --     -- ... and there is more!
    --     --  Check out: https://github.com/echasnovski/mini.nvim
    --   end,
    -- },
    --
    -- { -- Highlight, edit, and navigate code
    --   'nvim-treesitter/nvim-treesitter',
    --   build = ':TSUpdate',
    --   config = function()
    --     -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    --
    --     ---@diagnostic disable-next-line: missing-fields
    --     require('nvim-treesitter.configs').setup {
    --       ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
    --       -- Autoinstall languages that are not installed
    --       auto_install = true,
    --       highlight = { enable = true },
    --       indent = { enable = true },
    --     }
    --
    --     -- There are additional nvim-treesitter modules that you can use to interact
    --     -- with nvim-treesitter. You should go explore a few and see what interests you:
    --     --
    --     --    - Incremental selection: Included, see :help nvim-treesitter-incremental-selection-mod
    --     --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --     --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    --   end,
    -- },
    --
    -- -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
    -- -- init.lua. If you want these files, they are in the repository, so you can just download them and
    -- -- put them in the right spots if you want.
    --
    -- -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for kickstart
    -- --
    -- --  Here are some example plugins that I've included in the kickstart repository.
    -- --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    -- --
    -- -- require 'kickstart.plugins.debug',
    -- -- require 'kickstart.plugins.indent_line',
    --
    -- -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    -- --    This is the easiest way to modularize your config.
    -- --
    -- --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    -- --    For additional information see: :help lazy.nvim-lazy.nvim-structuring-your-plugins
    -- -- { import = 'custom.plugins' },
  },
  {
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
)


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

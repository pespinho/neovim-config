-------------------------------------------------------------------------------
-- LOCALS
-------------------------------------------------------------------------------

local function get_lua_options()
    -- Determine the Neovim config directory once
    local neovim_config_dir = vim.fn.stdpath('config')

    -- Check if the current working directory (where Neovim was launched,
    -- or the root of the project you opened) is the Neovim config directory.
    -- vim.fn.getcwd() gets the current working directory of Neovim.
    -- This is a good proxy for the project root when launching Neovim.
    local is_neovim_config_root = vim.fn.getcwd() == neovim_config_dir
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')

    local config = {
        settings = {
            Lua = {
                -- Disable telemetry
                telemetry = { enable = false },
                runtime = {
                    -- Tell the language server which version of Lua you're using
                    -- (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' }
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        -- Make the server aware of Neovim runtime files
                        vim.env.VIMRUNTIME,
                        '${3rd}/luv/library'
                    }
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        ident_size = 4
                    }
                }
            }
        }
    }

    if not is_neovim_config_root then
        config.settings.Lua.runtime = nil
        config.settings.Lua.workspace.library = nil
        config.settings.Lua.diagnostics.globals = nil
    end

    return vim.tbl_deep_extend('force', config, {})
end

-------------------------------------------------------------------------------
-- LSP CONFIGURATION
-------------------------------------------------------------------------------

vim.lsp.config('lua_ls', get_lua_options())

vim.lsp.config('clangd', {
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
    }
})

vim.lsp.config('basedpyright', {
    settings = {
        basedpyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                -- ignore = { '*' },
                diagnosticSeverityOverrides = {
                    reportMissingTypeStubs = false,
                    reportUnusedParameter = false,
                    reportUnknownVariableType = false,
                    reportUnknownMemberType = false,
                    reportImplicitStringConcatenation = false,
                    reportExplicitAny = false,
                    reportAny = false,
                }
            },
        },
    },
})

vim.lsp.inlay_hint.enable()

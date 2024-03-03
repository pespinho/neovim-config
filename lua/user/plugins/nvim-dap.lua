-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimDap = { "mfussenegger/nvim-dap" }

NvimDap.keys = {
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

NvimDap.config = function()
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
            "~/bin/local-lua-debugger-vscode/extension/debugAdapter.js"
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
end

return NvimDap

-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local NvimDapUi = { "rcarriga/nvim-dap-ui" }

NvimDapUi.dependencies = { 'nvim-neotest/nvim-nio' }

NvimDapUi.config = function()
    local dap, dapui = require("dap"), require("dapui")

    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

return NvimDapUi

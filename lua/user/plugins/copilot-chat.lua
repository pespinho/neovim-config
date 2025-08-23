-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local CopilotChat = { "CopilotC-Nvim/CopilotChat.nvim" }

CopilotChat.branch = "main"

CopilotChat.dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim"
}

CopilotChat.init = function()
    local copilot = require("CopilotChat")
    vim.keymap.set(
        { "n", "v" },
        "<leader>ct",
        function() copilot.toggle(CopilotChat.opts) end,
        { desc = "CopilotChat [t]oggle" }
    )
    vim.keymap.set({ "n" }, "<leader>cf", function() copilot.chat:focus() end, { desc = "CopilotChat [f]ocus" })
    vim.keymap.set(
        { "n" },
        "<leader>cF",
        function()
            CopilotChat.opts.window.width = 1.0
            copilot.close()
            copilot.open(CopilotChat.opts)
        end,
        { desc = "CopilotChat [F]ullscreen" }
    )
    vim.keymap.set(
        { "n" },
        "<leader>cr",
        function()
            CopilotChat.opts.window.width = 80
            copilot.close()
            copilot.open(CopilotChat.opts)
        end,
        { desc = "CopilotChat [r]estore width" }
    )
    vim.keymap.set({ "n" }, "<leader>csb", function() copilot.chat:add_sticky("#buffer") end,
        { desc = "[b]uffer" })
    vim.keymap.set({ "n" }, "<leader>csB", function() copilot.chat:add_sticky("#buffers") end,
        { desc = "[B]uffers" })
end


CopilotChat.opts = {
    model = "claude-sonnet-4",
    mappings = {
        reset = {
            normal = '<C-c>',
            insert = '<C-c>'
        },
    },
    window = {
        width = 80, -- Fixed width in columns
    },

    headers = {
        user = '👤 You: ',
        assistant = '🤖 Copilot: ',
        tool = '🔧 Tool: ',
    },
    separator = '━━',
    show_folds = false,   -- Disable folding for cleaner look
    insert_at_end = true, -- Move cursor to end of buffer when inserting text
}

CopilotChat.config = function(_, opts)
    require("CopilotChat").setup(opts)
end

return CopilotChat

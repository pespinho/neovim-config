-------------------------------------------------------------------------------
-- LAZY - PLUGIN SPEC
-------------------------------------------------------------------------------

local CopilotChat = { "CopilotC-Nvim/CopilotChat.nvim" }

CopilotChat.branch = "canary"

CopilotChat.dependencies = {
    "zbirenbaum/copilot.lua",
    "nvim-lua/plenary.nvim"
}

CopilotChat.init = function()
    vim.keymap.set({ "n", "v" }, "<leader>ct", "<cmd>CopilotChatToggle<CR>", { desc = "CopilotChat [t]oggle" })
    vim.keymap.set({ "n", "v" }, "<leader>cr", "<cmd>CopilotChatReset<CR>", { desc = "CopilotChat [r]eset" })
    vim.keymap.set({ "n", "v" }, "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "CopilotChat [e]xplain" })
    vim.keymap.set({ "n", "v" }, "<leader>cT", "<cmd>CopilotChatTests<CR>", { desc = "CopilotChat [T]ests" })
    vim.keymap.set({ "n", "v" }, "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "CopilotChat [f]ix" })
    vim.keymap.set({ "n", "v" }, "<leader>cg", "<cmd>CopilotChatCommitStaged<CR>",
        { desc = "CopilotChat [g]it commit staged" })
end


CopilotChat.opts = {
    mappings = {
        reset = '<C-c>',
    },
}

CopilotChat.config = function(_, opts)
    require("CopilotChat").setup(opts)
end

return CopilotChat

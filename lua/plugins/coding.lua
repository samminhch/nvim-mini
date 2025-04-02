local now, add = MiniDeps.now, MiniDeps.add
local utils = require("utils.base")

---@type KeyMap[]
local keymaps = {}
local servers = require("plugins.mason").servers

-- ╒════════════════════════════════════════════╕
-- │ Installing Needed Plugins + Adding KeyMaps │
-- ╘════════════════════════════════════════════╛
now(function()
    add({
        source = "williamboman/mason-lspconfig.nvim",
        depends = {
            -- NeoVIM dev tools
            "folke/lazydev.nvim",
        },
    })
end)

now(function()
    add({
        source = "mfussenegger/nvim-dap",
        depends = {
            -- Debugging UI
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            -- Debugger Installation
            "williamboman/mason.nvim",
            "jay-babu/mason-nvim-dap.nvim",
            -- Other Debuggers
        },
    })

    local dap, dapui = require("dap"), require("dapui")
    local keymap_prefix = "<leader>d"
    local desc_prefix = "[D]AP: "

    ---@type KeyMap[]
    local mappings = {
        {
            mode = "n",
            binding = keymap_prefix .. "c",
            action = dap.continue,
            options = { desc = desc_prefix .. "[C]ontinue / Start" },
        },
        {
            mode = "n",
            binding = keymap_prefix .. "si",
            action = dap.step_into,
            options = { desc = "[S]tep [I]nto" },
        },
        {
            mode = "n",
            binding = keymap_prefix .. "so",
            action = dap.step_over,
            options = { desc = "[S]tep [O]ver" },
        },
        {
            mode = "n",
            binding = keymap_prefix .. "sO",
            action = dap.step_out,
            options = { desc = "[S]tep [O]ut" },
        },
        {
            mode = "n",
            binding = keymap_prefix .. "b",
            action = dap.toggle_breakpoint,
            options = { desc = "[B]reakpoint Toggle" },
        },
        {
            mode = "n",
            binding = keymap_prefix .. "d",
            action = dapui.toggle,
            options = { desc = "[D]ebug Toggle" },
        },
    }

    keymaps = utils.merge_arrays(keymaps, mappings)
end)

-- ╒═══════════╕
-- │ LSP Setup │
-- ╘═══════════╛
require("mini.deps").later(function()
    -- ╒═════════════╕
    -- │ Diagnostics │
    -- ╘═════════════╛
    vim.diagnostic.config({
        virtual_lines = { current_line = true },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "󰌵",
                [vim.diagnostic.severity.INFO] = "",
            },
            numhl = {
                [vim.diagnostic.severity.ERROR] = "ErrorMsg",
                [vim.diagnostic.severity.WARN] = "WarningMsg",
                [vim.diagnostic.severity.HINT] = "DiagnosticHint",
                [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            },
        },
    })

    -- ╒═════════════════════════════╕
    -- │ Configuring / Enabling LSPs │
    -- ╘═════════════════════════════╛
    for server, config in pairs(servers) do
        if config.before ~= nil then
            config.before()
        end

        if not config.ignore_config then
            vim.lsp.config[server] = config
            vim.lsp.enable(server)
        end
    end
end)

return { keymaps = keymaps }

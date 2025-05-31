local now = MiniDeps.now
local utils = require("utils.base")

---@type KeyMap[]
local keymaps = {}

-- ╒═══════════╕
-- │ LSP Setup │
-- ╘═══════════╛
now(function()
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

    -- Define a default configuration
    vim.lsp.config("*", {
        root_markers = { ".git" },
        capabilities = require("mini.completion").get_lsp_capabilities(),
    })

    local ignore_servers = { "basedpyright" }

    local servers = {}
    for _, name in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
        local server_name = vim.fn.fnamemodify(name, ":t:r")
        if not utils.array_contains(ignore_servers, server_name) then
            table.insert(servers, server_name)
            vim.lsp.enable(server_name)
        end
    end
end)

return { keymaps = keymaps }

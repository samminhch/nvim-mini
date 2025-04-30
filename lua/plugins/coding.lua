local now = MiniDeps.now

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
    local servers = {}
    for _, name in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
        local server_name = vim.fn.fnamemodify(name, ":t:r")
        table.insert(servers, server_name)
    end
    vim.lsp.enable(servers)
end)

return { keymaps = keymaps }

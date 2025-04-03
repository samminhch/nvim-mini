local now = MiniDeps.now

---@type KeyMap[]
local keymaps = {}
local servers = require("plugins.mason").servers

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
    for server, config in pairs(servers) do
        if not config.ignore_config then
            -- if server == "jdtls" then
            --     vim.print(config)
            -- end
            vim.lsp.config[server] = type(config) == "table" and config or config()
            vim.lsp.enable(server)
        end
    end
end)

return { keymaps = keymaps }

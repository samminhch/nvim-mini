local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add
local utils = require("utils.base")

---@type KeyMap[]
local keymaps = {}

-- ╒════════════════════════════════════════════╕
-- │ Installing Needed Plugins + Adding KeyMaps │
-- ╘════════════════════════════════════════════╛
now(function()
    add({
        source = "neovim/nvim-lspconfig",
        depends = {
            -- Installing LSPs
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
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

-- ╒═══════════════════════════════════════════╕
-- │ Installing Packages for Text/Code Editing │
-- ╘═══════════════════════════════════════════╛
-- Pre-configuring language servers & Debuggers

-- Check out `nvim-lspaconfig`'s documentation
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers = {
    bashls = {},
    clangd = {},
    docker_compose_language_service = {},
    dockerls = {},
    hyprls = {},
    jdtls = {},
    pyright = {},
    lua_ls = {
        Lua = {
            format = { enable = false },
        },
    },
    marksman = {},
    rust_analyzer = {},
    tinymist = {},
}
local debuggers = {}
local formatters = vim.tbl_keys(require("plugins.editing").formatters)

-- A string[] of packages to install
local packages = utils.merge_arrays(vim.tbl_keys(servers), formatters, vim.tbl_keys(debuggers))
local ignore_packages = { "rustfmt" } -- Don't install these packages

for idx = 1, #packages do
    if vim.tbl_contains(ignore_packages, packages[idx]) then
        table.remove(packages, idx)
    end
end

later(function()
    -- Install mason packages
    require("mason").setup({
        registries = {
            "github:nvim-java/mason-registry",
            "github:mason-org/mason-registry",
        },
        ui = {
            border = "rounded",
        },
    })

    require("mason-tool-installer").setup({
        ensure_installed = packages,
        auto_update = true,
        run_on_start = true,
    })

    vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsStartingInstall",
        callback = function()
            vim.schedule(function() vim.print("mason-tool-installer is starting") end)
        end,
    })
end)

-- ╒═══════════╕
-- │ LSP Setup │
-- ╘═══════════╛
later(function()
    -- Aesthetics
    ---- Define Border Style
    local border_opts = { border = "rounded" }
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)
    vim.diagnostic.config({ float = border_opts })

    ---- Set Diagnostic Icons
    local icons = { Error = "", Warn = "", Hint = "󰌵", Info = "" }

    for type, icon in pairs(icons) do
        local highlight = "DiagnosticSign" .. type
        vim.fn.sign_define(highlight, { text = icon, texthl = highlight, numhl = highlight })
    end

    -- Setting default keybinds & features when attaching a language server
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(event)
            local mapd = function(mode, binding, action, desc)
                require("utils.base").mapd(mode, binding, action, "LSP: " .. desc)
            end
            local nmapd = function(binding, action, desc) require("utils.base").nmapd(binding, action, "LSP: " .. desc) end

            -- Enable completion triggered by <C-x><C-o>
            vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            local mini_picker = require("mini.extra").pickers
            nmapd("gd", function() mini_picker.lsp({ scope = "definition" }) end, "[G]o to [D]efinition")
            nmapd("gi", function() mini_picker.lsp({ scope = "implementation" }) end, "[G]o to [I]mplementation")
            nmapd("gr", function() mini_picker.lsp({ scope = "references" }) end, "[G]o to [R]eferences")
            nmapd("gD", vim.lsp.buf.declaration, "[G]o to [D]eclaration")
            nmapd("K", vim.lsp.buf.hover, "Hover")
            mapd({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
            mapd("i", "<C-k>", vim.lsp.buf.signature_help, "[H]elp")
            nmapd("<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
            nmapd("<leader>sl", function() mini_picker.lsp({ scope = "document_symbol" }) end, "[S]earch [L]SP Symbols")
            nmapd("<leader>sd", mini_picker.diagnostic, "[S]earch Diagnostics")

            vim.lsp.inlay_hint.enable(true) -- inlay hints by default
            nmapd(
                "<leader>ci",
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
                "[C]ode [I]nlay Hint Toggle"
            )

            -- Symbol highlighting
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                local highlight_augroup = vim.api.nvim_create_augroup("LspHighlight", { clear = false })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                })

                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd("LspDetach", {
                    group = vim.api.nvim_create_augroup("LspDetach", { clear = true }),
                    callback = function(event2)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds({ group = "LspHighlight", buffer = event2.buf })
                    end,
                })
            end
        end,
    })

    local lspconfig = require("lspconfig")

    -- Setup lazydev before configuring LSPs
    ---@diagnostic disable-next-line: missing-fields
    require("lazydev").setup({
        library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            -- { path = "LazyVim", words = { "LazyVim" } },
            -- { path = "wezterm-types", mods = { "wezterm" } },
        },
    })

    ---@diagnostic disable-next-line: missing-fields
    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                local opts = servers[server_name] or {}
                opts.capabilities = require("blink.cmp").get_lsp_capabilities(
                    (servers[server_name] and servers[server_name].capabilities) or {}
                )

                lspconfig[server_name].setup(opts)
            end,
            clangd = function()
                require("clangd_extensions.inlay_hints").setup_autocmd()
                require("clangd_extensions.inlay_hints").set_inlay_hints()
                lspconfig.clangd.setup(servers.clangd)
            end,
            hyprls = function() lspconfig.hyprls.setup(require("blink.cmp").get_lsp_capabilities({})) end,
            jdtls = function()
                require("java").setup({
                    -- custom jdtls settings here
                })

                -- servers.jdtls should contain nvim-java settings
                lspconfig.jdtls.setup(servers.jdtls)
            end,
        },
    })
end)

-- ╒═════════════════╕
-- │ Debugging Setup │
-- ╘═════════════════╛

later(function()
    local dap = require("dap")
    local dapui = require("dapui")

    ---@diagnostic disable-next-line: missing-fields
    dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = " " },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Set Debug Icons
    -- local icons = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
    --
    -- for type, icon in pairs(icons) do
    --     local highlight = "DiagnosticSign" .. type
    --     vim.fn.sign_define(highlight, { text = icon, texthl = highlight, numhl = highlight })
    -- end
end)

return { keymaps = keymaps }

local now, add = MiniDeps.now, MiniDeps.add
local utils = require("utils.base")

-- ╒═══════════════════════════════════════════╕
-- │ Installing Packages for Text/Code Editing │
-- ╘═══════════════════════════════════════════╛
-- Pre-configuring language servers & Debuggers

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
local formatters = {
    black = {},
    isort = {},
    prettierd = {
        env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/.prettierrc.json",
        },
    },
    rustfmt = {},
    shfmt = {
        prepend_args = { "-i", shiftwidth },
    },
    stylua = {
        prepend_args = {
            "--config-path",
            vim.fn.stdpath("config") .. "/.stylua.toml",
        },
    },
}

-- A string[] of packages to install
local packages = utils.merge_arrays(vim.tbl_keys(servers), vim.tbl_keys(formatters), vim.tbl_keys(debuggers))
local ignore_packages = { "rustfmt" } -- Don't install these packages

for idx = 1, #packages do
    if vim.tbl_contains(ignore_packages, packages[idx]) then
        table.remove(packages, idx)
    end
end

now(function()
    add({
        source = "WhoIsSethDaniel/mason-tool-installer.nvim",
        depends = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "jay-babu/mason-nvim-dap.nvim",
        },
    })

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
            vim.schedule(function() vim.notify("Mason is installing packages", vim.log.levels.INFO, nil) end)
        end,
    })
    require("mason-lspconfig").setup()
end)

return { servers = servers, formatters = formatters, debuggers = debuggers }

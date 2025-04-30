local utils = require("utils.base")

-- ╒═══════════════════════════════════════════╕
-- │ Installing Packages for Text/Code Editing │
-- ╘═══════════════════════════════════════════╛

-- Installing Mason + Friends
MiniDeps.now(function()
    MiniDeps.add({
        source = "WhoIsSethDaniel/mason-tool-installer.nvim",
        depends = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
    })

    -- Install mason packages
    require("mason").setup({ ui = { border = "rounded" } })
end)

-- Pre-configuring language servers & Debuggers

local servers = {}
for _, name in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local server_name = vim.fn.fnamemodify(name, ":t:r")
    table.insert(servers, server_name)
end

local formatters = {
    black = {},
    ["clang-format"] = {},
    isort = {},
    prettierd = {
        env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/.prettierrc.json",
        },
    },
    rustfmt = {},
    shfmt = {
        prepend_args = { "-i", vim.opt.shiftwidth },
    },
    stylua = {
        prepend_args = {
            "--config-path",
            vim.fn.stdpath("config") .. "/.stylua.toml",
        },
    },
}

-- A string[] of packages to install
local packages = utils.merge_arrays(servers, vim.tbl_keys(formatters))
local ignore_packages = { "rustfmt" } -- Don't install these packages

for idx = 1, #packages do
    if vim.tbl_contains(ignore_packages, packages[idx]) then
        table.remove(packages, idx)
    end
end

MiniDeps.now(function()
    require("mason-tool-installer").setup({
        ensure_installed = packages,
        auto_update = true,
        run_on_start = true,
    })

    -- Show the Mason UI when installing packages
    vim.api.nvim_create_autocmd("User", {
        pattern = "MasonToolsStartingInstall",
        callback = function() vim.cmd("Mason") end,
    })
end)

return { formatters = formatters }

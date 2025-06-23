local utils = require("utils.base")

-- ╒═══════════════════════════════════════════╕
-- │ Installing Packages for Text/Code Editing │
-- ╘═══════════════════════════════════════════╛

-- Installing Mason + Friends
MiniDeps.now(function()
    MiniDeps.add({
        source = "WhoIsSethDaniel/mason-tool-installer.nvim",
        depends = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
        },
    })

    -- Install mason packages
    require("mason").setup({ ui = { border = "rounded" } })
end)

-- Pre-configuring language servers & Debuggers

--- @type table<string, vim.lsp.Config>
local servers = {
    air = {},
    bashls = {},
    clangd = {
        flags = {
            debounce_text_changes = 20,
            exit_timeout = false,
        },
    },
    cssls = { init_options = { provideFormatter = false } },
    docker_compose_language_service = {},
    dockerls = {},
    eslint = {},
    harper_ls = {
        settings = {
            linters = {
                SentenceCapitalization = false,
                SpellCheck = false,
            },
        },
    },
    html = { init_options = { provideFormatter = false } },
    jdtls = {},
    jsonls = { init_options = { provideFormatter = false } },
    lua_ls = {},
    marksman = {},
    pyrefly = {},
    rust_analyzer = {},
    taplo = {},
    tinymist = {},
}

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
local packages = utils.merge_arrays(vim.tbl_keys(servers), vim.tbl_keys(formatters))
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

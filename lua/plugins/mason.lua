local now, add = MiniDeps.now, MiniDeps.add
local utils = require("utils.base")

-- ╒═══════════════════════════════════════════╕
-- │ Installing Packages for Text/Code Editing │
-- ╘═══════════════════════════════════════════╛

-- Installing Mason + Friends
now(function()
    add({
        source = "WhoIsSethDaniel/mason-tool-installer.nvim",
        depends = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
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
end)

-- Pre-configuring language servers & Debuggers

---@type table<string, vim.lsp.Config>
local servers = {
    basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
            ".git",
        },
        settings = {
            basedpyright = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "openFilesOnly",
                },
            },
        },
    },
    bashls = {
        cmd = { "bash-language-server", "start" },
        filetypes = { "bash", "sh" },
        settings = {
            bashIde = {
                globPattern = "*@(.sh|.inc|.bash|.command)",
            },
        },
    },
    clangd = {
        cmd = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        root_markers = {
            ".clangd",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac",
        },
        flags = {
            debounce_text_changes = 20,
            exit_timeout = false,
        },
        capabilities = {
            textDocument = {
                completion = { editsNearCursor = true },
                offsetEncoding = { "utf-8", "utf-16" },
            },
        },
    },
    cssls = {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { "package.json", ".git" },
        settings = {
            css = {
                validate = true,
            },
            less = {
                validate = true,
            },
            scss = {
                validate = true,
            },
        },
    },
    docker_compose_language_service = { ignore_config = true },
    dockerls = { ignore_config = true },
    html = {
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "templ" },
        init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
                css = true,
                javascript = true,
            },
            provideFormatter = true,
        },
        root_markers = { "package.json", ".git" },
    },
    hyprls = {
        cmd = { "hyprls", "--stdio" },
        filetypes = { "hyprlang" },
        root_dir = function(fname) return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1]) end,
    },
    jdtls = { ignore_config = true },
    lua_ls = {
        before = function()
            -- Setup lazydev before configuring LSPs
            ---@diagnostic disable-next-line: missing-fields
            require("lazydev").setup({
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            })
        end,
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = {
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "stylua.toml",
            "selene.toml",
            "selene.yml",
            ".git",
        },
    },
    marksman = { ignore_config = true },
    rust_analyzer = { ignore_config = true },
    tinymist = { ignore_config = true },
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
        prepend_args = { "-i", vim.o.shiftwidth },
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

now(function()
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
end)

return { servers = servers, formatters = formatters, debuggers = adapters }

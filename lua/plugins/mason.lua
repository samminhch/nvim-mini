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

local env = {
    sysname = vim.loop.os_uname().sysname,
    xdg_cache_home = os.getenv("XDG_CACHE_HOME"),
    nvim = {
        mason_data = vim.fn.stdpath("data") .. "/mason/share",
    },
}

local cache_dir = env.cache_home and env.cache_home or vim.fn.expand("~/.cache")
local jdtls_exec = env.sysname == "Linux" and "/usr/bin/jdtls" or "jdtls"
local jdtls_dir = env.sysname == "LINUX" and "/usr/share/java/jdtls" or env.nvim.mason_data .. "jdtls"
local jdtls_config_dir = jdtls_dir .. (env.sysname == "Linux" and "config_linux/" or "config/")
local jdtls_workspace_dir = cache_dir .. "/workspace"

---@type function<table<string,vim.lsp.Config>>
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
        filetypes = { "bash", "sh", "zsh" },
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
    },
    jdtls = {
        cmd = {
            jdtls_exec,
            "-configuration",
            jdtls_config_dir,
            "-data",
            jdtls_workspace_dir,
        },
        filetypes = { "java" },
        root_markers = {
            "build.xml", -- Ant
            "pom.xml", -- Maven
            "settings.gradle", -- Gradle
            "settings.gradle.kts", -- Gradle
        },
        init_options = {
            workspace = jdtls_workspace_dir,
            jvm_args = {},
            os_config = nil,
        },
    },
    lua_ls = {
        before_init = function(
            params --[[@as lsp.InitializeParams]],
            config --[[@as vim.lsp.ClientConfig]]
        )
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

return { servers = servers, formatters = formatters }

local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add
local utils = require("utils.base")

---@type KeyMap[]
local keymaps = {}

-- ╒════════════════════════════════════════════╕
-- │ Installing Needed Plugins + Adding KeyMaps │
-- ╘════════════════════════════════════════════╛
now(function()
    add({
        source = "nvim-treesitter/nvim-treesitter",
        -- Use "master" while monitoring updates in "main"

        checkout = "master",
        monitor = "main",
        -- Perform action after every checkout
        hooks = {
            post_checkout = function() vim.cmd.TSUpdate() end,
        },
    })
end)

now(function()
    add({
        source = "saghen/blink.cmp",
        depends = {
            -- Snippets
            "rafamadriz/friendly-snippets",
            -- Sources
            "moyiz/blink-emoji.nvim",
            "Saghen/blink.compat",
        },
        checkout = "v0.10.0", -- check releases for latest tag
    })
end)

now(function()
    add({
        source = "stevearc/conform.nvim",
        checkout = "v8.3.0",
    })

    -- Assign keymaps
    ---@type KeyMap[]
    local mappings = {
        {
            mode = "n",
            binding = "<leader>F",
            action = function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
            options = { desc = "[F]ormat Buffer" },
        },
    }

    keymaps = utils.merge_arrays(keymaps, mappings)
end)

now(function()
    add({ source = "mbbill/undotree" })

    -- Assign Global Settings
    vim.g.undotree_WindowLayout = 3

    --- Customize Shapes
    vim.g.undotree_TreeNodeShape = "⬤"
    vim.g.undotree_TreeVertShape = "│"
    vim.g.undotree_TreeSplitShape = "╱"
    vim.g.undotree_TreeReturnShape = "╲"

    -- Assign keymaps
    ---@type KeyMap[]
    local mappings = {
        {
            mode = "n",
            binding = "<leader>u",
            action = vim.cmd.UndotreeToggle,
            options = { desc = "[F]ile [E]xplorer" },
        },
    }

    keymaps = utils.merge_arrays(keymaps, mappings)
end)

-- ╒═════════════════════════════════════╕
-- │ Setup `mini.nvim` Plugins + Keymaps │
-- ╘═════════════════════════════════════╛
later(function() require("mini.align").setup() end)
later(function() require("mini.bracketed").setup() end)
later(function() require("mini.diff").setup() end)
later(function() require("mini.extra").setup() end)
later(function() require("mini.git").setup() end)
later(function() require("mini.pairs").setup() end)
later(function() require("mini.surround").setup() end)
later(function() require("mini.visits").setup() end)

--`mini.files` setup + keymaps
now(function()
    -- Assign keymaps
    ---@type KeyMap[]
    local mappings = {
        {
            mode = "n",
            binding = "<leader>fe",
            action = not require("mini.files").close() and require("mini.files").open,
            options = { desc = "[F]ile [E]xplorer" },
        },
    }

    keymaps = utils.merge_arrays(keymaps, mappings)
end)
later(function() require("mini.files").setup() end)

-- `mini.pick` Setup
now(function()
    -- Assign keymaps
    local mini_picker = require("mini.pick").builtin
    local mini_picker_extras = require("mini.extra").pickers

    --@type KeyMap[]
    local mappings = {
        {
            mode = "n",
            binding = "<leader>so",
            action = mini_picker_extras.oldfiles,
            options = { desc = "[S]earch [O]ldfiles" },
        },
        {
            mode = "n",
            binding = "<leader>sb",
            action = mini_picker.buffers,
            options = { desc = "[S]earch [B]uffers" },
        },
        {
            mode = "n",
            binding = "<leader>sr",
            action = mini_picker_extras.registers,
            options = { desc = "[S]earch [R]egisters" },
        },
        {
            mode = "n",
            binding = "<leader>sf",
            action = mini_picker.files,
            options = { desc = "[S]earch [F]iles" },
        },
        {
            mode = "n",
            binding = "<leader>sgf",
            action = mini_picker_extras.git_files,
            options = { desc = "[S]earch [G]it [F]iles" },
        },
        {
            mode = "n",
            binding = "<leader>ss",
            action = mini_picker.grep_live,
            options = { desc = "[S]earch for [S]tring" },
        },
        {
            mode = "n",
            binding = "<leader>sh",
            action = mini_picker.help,
            options = { desc = "[S]earch [H]elp files" },
        },
    }

    keymaps = utils.merge_arrays(keymaps, mappings)
end)
later(function() require("mini.pick").setup() end)

-- ╒═══════════════════╕
-- │ `blink.cmp` Setup │
-- ╘═══════════════════╛
later(function()
    require("blink.cmp").setup({
        completion = {
            menu = {
                border = "rounded",
            },
            documentation = {
                auto_show = true,
                window = {
                    border = "rounded",
                },
            },
            ghost_text = { enabled = true },
        },
        signature = {
            enabled = true,
            window = {
                border = "rounded",
            },
        },
        sources = {
            default = {
                "lazydev",
                "lsp",
                "path",
                "snippets",
                "markdown",
                "crates",
                "buffer",
                "emoji",
            },
            providers = {
                crates = {
                    name = "crates",
                    module = "blink.compat.source",
                },
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = 15, -- Tune by preference
                    opts = { insert = true }, -- Insert emoji (default) or complete its name
                },
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                markdown = {
                    name = "RenderMarkdown",
                    module = "render-markdown.integ.blink",
                    fallbacks = { "lsp" },
                },
            },
        },
    })
end)

-- ╒═════════════════════════╕
-- │ `nvim-treesitter` Setup │
-- ╘═════════════════════════╛
later(
    function()
        require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            auto_install = true,
            indent = { enable = true, disable = { "python" } },
            context_commentstring = { enable = true, enable_autocmd = false },
            ensure_installed = {
                "arduino",
                "c",
                "cpp",
                "lua",
                "markdown",
                "markdown_inline",
                "regex",
                "typst",
                "vimdoc",
                "vim",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            textobjects = {
                move = {
                    enable = true,
                    goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                    goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
                    goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                    goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
                },
            },
            modules = {},
            sync_install = true,
            ignore_install = {},
        })
    end
)

-- ╒══════════════════════╕
-- │ `conform.nvim` setup │
-- ╘══════════════════════╛
local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", {})
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

later(function()
    require("conform").setup({
        formatters_by_ft = {
            json = { "prettierd" },
            lua = { "stylua" },
            markdown = { "prettierd" },
            python = { "isort", "black" },
            rust = { "rustfmt" },
            sh = { "shfmt" },
        },
        formatters = formatters,
        format_on_save = function(bufnr)
            local disable_filetypes = {}
            local lsp_format_opt
            if disable_filetypes[vim.bo[bufnr].filetype] then
                lsp_format_opt = "never"
            else
                lsp_format_opt = "fallback"
            end
            return {
                timeout_ms = 500,
                lsp_format = lsp_format_opt,
            }
        end,
    })
end)

-- Return the list of formatters to be installed with `mason.nvim`
return { formatters = formatters, keymaps = keymaps }

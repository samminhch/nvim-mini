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

now(function() add({ source = "rafamadriz/friendly-snippets" }) end)

-- ╒═════════════════════════════════════╕
-- │ Setup `mini.nvim` Plugins + Keymaps │
-- ╘═════════════════════════════════════╛
later(function() require("mini.align").setup() end)
later(function() require("mini.bracketed").setup() end)
later(function() require("mini.completion").setup() end)
later(function() require("mini.diff").setup() end)
later(function() require("mini.extra").setup() end)
later(function() require("mini.git").setup() end)
later(function() require("mini.pairs").setup() end)
later(function()
    local gen_loader = require("mini.snippets").gen_loader
    require("mini.snippets").setup({
        snippets = {
            -- Load custom file with global snippets first (adjust for Windows)
            gen_loader.from_file("~/.config/nvim/snippets/global.json"),

            -- Load snippets based on current language by reading files from
            -- "snippets/" subdirectories from 'runtimepath' directories.
            gen_loader.from_lang(),
        },
    })
end)
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
later(function()
    require("mini.pick").setup({
        window = {
            prompt_prefix = "󰛿 ",
        },
    })

    vim.ui.select = function(items, opts, on_choice)
        local get_cursor_anchor = function() return vim.fn.screenrow() < 0.5 * vim.o.lines and "NW" or "SW" end
        -- Auto-adjust width
        local num_items = #items
        local max_height = math.floor(0.45 * vim.o.columns)
        local height = math.min(math.max(num_items, 1), max_height)
        local start_opts = {
            options = { content_from_bottom = get_cursor_anchor() == "SW" },
            window = {
                config = {
                    relative = "cursor",
                    anchor = get_cursor_anchor(),
                    row = get_cursor_anchor() == "NW" and 1 or 0,
                    col = 0,
                    width = math.floor(0.618 * vim.o.columns),
                    height = height,
                },
            },
        }

        return MiniPick.ui_select(items, opts, on_choice, start_opts)
    end
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
local formatters = require("plugins.mason").formatters
later(function()
    require("conform").setup({
        formatters_by_ft = {
            arduino = { "clang_format" },
            c = { "clang_format" },
            cpp = { "clang_format" },
            css = { "prettierd" },
            html = { "prettierd" },
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
return { keymaps = keymaps }

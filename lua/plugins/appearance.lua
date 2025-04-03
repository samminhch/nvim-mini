local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add

now(function() add({ source = "stevearc/dressing.nvim" }) end)

-- ╒═════════════════════╕
-- │ Setting Colorscheme │
-- ╘═════════════════════╛
now(function()
    add({ source = "sainnhe/everforest" })
    vim.cmd.colorscheme("everforest")
end)

-- ╒══════════════════════════════╕
-- │ Enabling `mini.nvim` Plugins │
-- ╘══════════════════════════════╛
now(function() require("mini.icons").setup() end)
now(function() require("mini.notify").setup() end)
now(function() require("mini.statusline").setup() end)
now(function()
    require("mini.tabline").setup({
        format = function(buf_id, label)
            local modified_suffix = vim.bo[buf_id].modified and " ⬤" or ""
            local icon_label = string.gsub(MiniTabline.default_format(buf_id, label), "^%s*(.-)%s*$", "%1")
            return " " .. icon_label .. modified_suffix .. "🭵"
        end,
        tabpage_section = "right",
    })
end)
now(function()
    local starter = require("mini.starter")
    starter.setup({
        header = [[
                     _     _       _             _       
 ___ ___ _____ _____|_|___| |_ ___| |_   ___ _ _|_|_____ 
|_ -| .'|     |     | |   |   |  _|   |_|   | | | |     |
|___|__,|_|_|_|_|_|_|_|_|_|_|_|___|_|_|_|_|_|\_/|_|_|_|_|
            ]],
        items = {
            starter.sections.recent_files(5, false, true),
            {
                action = "e $MYVIMRC | :cd %:p:h | pwd",
                name = "Settings",
                section = " eoVIM Actions",
            },
            {
                action = "Mason",
                name = "Mason",
                section = " eoVIM Actions",
            },
            {
                action = "lua MiniDeps.update()",
                name = "Update Plugins",
                section = " eoVIM Actions",
            },
            {
                action = "exit",
                name = "Quit",
                section = " eoVIM Actions",
            },
        },
    })
end)
now(
    function()
        require("mini.indentscope").setup({
            symbol = "┊",
            options = { try_as_border = true },
        })
    end
)

-- Custom vim.ui.input
now(function()
    require("dressing").setup({
        select = { enabled = false },
    })
end)

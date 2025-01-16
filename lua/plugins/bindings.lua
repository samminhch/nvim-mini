local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add
local utils = require("utils.base")

-- ╒════════════════════════════════════════════╕
-- │ Installing Needed Plugins + Adding KeyMaps │
-- ╘════════════════════════════════════════════╛
now(function()
    add({ source = "folke/which-key.nvim" })
    -- labeling keymap groups
    require("which-key").add({
        { "<leader>b", group = "[B]uffer" },
        { "<leader>b_", hidden = true },
        { "<leader>c", group = "[C]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>d", group = "[D]ebugger" },
        { "<leader>d_", hidden = true },
        { "<leader>f", group = "[F]ile" },
        { "<leader>f_", hidden = true },
        { "<leader>r", group = "[R]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>s", group = "[S]earch" },
        { "<leader>s_", hidden = true },
    })
end)

-- ╒═══════════════════════════════╕
-- │ Assigning All Defined KeyMaps │
-- ╘═══════════════════════════════╛
later(function()
    ---@type KeyMap[]
    local keymaps = utils.merge_arrays(require("plugins.editing").keymaps, require("plugins.coding").keymaps)

    for _, keymap in ipairs(keymaps) do
        require("utils.base").mapd(keymap.mode, keymap.binding, keymap.action, keymap.options.desc)
    end
end)

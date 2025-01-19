local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add

now(function() add({ source = "MunifTanjim/nui.nvim" }) end)

-- ╒═════════════════════╕
-- │ Setting Colorscheme │
-- ╘═════════════════════╛
now(function()
    MiniDeps.add({ source = "sainnhe/everforest" })
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
now(
    function()
        require("mini.starter").setup({
            header = [[
                     _     _       _             _       
 ___ ___ _____ _____|_|___| |_ ___| |_   ___ _ _|_|_____ 
|_ -| .'|     |     | |   |   |  _|   |_|   | | | |     |
|___|__,|_|_|_|_|_|_|_|_|_|_|_|___|_|_|_|_|_|\_/|_|_|_|_|
        ]],
        })
    end
)
now(
    function()
        require("mini.indentscope").setup({
            symbol = "┊",
            options = { try_as_border = true },
        })
    end
)

-- From https://github.com/MunifTanjim/nui.nvim/wiki/vim.ui
later(function()
    local function get_prompt_text(prompt, default_prompt)
        local prompt_text = prompt or default_prompt
        if prompt_text:sub(-1) == ":" then
            prompt_text = "[" .. prompt_text:sub(1, -2) .. "]"
        end
        return prompt_text
    end

    local Input = require("nui.input")
    local event = require("nui.utils.autocmd").event

    local function override_ui_input()
        local UIInput = Input:extend("UIInput")

        function UIInput:init(opts, on_done)
            local border_top_text = get_prompt_text(opts.prompt, "[Input]")
            local default_value = tostring(opts.default or "")

            UIInput.super.init(self, {
                relative = "cursor",
                position = {
                    row = 1,
                    col = 0,
                },
                size = {
                    -- minimum width 20
                    width = math.max(20, vim.api.nvim_strwidth(default_value)),
                },
                border = {
                    style = "rounded",
                    text = {
                        top = border_top_text,
                        top_align = "left",
                    },
                },
                win_options = {
                    winhighlight = "NormalFloat:Normal,FloatBorder:Normal",
                },
            }, {
                default_value = default_value,
                on_close = function() on_done(nil) end,
                on_submit = function(value) on_done(value) end,
            })

            -- cancel operation if cursor leaves input
            self:on(event.BufLeave, function() on_done(nil) end, { once = true })

            -- cancel operation if <Esc> is pressed
            self:map("n", "<Esc>", function() on_done(nil) end, { noremap = true, nowait = true })
        end

        local input_ui

        vim.ui.input = function(opts, on_confirm)
            assert(type(on_confirm) == "function", "missing on_confirm function")

            if input_ui then
                -- ensure single ui.input operation
                vim.api.nvim_err_writeln("busy: another input is pending!")
                return
            end

            input_ui = UIInput(opts, function(value)
                if input_ui then
                    -- if it's still mounted, unmount it
                    input_ui:unmount()
                end
                -- pass the input value
                on_confirm(value)
                -- indicate the operation is done
                input_ui = nil
            end)

            input_ui:mount()
        end
    end

    override_ui_input()
end)

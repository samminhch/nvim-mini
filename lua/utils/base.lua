local base = {}

---@class (exact) KeyMap
---@field mode string | string[]
---@field binding string
---@field action string|function
---@field options? vim.keymap.set.Opts
local KeyMap = {}

---@param binding string
---@param action function | string
---@param description string
function base.nmapd(binding, action, description) vim.keymap.set("n", binding, action, { desc = description }) end

---@param mode string | string[]
---@param binding string
---@param action function | string
---@param description string
function base.mapd(mode, binding, action, description)
    vim.keymap.set(mode, binding, action, { silent = true, desc = description })
end

---@param ... table Arrays to merge
function base.merge_arrays(...)
    local merged = {}
    for _, array in ipairs({ ... }) do
        for _, value in ipairs(array) do
            table.insert(merged, value)
        end
    end

    return merged
end

return base

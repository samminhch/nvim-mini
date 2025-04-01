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

-- See https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/util.lua
function base.root_pattern(...)
    local patterns = vim.iter({ ... }):flatten(math.huge):totable()
    local search_ancestors = function(startpath, func)
        vim.validate("func", func, "function")
        if func(startpath) then
            return startpath
        end

        local guard = 100
        for path in vim.fs.parents(startpath) do
            -- Prevent infinite recursion if our algorithm breaks
            guard = guard - 1
            if guard == 0 then
                return
            end

            if func(path) then
                return path
            end
        end
    end

    return function(startpath)
        startpath = vim.fn.substitute(startpath, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "")
        startpath = vim.fn.substitute(startpath, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")

        for _, pattern in ipairs(patterns) do
            local match = search_ancestors(startpath, function(path)
                for _, p in
                    ipairs(vim.fn.glob(table.concat({ path:gsub("([%[%]%?%*])", "\\%1"), pattern }, "/"), true, true))
                do
                    if vim.uv.fs_stat(p) then
                        return path
                    end
                end
            end)

            if match ~= nil then
                return match
            end
        end
    end
end

return base

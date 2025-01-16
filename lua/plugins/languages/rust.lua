local now, later, add = MiniDeps.now, MiniDeps.later, MiniDeps.add

now(function()
    add({
        source = "saecki/crates.nvim",
    })
end)

later(function()
    require("crates").setup({
        popup = {
            border = "rounded",
        },
        lsp = {
            enabled = true,
            on_attach = function(client, bufnr)
                -- the same on_attach function as for your other LSPs
            end,
            actions = true,
            completion = true,
            hover = true,
        },
        completion = {
            cmp = {
                enabled = true,
            },
            crates = {
                enabled = true,
            },
        },
    })
end)
